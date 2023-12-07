import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:meta/meta.dart';
import 'package:trash_collector/models/user_model.dart';

part 'collector_event.dart';
part 'collector_state.dart';

class CollectorBloc extends Bloc<CollectorEvent, CollectorState> {
  CollectorBloc() : super(CollectorInitial()) {
    on<LoadAllCollectors>((event, emit) => _mapLoadAllCollectorsToState(event, emit));
  }

  _mapLoadAllCollectorsToState(LoadAllCollectors event, Emitter<CollectorState> emit) async {
    emit(CollectorLoading());
    try {
      await FirebaseFirestore.instance.collection('users').where('accountType', isEqualTo: 'collector').get().then((value) async {
        List<UserModel> collectors = [];
        value.docs.forEach((element) {
          collectors.add(UserModel.fromMap(element.data()));
        });
        emit(CollectorLoaded(collectors));
      });
    } catch (e) {
      emit(CollectorError(e.toString()));
    }
  }
}
