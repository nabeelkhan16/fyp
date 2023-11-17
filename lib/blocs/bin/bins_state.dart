part of 'bins_bloc.dart';

@immutable
sealed class BinsState {}

final class BinsInitial extends BinsState {}


final class BinsLoading extends BinsState {}

final class BinsLoaded extends BinsState {
  final List<BinModel> bins;

  BinsLoaded(this.bins);
}


final class BinsError extends BinsState {
  final String message;

  BinsError(this.message);
}

final class BinAdded extends BinsState {
  final BinModel binModel;

  BinAdded(this.binModel);
}

final class BinUpdated extends BinsState {
  final BinModel binModel;

  BinUpdated(this.binModel);
}

final class BinDeleted extends BinsState {
  final BinModel binModel;

  BinDeleted(this.binModel);
}

final class BinByIdLoaded extends BinsState {
  final BinModel binModel;

  BinByIdLoaded(this.binModel);
}


