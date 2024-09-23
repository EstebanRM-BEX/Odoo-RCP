part of 'products_bloc.dart';

@immutable
sealed class ProductsState {
  get listOfProducts => null;
}

final class ProductsInitial extends ProductsState {}


final class LoadingProducts extends ProductsState {}

final class LoadProductsSuccess extends ProductsState {
  @override
  final List<Products> listOfProducts;

  LoadProductsSuccess({required this.listOfProducts});
}


final class LoadContactsFailure extends ProductsState {
  final String error;

  LoadContactsFailure({required this.error});
}


final class UpdateProductSuccess extends ProductsState {}

final class UpdateProductFailure extends ProductsState {
  final String error;

  UpdateProductFailure({required this.error});
}

final class UpdateLoadingProducts extends ProductsState {}



final class AddLoadingProducts extends ProductsState {}

final class AddProductSuccess extends ProductsState {}

final class AddProductFailure extends ProductsState {
  final String error;

  AddProductFailure({required this.error});
}