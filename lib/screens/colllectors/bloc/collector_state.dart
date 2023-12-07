part of 'collector_bloc.dart';

@immutable
sealed class CollectorState {}

final class CollectorInitial extends CollectorState {}

final class CollectorLoading extends CollectorState {}

final class CollectorLoaded extends CollectorState {
  final List<UserModel> collectors;

  CollectorLoaded(this.collectors);
}

final class CollectorError extends CollectorState {
  final String message;

  CollectorError(this.message);
}
