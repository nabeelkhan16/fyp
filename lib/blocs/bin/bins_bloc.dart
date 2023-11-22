import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:trash_collector/models/bin_model.dart';
import 'package:trash_collector/screens/bins/location_utils.dart';

part 'bins_event.dart';
part 'bins_state.dart';

class BinsBloc extends Bloc<BinsEvent, BinsState> {
  BinsBloc() : super(BinsInitial()) {
    on<GetAllBins>((event, emit) => _getAllBins(event, emit));
    on<AddBin>((event, emit) => _addBin(event, emit));
  }

  _getAllBins(GetAllBins event, Emitter<BinsState> emit) async{
    try {
      emit(BinsLoading());
      await  getLocation();
      var bins = await FirebaseFirestore.instance.collection('bins').get();
      emit(BinsLoaded(bins.docs.map((e) => BinModel.fromMap(e.data())).toList()));
    } catch (e) {
      emit(BinsError(e.toString()));
    }
  }

  _addBin(AddBin event, Emitter<BinsState> emit) async {
    try {
      emit(BinsLoading());
      await FirebaseFirestore.instance.collection('bins').doc(event.binModel.id).set(event.binModel.toMap());

      emit(BinAdded(event.binModel));
    } catch (e) {
      emit(BinsError(e.toString()));
    }
  }
}
