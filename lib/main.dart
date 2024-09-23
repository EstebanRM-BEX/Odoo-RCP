import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:odoo_rcp/modules/auth/bloc/login_bloc.dart';
import 'package:odoo_rcp/modules/auth/login_screen.dart';
import 'package:odoo_rcp/common/config/constans/colors.dart';
import 'package:odoo_rcp/modules/home/bloc/home_bloc.dart';
import 'package:odoo_rcp/modules/products/bloc/products_bloc.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => LoginBloc(),
        ),
        BlocProvider(
          create: (_) => HomeBloc(),
        ),
        BlocProvider(
          create: (_) => ProductsBloc(),
        ),

      ],
      child: GetMaterialApp(
        title: 'Material App',
         debugShowCheckedModeBanner: false,
          home:  LoginScreen(),
          theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor: Colors.grey[300],
          appBarTheme: const AppBarTheme(elevation: 0, color: primaryColorApp),
          colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: primaryColorApp,
                secondary: primaryColorApp,
              ),
        ),
      ),
    );
  }
}

