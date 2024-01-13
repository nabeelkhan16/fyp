import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:trash_collector/blocs/authentication/authentication_bloc.dart';
import 'package:trash_collector/blocs/bin/bins_bloc.dart';
import 'package:trash_collector/models/bin_model.dart';
import 'package:trash_collector/models/chat_model.dart';
import 'package:trash_collector/models/user_model.dart';
import 'package:trash_collector/screens/bins/add_bin_screen.dart';
import 'package:trash_collector/screens/colllectors/bloc/collector_bloc.dart';

class CollectorMapScreen extends StatefulWidget {
  const CollectorMapScreen({super.key});

  @override
  State<CollectorMapScreen> createState() => _CollectorMapScreenState();
}

class _CollectorMapScreenState extends State<CollectorMapScreen> {
  final PageController _pageController = PageController(initialPage: 0, viewportFraction: 0.8);
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();

  UserModel? currentCollector;
  CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 13,
  );

  @override
  void initState() {
    context.read<CollectorBloc>().add(LoadAllCollectors());

    // _pageController.addListener(() async{
    // await  _controller.future.then((value)async => value.animateCamera(
    //        await CameraUpdate.newCameraPosition(
    //           CameraPosition(
    //             target: LatLng(currentCollector!.location!.latitude, currentCollector!.location!.longitude),
    //             zoom: 14.0,
    //           ),
    //         ),
    //       ));
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BlocBuilder<CollectorBloc, CollectorState>(
        builder: (context, state) {
          if (state is CollectorLoaded) {
            if (state.collectors.isNotEmpty) {
              _kGooglePlex = CameraPosition(
                target: LatLng(state.collectors[0].location!.latitude, state.collectors[0].location!.longitude),
                zoom: 13,
              );
            } else {
              _kGooglePlex = const CameraPosition(
                target: LatLng(37.42796133580664, -122.085749655962),
                zoom: 13,
              );
            }

            return Stack(
              children: [
                GoogleMap(
                  zoomControlsEnabled: false,
                  myLocationButtonEnabled: false,
                  markers: state.collectors
                      .map((e) => Marker(
                            markerId: MarkerId(e.uId!),
                            position: LatLng(e.location!.latitude, e.location!.longitude),
                            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
                            infoWindow: InfoWindow(
                              title: e.name!,
                              snippet: e.area!,
                            ),
                          ))
                      .toSet(),
                  mapType: MapType.normal,
                  initialCameraPosition: _kGooglePlex,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.isCompleted ? _controller.future.then((value) => value = controller) : _controller.complete(controller);
                  },
                ),
                Positioned(
                  height: 140,
                  width: MediaQuery.of(context).size.width,
                  bottom: 18,
                  child: PageView.builder(
                    onPageChanged: (value) async {
                      final GoogleMapController controller = await _controller.future;
                      await controller.animateCamera(
                        CameraUpdate.newCameraPosition(
                          CameraPosition(
                            target: LatLng(state.collectors[value].location!.latitude, state.collectors[value].location!.longitude),
                            zoom: 12.0,
                          ),
                        ),
                      );
                    },
                    itemCount: state.collectors.length,
                    controller: _pageController,
                    itemBuilder: (context, index) {
                      currentCollector = state.collectors[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [BoxShadow(color: Colors.black26, offset: Offset(0, 2), blurRadius: 6)]),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // const Text('User Name'),
                                    Text(state.collectors[index].name!,
                                        style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.black, fontWeight: FontWeight.bold)),
                                    // const Text('Address'),
                                    Text(state.collectors[index].area!, style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.grey)),
                                    const SizedBox(height: 10),
                                    SizedBox(
                                      width: 120,
                                      height: 30,
                                      child: TextButton(
                                          style: ButtonStyle(
                                            padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 8)),
                                            backgroundColor: MaterialStateProperty.all(Colors.blue),
                                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                              ),
                                            ),
                                          ),
                                          onPressed: () {
                                            String chatId = '';
                                            String userId = context.read<AuthenticationBloc>().userModel!.uId!;
                                            String collectorId = state.collectors[index].uId!;
                                            if (userId.hashCode >= collectorId.hashCode) {
                                              chatId = '$userId-$collectorId';
                                            } else {
                                              chatId = '$collectorId-$userId';
                                            }

                                            FirebaseFirestore.instance.collection('chats').doc(chatId).get().then((value) async {
                                              if (value.exists) {
                                                Navigator.pushNamed(context, '/chat', arguments: ChatModel.fromMap(value.data()!));
                                              } else {
                                                ChatModel chat = ChatModel(
                                                    chatId: chatId,
                                                    lastMessage: '',
                                                    lastMessageTime: DateTime.now(),
                                                    collectorName: state.collectors[index].name!,
                                                    userName: context.read<AuthenticationBloc>().userModel!.name!,
                                                    collectorId: collectorId,
                                                    userId: userId,
                                                    messages: [],
                                                    users: [userId, collectorId]);

                                                await FirebaseFirestore.instance.collection('chats').doc(chatId).set({
                                                  'chatId': chatId,
                                                  'userId': userId,
                                                  'collectorId': collectorId,
                                                  'collectorName': state.collectors[index].name,
                                                  'userName': context.read<AuthenticationBloc>().userModel!.name,
                                                  'lastMessage': '',
                                                  'lastMessageTime': DateTime.now(),
                                                  'users': [userId, collectorId],
                                                  'messages': [],
                                                }).then((value) {
                                                  Navigator.pushNamed(context, '/chat', arguments: chat);
                                                });
                                              }
                                            });
                                          },
                                          child: const Text('Message', style: TextStyle(color: Colors.white))),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                height: 84,
                                width: 84,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey.shade300,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset('assets/collector_icon.png'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
