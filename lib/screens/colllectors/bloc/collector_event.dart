part of 'collector_bloc.dart';

@immutable
sealed class CollectorEvent {}

 class LoadAllCollectors extends CollectorEvent {
 
  LoadAllCollectors( );
 }
 
