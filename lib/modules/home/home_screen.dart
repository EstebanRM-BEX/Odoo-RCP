import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:odoo_rcp/common/config/constans/colors.dart';
import 'package:odoo_rcp/modules/home/bloc/home_bloc.dart';
import 'package:odoo_rcp/modules/products/screens/products_screen.dart';
import 'package:odoo_rcp/utils/utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Índice para la pestaña seleccionada

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Cambiar el índice seleccionado
      if (index == 1) {
        // Navegar a la pantalla de contactos
        Get.offAll(() => const ProductsScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Contacts'),
            actions: [
              IconButton(
                onPressed: () {
                  showLogoutDialog();
                },
                icon: const Icon(Icons.exit_to_app),
              )
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.contacts),
                label: 'Contacts',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.category_rounded),
                label: 'Products',
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            selectedItemColor: primaryColorApp, // Color del ítem seleccionado
            unselectedItemColor: Colors.grey, // Color de ítems no seleccionados
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              itemCount: (state is LoadContactsSuccess)
                  ? state.listOfPartners.length
                  : 0,
              itemBuilder: (context, index) {
                final listOfPartners =
                    (state as LoadContactsSuccess).listOfPartners[index];

                return Card(
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: const Icon(
                        Icons.person,
                        color: primaryColorApp,
                        size: 40,
                      ),
                    ),
                    title: Text(listOfPartners.name),
                    subtitle: Text(listOfPartners.email ?? ''),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
