part of 'products_bloc.dart';

@immutable
sealed class ProductsEvent {}

final class LoadProductsEvent extends ProductsEvent {}

final class UpdateProductEvent extends ProductsEvent {
  final int id;
  final Map<String, dynamic> values;

  UpdateProductEvent({required this.id, required this.values});
}

final class AddProductEvent extends ProductsEvent {
  AddProductEvent();
}
