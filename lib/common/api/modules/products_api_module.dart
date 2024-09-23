// ignore_for_file: avoid_print

import 'package:odoo_rcp/common/api/api.dart';
import 'package:odoo_rcp/modules/products/model/product_template_model.dart';

class ProductsApiModule {
  //*metodo para obtener los productos
  static Future<List<Products>> resProductsApi() async {
    try {
      final response = await Api.callKW(
        model: "product.template",
        method: "search_read",
        filters: [
          ['barcode', '==', false],
          ['active', '=', true],
          ['list_price', '>', 0.0],
          ['detailed_type', '=', 'product']
        ],
        args: [],
        kwargs: {
          'context': {},
          'domain': [],
          'fields': ['id', 'name', 'list_price', 'barcode', 'brand_name'],
          'limit': 80,
        },
      );

      if (response != null && response is List) {
        List<Products> products =
            (response).map((data) => Products.fromMap(data)).toList();
        return products;
      } else {
        print('Error resProductsApi: response is null');
      }
    } catch (e, s) {
      print('Error resProductsApi: $e, $s');
    }
    return [];
  }

  //*metodo para actualizar un producto por id
  static Future<bool> updateProductApi({
    required int id,
    required Map<String, dynamic> values,
  }) async {
    try {
      final response = await Api.callKW(
        model: "product.template",
        method: "write",
        filters: [],
        args: [
          [id], // Coloca el ID dentro de una lista
          values, // Pasa directamente el diccionario de valores
        ],
        kwargs: {
          'context': {},
        },
      );
      print(response);
      if (response) {
        return true;
      } else {
        print('Error updateProductApi: response is null');
        return false;
      }
    } catch (e, s) {
      print('Error updateProductApi: $e, $s');
    }
    return false;
  }

  //*metodo para agregar un producto

  static Future<bool> addProductApi({
    required Map<String, dynamic> values,
  }) async {
    try {
      final response = await Api.callKW(
        model: "product.template",
        method: "create",
        filters: [],
        args: [
          values, // Pasa directamente el diccionario de valores
        ],
        kwargs: {
          'context': {},
        },
      );
      if (response > 0) {
        return true;
      } else {
        print('Error addProductApi: response is null');
        return false;
      }
    } catch (e, s) {
      print('Error addProductApi: $e, $s');
    }
    return false;
  }
}
