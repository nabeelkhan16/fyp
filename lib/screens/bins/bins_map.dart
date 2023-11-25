import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trash_collector/blocs/authentication/authentication_bloc.dart';
import 'package:trash_collector/blocs/bin/bins_bloc.dart';
import 'package:trash_collector/screens/bins/add_bin_screen.dart';

class BinMapScreen extends StatefulWidget {
  const BinMapScreen({super.key});

  @override
  State<BinMapScreen> createState() => _BinMapScreenState();
}

class _BinMapScreenState extends State<BinMapScreen> {
  final PageController _pageController =
      PageController(initialPage: 0, viewportFraction: 0.8);
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  GoogleMapController? _mapController;

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
                target: LatLng(state.bins.first.location!.latitude,
                    state.bins.first.location!.longitude),
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
                              position: LatLng(
                                  e.location!.latitude, e.location!.longitude),
                              icon: BitmapDescriptor.defaultMarkerWithHue(
                                  BitmapDescriptor.hueGreen),
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
                  Positioned(
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    bottom: 65,
                    child: PageView.builder(
                      onPageChanged: (value) {
                        setState(() {
                          _mapController?.moveCamera(
                            CameraUpdate.newCameraPosition(
                              CameraPosition(
                                target: LatLng(
                                    state.bins[value].location!.latitude,
                                    state.bins[value].location!.longitude),
                                zoom: 14.0,
                              ),
                            ),
                          );
                        });
                      },
                      itemCount: state.bins.length,
                      controller: _pageController,
                      itemBuilder: (context, index) {
                        return Container(
                          height: 200,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 20),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.black26,
                                    offset: Offset(0, 2),
                                    blurRadius: 6)
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // const Text('User Name'),
                                    Text(state.bins[index].name!),
                                    // const Text('Address'),
                                    Text(state.bins[index].address!),
                                    Container(
                                      alignment: Alignment.center,
                                      width: 150,
                                      child: TextButton(
                                        onPressed: () {},
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.grey.shade300),
                                        ),
                                        child: const Row(
                                          children: [
                                            Text('Locate on map'),
                                            Icon(Icons.location_on),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey.shade300,
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
        floatingActionButton:
            context.read<AuthenticationBloc>().userModel!.isAdmin!
                ? FloatingActionButton.extended(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddBinScreen()));
                    },
                    label: const Text('Add Bin'),
                    icon: const Icon(Icons.add),
                  )
                : const SizedBox());
  }
}
