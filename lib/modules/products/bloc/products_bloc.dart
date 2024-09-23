// ignore_for_file: avoid_print, unnecessary_type_check, unnecessary_null_comparison

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:odoo_rcp/common/api/modules/products_api_module.dart';
import 'package:odoo_rcp/modules/products/model/product_template_model.dart';
import 'package:odoo_rcp/modules/products/model/request/new_product.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  List<Products> listOfProducts = [];

  NewProductrequest newProductrequest = NewProductrequest(
    name: '',
    listPrice: 0.0,
    barcode: '',
    defaultCode: '',
    detailedType: 'product',
  );

  ProductsBloc() : super(ProductsInitial()) {
    on<LoadProductsEvent>(_onLoadProductsEvent);
    on<UpdateProductEvent>(_onUpdateProductEvent);
    on<AddProductEvent>(_onAddProductEvent);
    add(LoadProductsEvent());
  }

  void _onLoadProductsEvent(
      LoadProductsEvent event, Emitter<ProductsState> emit) async {
    try {
      emit(LoadingProducts());
      final response = await ProductsApiModule.resProductsApi();
      if (response != null && response is List) {
        listOfProducts.clear();
        listOfProducts.addAll(response);
        emit(LoadProductsSuccess(listOfProducts: listOfProducts));
      } else {
        print('Error resProductsApi: response is null');
      }
    } catch (e, s) {
      print('Error LoadContactsEvent: $e, $s');
      emit(LoadContactsFailure(error: e.toString())); // Manejar errores
    }
  }

  void _onUpdateProductEvent(
      UpdateProductEvent event, Emitter<ProductsState> emit) async {
    try {
      emit(UpdateLoadingProducts());

      final response = await ProductsApiModule.updateProductApi(
        id: event.id,
        values: event.values,
      );

      if (response) {
        emit(UpdateProductSuccess());
      } else {
        print('Error UpdateProductEvent: response is null');
      }
    } catch (e, s) {
      print('Error UpdateProductEvent: $e, $s');
      emit(UpdateProductFailure(error: e.toString()));
    }
  }

  void _onAddProductEvent(
      AddProductEvent event, Emitter<ProductsState> emit) async {
    try {
      emit(AddLoadingProducts());
      final response = await ProductsApiModule.addProductApi(
        values: newProductrequest.toMap(),
      );
      if (response) {
        emit(AddProductSuccess());
      } else {
        emit(AddProductFailure(error: 'Error adding a product'));
        print('Error AddProductEvent: response is null');
      }
    } catch (e, s) {
      print('Error AddProductEvent: $e, $s');
      emit(AddProductFailure(error: e.toString()));
    }
  }
}
