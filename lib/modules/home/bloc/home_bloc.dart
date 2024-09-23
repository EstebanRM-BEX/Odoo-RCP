// ignore_for_file: avoid_print, depend_on_referenced_packages, unnecessary_type_check, unnecessary_null_comparison

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:odoo_rcp/common/api/modules/home_api_module.dart';
import 'package:odoo_rcp/modules/home/model/res_partner_model.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final List<Partner> _listOfPartners = [];

  HomeBloc() : super(HomeInitial()) {
    on<LoadContactsEvent>(_onLoadContactsEvent);
    add(LoadContactsEvent());
  }

  void _onLoadContactsEvent(
      LoadContactsEvent event, Emitter<HomeState> emit) async {
    try {
      emit(LoadingContacts());
      final response = await HomeApiModule.resPartnerApi();
      if (response != null && response is List) {
        _listOfPartners.clear();
        _listOfPartners.addAll(response);
        emit(LoadContactsSuccess(listOfPartners: _listOfPartners));
      } else {
        print('Error resProductsApi: response is null');
      }
    } catch (e, s) {
      print('Error LoadContactsEvent: $e, $s');
      emit(LoadContactsFailure(error: e.toString())); // Manejar errores
    }
  }
}
