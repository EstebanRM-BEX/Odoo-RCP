part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}


class LoadContactsEvent extends HomeEvent {
  LoadContactsEvent();
}