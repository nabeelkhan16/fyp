part of 'bins_bloc.dart';

@immutable
sealed class BinsEvent {}


 

class GetAllBins extends BinsEvent {
 

}


class AddBin extends BinsEvent {
  final BinModel binModel;

  AddBin(this.binModel);
}

class UpdateBin extends BinsEvent {
  final BinModel binModel;

  UpdateBin(this.binModel);
}

class DeleteBin extends BinsEvent {
  final BinModel binModel;

  DeleteBin(this.binModel);
}

class GetBinById extends BinsEvent {
  final String id;

  GetBinById(this.id);
}


