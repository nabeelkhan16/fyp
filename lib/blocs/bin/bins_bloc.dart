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

  _getAllBins(GetAllBins event, Emitter<BinsState> emit) async {
    try {
      emit(BinsLoading());
      await getLocation();
      var bins = await FirebaseFirestore.instance.collection('bins').get();
      emit(BinsLoaded(bins.docs.map((e) => BinModel.fromMap(e.data())).toList()));
    } catch (e) {
      emit(BinsError(e.toString()));
    }
  }

  _addBin(AddBin event, Emitter<BinsState> emit) async {
    try {
      emit(BinsLoading());
      await FirebaseFirestore.instance.collection('bins').doc('UK3jHEj5Mj0Z8qsiMGRX').get().then((value) async {
        if (value.exists) {
          DocumentReference docRef = FirebaseFirestore.instance.collection('bins').doc();
          await FirebaseFirestore.instance.collection('bins').doc(docRef.id).set(event.binModel.copyWith(id: docRef.id).toMap()).then((value) async {
            await FirebaseFirestore.instance.collection("users").doc(event.binModel.assingedTo).update(
              {
                "assignedBins": FieldValue.arrayUnion([event.binModel.assingedTo])
              },
            );
            emit(BinAdded(event.binModel.copyWith(id: docRef.id)));
          }, onError: (e) {
            emit(BinsError(e.toString()));
          });
        } else {
          await FirebaseFirestore.instance
              .collection('bins')
              .doc('UK3jHEj5Mj0Z8qsiMGRX')
              .set(event.binModel.copyWith(id: 'UK3jHEj5Mj0Z8qsiMGRX').toMap())
              .then((value) async {
            await FirebaseFirestore.instance.collection("users").doc(event.binModel.assingedTo).update(
              {
                "assignedBins": FieldValue.arrayUnion([event.binModel.assingedTo])
              },
            );
            emit(BinAdded(event.binModel.copyWith(id: 'UK3jHEj5Mj0Z8qsiMGRX')));
          }, onError: (e) {
            emit(BinsError(e.toString()));
          });
        }
      });
    } catch (e) {
      emit(BinsError(e.toString()));
    }
  }
}
