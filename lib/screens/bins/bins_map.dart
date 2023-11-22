import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trash_collector/blocs/authentication/authentication_bloc.dart';
import 'package:trash_collector/blocs/bin/bins_bloc.dart';
import 'package:trash_collector/screens/bins/add_bin_screen.dart';
import 'package:trash_collector/screens/bins/location_utils.dart';
import 'package:trash_collector/widgets/app_bar.dart';

class BinMapScreen extends StatefulWidget {
  const BinMapScreen({super.key});

  @override
  State<BinMapScreen> createState() => _BinMapScreenState();
}

class _BinMapScreenState extends State<BinMapScreen> {
  PageController? _pageController = PageController(initialPage: 0, viewportFraction: 0.8);
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  void initState() {
    context.read<BinsBloc>().add(GetAllBins());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: BlocBuilder<BinsBloc, BinsState>(
          builder: (context, state) {
            if (state is BinsLoaded) {
              _kGooglePlex = CameraPosition(
                target: LatLng(state.bins.first.location!.latitude, state.bins.first.location!.longitude),
                zoom: 14.4746,
              );

              return Stack(
                children: [
                  GoogleMap(
                    zoomControlsEnabled: false,
                    myLocationButtonEnabled: false,
                    markers: state.bins
                        .map((e) => Marker(
                              markerId: MarkerId(e.id),
                              position: LatLng(e.location!.latitude, e.location!.longitude),
                              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
                              infoWindow: InfoWindow(
                                title: e.name!,
                                snippet: e.address!,
                              ),
                            ))
                        .toSet(),
                    mapType: MapType.normal,
                    initialCameraPosition: _kGooglePlex,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                  ),
                ],
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
        floatingActionButton: context.read<AuthenticationBloc>().userModel!.isAdmin!
            ? FloatingActionButton.extended(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AddBinScreen()));
                },
                label: const Text('Add Bin'),
                icon: const Icon(Icons.add),
              )
            : const SizedBox());
  }
}
