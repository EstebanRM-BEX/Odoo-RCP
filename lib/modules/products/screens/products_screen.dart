// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:odoo_rcp/common/config/constans/colors.dart';
import 'package:odoo_rcp/modules/home/home_screen.dart';
import 'package:odoo_rcp/modules/products/bloc/products_bloc.dart';
import 'package:odoo_rcp/modules/products/screens/product_detail_screend.dart';
import 'package:odoo_rcp/utils/utils.dart';
import 'package:odoo_rcp/utils/validator.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  int _selectedIndex = 1; // Índice para la pestaña seleccionada

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Cambiar el índice seleccionado
      if (index == 0) {
        // Navegar a la pantalla de contactos
        Get.offAll(() => const HomeScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductsBloc, ProductsState>(
      listener: (context, state) {
        if (state is AddProductSuccess) {
          context.read<ProductsBloc>().add(LoadProductsEvent());
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Product added successfully'),
            ),
          );
        }

        if (state is AddProductFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              title: const Text('Products'),
              actions: [
                IconButton(
                  onPressed: () {
                    showLogoutDialog();
                  },
                  icon: const Icon(Icons.exit_to_app),
                )
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                //modal para agregar un producto
                showDialog(
                    context: context,
                    builder: (context) {
                      return DialogNewProduct();
                    });
              },
              backgroundColor: primaryColorApp,
              child: const Icon(Icons.add, color: Colors.white),
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
              unselectedItemColor:
                  Colors.grey, // Color de ítems no seleccionados
            ),
            body: RefreshIndicator(
              onRefresh: () async {
                context.read<ProductsBloc>().add(LoadProductsEvent());
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemCount: context.read<ProductsBloc>().listOfProducts.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: GestureDetector(
                        onTap: () {
                          Get.to(() => ProducDetailScreen(
                              products: context
                                  .read<ProductsBloc>()
                                  .listOfProducts[index]));
                        },
                        child: Card(
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: const Icon(
                                Icons.category_rounded,
                                color: grey,
                                size: 40,
                              ),
                            ),
                            title: Text(
                                context
                                        .read<ProductsBloc>()
                                        .listOfProducts[index]
                                        .name ??
                                    '',
                                style: const TextStyle(fontSize: 18)),
                            subtitle: Column(
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.monetization_on,
                                      color: primaryColorApp,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(context
                                        .read<ProductsBloc>()
                                        .listOfProducts[index]
                                        .listPrice
                                        .toString()),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.qr_code,
                                      color: primaryColorApp,
                                    ),
                                    const SizedBox(width: 5),
                                    context
                                                .read<ProductsBloc>()
                                                .listOfProducts[index]
                                                .barcode ==
                                            false
                                        ? const Text('No barcode')
                                        : Text(context
                                            .read<ProductsBloc>()
                                            .listOfProducts[index]
                                            .barcode),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ));
      },
    );
  }
}

class DialogNewProduct extends StatelessWidget {
  DialogNewProduct({
    super.key,
  });

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Center(
          child: Text('Add Product', style: TextStyle(color: primaryColorApp))),
      content: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    context.read<ProductsBloc>().newProductrequest.name = value;
                  },
                  validator: (value) => Validator.isEmpty(value, context)),
              const SizedBox(height: 10),
              TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Barcode',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    context.read<ProductsBloc>().newProductrequest.barcode =
                        value;
                  },
                  keyboardType: TextInputType.number,
                  validator: (value) => Validator.isEmpty(value, context)),
              const SizedBox(height: 10),
              TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'code',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    context.read<ProductsBloc>().newProductrequest.defaultCode =
                        value;
                  },
                  validator: (value) => Validator.isEmpty(value, context)),
              const SizedBox(height: 10),
              TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'List Price',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    context.read<ProductsBloc>().newProductrequest.listPrice =
                        double.parse(value);
                  },
                  keyboardType: TextInputType.number,
                  validator: (value) => Validator.isEmpty(value, context)),
            ],
          ),
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                ),
                child: const Text('Cancel')),
            const SizedBox(width: 10),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColorApp,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                ),
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  if (!_formKey.currentState!.validate()) {
                    return;
                  }
                  context.read<ProductsBloc>().add(AddProductEvent());
                },
                child:
                    const Text('Save', style: TextStyle(color: Colors.white))),
          ],
        )
      ],
    );
  }
}
