import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:odoo_rcp/common/config/constans/colors.dart';
import 'package:odoo_rcp/modules/products/bloc/products_bloc.dart';
import 'package:odoo_rcp/modules/products/model/product_template_model.dart';
import 'package:odoo_rcp/utils/validator.dart';

// ignore: must_be_immutable
class ProducDetailScreen extends StatefulWidget {
  ProducDetailScreen({Key? key, required this.products}) : super(key: key);

  final Products products;

  @override
  State<ProducDetailScreen> createState() => _ProducDetailScreenState();
}

class _ProducDetailScreenState extends State<ProducDetailScreen> {
  TextEditingController barcodeController = TextEditingController();

  @override
  void initState() {
    barcodeController.text =
        widget.products.barcode == false ? '' : widget.products.barcode;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductsBloc, ProductsState>(
      listener: (context, state) {
        if (state is UpdateProductSuccess) {
          //mensaje de exito
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Product updated successfully'),
            ),
          );
          context.read<ProductsBloc>().add(LoadProductsEvent());
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Product Detail'),
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Card(
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.category_rounded,
                                  size: 40, color: primaryColorApp),
                              const SizedBox(width: 10),
                              Expanded(
                                  child: Text('Name: ${widget.products.name}',
                                      style: const TextStyle(fontSize: 15),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis)),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(Icons.monetization_on,
                                  color: primaryColorApp, size: 40),
                              const SizedBox(width: 10),
                              Text('Price: ${widget.products.listPrice}'),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(Icons.qr_code,
                                  color: primaryColorApp, size: 40),
                              const SizedBox(width: 10),
                              Text(
                                  'BarCode: ${widget.products.barcode == false ? "No barcode" : widget.products.barcode}'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Card(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: barcodeController,
                          decoration: const InputDecoration(
                            labelText: 'Barcode',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) =>  Validator.isEmpty(value, context)
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            if (barcodeController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Barcode cannot be empty'),
                                ),
                              );
                            } else {
                              FocusScope.of(context).unfocus();

                              context.read<ProductsBloc>().add(
                                      UpdateProductEvent(
                                          id: widget.products.id ?? 0,
                                          values: {
                                        'barcode': barcodeController.text
                                      }));
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColorApp,
                            minimumSize: const Size(100, 40),
                          ),
                          child: const Text(
                            'Save',
                            style: TextStyle(color: Colors.white),
                          )),
                      const SizedBox(width: 10),
                      ElevatedButton(
                          onPressed: () {
                            Get.back();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            minimumSize: const Size(100, 40),
                            side: const BorderSide(color: primaryColorApp),
                          ),
                          child: const Text('Cancel')),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
