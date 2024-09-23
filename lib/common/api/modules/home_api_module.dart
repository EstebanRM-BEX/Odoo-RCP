// ignore_for_file: avoid_print

import 'package:odoo_rcp/common/api/api.dart';
import 'package:odoo_rcp/modules/home/model/res_partner_model.dart';

class HomeApiModule {
  static Future<List<Partner>> resPartnerApi() async {
    try {
      final response = await Api.callKW(
        model: "res.partner",
        method: "search_read",
        filters: [
          ['is_company', '=', true],
          ['customer', '=', true],
          ['active', '=', true],
        ],
        args: [],
        kwargs: {
          'context': {},
          'domain': [],
          'fields': ['id', 'name', 'email', 'image_128'],
          'limit': 80,
        },
      );

      if (response != null && response is List) {
        List<Partner> partners =
            (response).map((data) => Partner.fromMap(data)).toList();
        return partners;
      } else {
        print('Error resPartnerApi: response is null');
      }
    } catch (e, s) {
      print('Error resPartnerApi: $e, $s');
    }
    return [];
  }
}
