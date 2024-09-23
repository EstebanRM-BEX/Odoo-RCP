part of 'home_bloc.dart';

@immutable
sealed class HomeState {
}
final class HomeInitial extends HomeState {}

final class LoadingContacts extends HomeState {}

final class LoadContactsSuccess extends HomeState {
  final List<Partner> listOfPartners;
  LoadContactsSuccess({required this.listOfPartners});
}

class LoadContactsFailure extends HomeState {
  final String error;
  LoadContactsFailure({required this.error});
}

