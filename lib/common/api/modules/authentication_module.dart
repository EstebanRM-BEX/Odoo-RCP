// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:get/get.dart';
import 'package:odoo_rcp/common/api/api.dart';
import 'package:odoo_rcp/common/api/api_end_points.dart';
import 'package:odoo_rcp/common/config/config.dart';
import 'package:odoo_rcp/common/prefs/pref_utils.dart';
import 'package:odoo_rcp/modules/auth/login_screen.dart';
import 'package:odoo_rcp/modules/auth/models/user_model.dart';
import 'package:odoo_rcp/utils/utils.dart';

class AuthenticationModule {
  static Future<UserModel> authenticate({
    required String username,
    required String password,
  }) async {
    var params = {
      "db": Config.DB,
      "login": username,
      "password": password,
      "context": {}
    };

    try {
      var response = await Api.request(
        method: HttpMethod.post,
        path: ApiEndPoints.authenticate,
        params: Api.createPayload(params),
      );

      if (response != null) {
        return UserModel.fromJson(response);
      } else {
        throw Exception("Error de autenticación: respuesta nula");
      }
    } catch (error) {
      throw Exception("Error de autenticación: $error");
    }
  }

  ///todo hacer el método de logout

  Future<void> logoutApi() async {
    try {
      await Api.destroy();
      PrefUtils.clearPrefs();
      Get.offAll(() => LoginScreen());
    } catch (error) {
      // Manejo del error
      handleApiError(error);
      print("Error en logoutApi: $error");
    }
  }
}
