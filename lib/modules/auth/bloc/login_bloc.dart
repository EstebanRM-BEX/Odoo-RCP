// ignore_for_file: avoid_print, depend_on_referenced_packages, unnecessary_null_comparison

import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:odoo_rcp/common/api/modules/authentication_module.dart';
import 'package:odoo_rcp/common/prefs/pref_utils.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginEvent>((event, emit) {});

    on<LoginButtonPressed>((event, emit) async {
      try {
        emit(LoginLoading());
        final session = await AuthenticationModule.authenticate(
            username: "esteban.rodriguez@bexsoluciones.com",
            password: "123456");

        if (session != null) {
          PrefUtils.setIsLoggedIn(true);
          PrefUtils.setUser(jsonEncode(session));
          emit(LoginSuccess());
        } else {
          emit(LoginFailure('Autenticación fallida.'));
        }


        // authenticationAPI("esteban.rodriguez@bexsoluciones.com", "123456");


      } catch (e, s) {
        print('Error en login_bloc.dart: $e $s');
        emit(LoginFailure('Error en login_bloc.dart: $e $s'));
      }
    });
  }
}
