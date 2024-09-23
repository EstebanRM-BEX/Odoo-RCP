// ignore_for_file: avoid_print, invalid_return_type_for_catch_error

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:odoo_rcp/common/api/api_end_points.dart';
import 'package:odoo_rcp/common/api/dio_factory.dart';
import 'package:odoo_rcp/common/config/config.dart';
import 'package:odoo_rcp/common/prefs/pref_utils.dart';
import 'package:odoo_rcp/utils/utils.dart';
import 'package:odoo_rcp/utils/widgets/log.dart';
import 'package:uuid/uuid.dart';

enum ApiEnvironment { UAT, Dev, Prod }

extension APIEnvi on ApiEnvironment {
  String get endpoint {
    switch (this) {
      case ApiEnvironment.UAT:
        return Config.OdooUATURL;
      case ApiEnvironment.Dev:
        return Config.OdooDevURL;
      case ApiEnvironment.Prod:
        return Config.OdooProdURL;
    }
  }
}

enum HttpMethod { delete, get, patch, post, put }

extension HttpMethods on HttpMethod {
  String get value {
    switch (this) {
      case HttpMethod.delete:
        return 'DELETE';
      case HttpMethod.get:
        return 'GET';
      case HttpMethod.patch:
        return 'PATCH';
      case HttpMethod.post:
        return 'POST';
      case HttpMethod.put:
        return 'PUT';
    }
  }
}

class Api {
  Api._();

  static const catchError = _catchError;

  static void _catchError(e, stackTrace, OnError onError) {
    if (!kReleaseMode) {
      print(e);
    }
    if (e is DioException) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.unknown) {
        onError('Server unreachable', {});
      } else if (e.type == DioExceptionType.badResponse) {
        final response = e.response;
        if (response != null) {
          final data = response.data;
          if (data != null && data is Map<String, dynamic>) {
            showSessionDialog();
            onError('Failed to get response: ${e.message}', data);
            return;
          }
        }
        onError('Failed to get response: ${e.message}', {});
      } else {
        onError('Request cancelled', {});
      }
    } else {
      onError(e?.toString() ?? 'Unknown error occurred', {});
    }
  }

  static Future<dynamic> request({
    required HttpMethod method,
    required String path,
    required Map params,
  }) async {
    try {
      Future.delayed(const Duration(microseconds: 1), () {
        if (path != ApiEndPoints.getVersionInfo &&
            path != ApiEndPoints.getDb &&
            path != ApiEndPoints.getDb9 &&
            path != ApiEndPoints.getDb10) showLoading();
      });

      print("Request: $path");

      Response response;
      switch (method) {
        case HttpMethod.post:
          response = await DioFactory.dio!.post(path, data: params);
          break;
        case HttpMethod.delete:
          response = await DioFactory.dio!.delete(path, data: params);
          break;
        case HttpMethod.get:
          response = await DioFactory.dio!.get(path);
          break;
        case HttpMethod.patch:
          response = await DioFactory.dio!.patch(path, data: params);
          break;
        case HttpMethod.put:
          response = await DioFactory.dio!.put(path, data: params);
          break;
      }

      hideLoading();

      if (response.data["result"] != null) {
        print(response.data);
        if (path == ApiEndPoints.authenticate) {
          _updateCookies(response.headers);
        }

        return response.data["result"];
      } else {
        // throw Exception(response.data["error"]["message"]);
      }
    } catch (error) {
      hideLoading();
      throw Exception("Error en la solicitud: $error");
    }
  }

  static _updateCookies(Headers headers) async {
    Log("Inside Update Cookie");

    // Obtén todos los valores del encabezado "set-cookie"
    List<String>? rawCookies = headers['set-cookie'];

    if (rawCookies != null && rawCookies.isNotEmpty) {
      for (var rawCookie in rawCookies) {
        Log(rawCookie);
        DioFactory.initialiseHeaders(rawCookie);
        // Guarda cada cookie si es necesario
        PrefUtils.setToken(rawCookie);
      }
    }
  }

  static Map getContext() {
    return {"lang": "en_US", "tz": "Europe/Brussels", "uid": const Uuid().v1()};
  }

  static Future<dynamic> callKW({
    required String model,
    required String method,
    required List args,
    required List filters,
    dynamic kwargs,
  }) async {
    var params = {
      "model": model,
      "method": method,
      'filters': filters,
      "args": args,
      "kwargs": kwargs ?? {},
      "context": getContext(),
    };

    try {
      var response = await request(
        method: HttpMethod.post,
        path: ApiEndPoints.getCallKWEndPoint(model, method),
        params: createPayload(params),
      );
      print(response);
      return response;
    } catch (error) {
      print("Error en callKW: $error");
      throw Exception("Error en callKW: $error");
    }
  }

static Future<dynamic> destroy() async {
  try {
    // Llamada al método `request` usando `await`
    final response = await request(
      method: HttpMethod.post,
      path: ApiEndPoints.destroy,
      params: createPayload({}),
    );
    // Retorna la respuesta en caso de éxito
    return response;
  } catch (error) {
    // Manejo de errores
    print("Error en destroy: $error");
    throw Exception("Error al destruir el recurso: $error");
  }
}


  static Map createPayload(Map params) {
    return {
      "id": const Uuid().v1(),
      "jsonrpc": "2.0",
      "method": "call",
      "params": params,
    };
  }
}
