import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:trash_collector/blocs/authentication/authentication_bloc.dart';
import 'package:trash_collector/blocs/bin/bins_bloc.dart';
import 'package:trash_collector/models/bin_model.dart';
import 'package:trash_collector/screens/bins/add_bin_screen.dart';

class CollectorMapScreen extends StatefulWidget {
  const CollectorMapScreen({super.key});

  @override
  State<CollectorMapScreen> createState() => _CollectorMapScreenState();
}

class _CollectorMapScreenState extends State<CollectorMapScreen> {
  final PageController _pageController = PageController(initialPage: 0, viewportFraction: 0.8);
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  GoogleMapController? _mapController;
  BinModel? currentBin;
  CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  void initState() {
    context.read<BinsBloc>().add(GetAllBins());

    _pageController.addListener(() {
      _controller.future.then((value) => value.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(currentBin!.location!.latitude, currentBin!.location!.longitude),
                zoom: 14.0,
              ),
            ),
          ));
    });
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
                  Positioned(
                    height: 140,
                    width: MediaQuery.of(context).size.width,
                    bottom: 18,
                    child: PageView.builder(
                      onPageChanged: (value) {
                        setState(() {
                          _mapController?.moveCamera(
                            CameraUpdate.newCameraPosition(
                              CameraPosition(
                                target: LatLng(state.bins[value].location!.latitude, state.bins[value].location!.longitude),
                                zoom: 14.0,
                              ),
                            ),
                          );
                        });
                      },
                      itemCount: state.bins.length,
                      controller: _pageController,
                      itemBuilder: (context, index) {
                        currentBin = state.bins[index];
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
                                      Text(state.bins[index].name!,
                                          style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.black, fontWeight: FontWeight.bold)),
                                      // const Text('Address'),
                                      Text(state.bins[index].address!, style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.grey)),
                                      const SizedBox(height: 10),
                                      state.bins[index].assingedTo == null
                                          ? Row(
                                              children: [
                                                Text("Assigned to:",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleSmall
                                                        ?.copyWith(color: Colors.black, fontWeight: FontWeight.bold)),
                                                const SizedBox(width: 10),
                                                Text("No One", style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.red)),
                                              ],
                                            )
                                          : FutureBuilder(
                                              future: FirebaseFirestore.instance.collection('users').doc(state.bins[index].assingedTo).get(),
                                              builder: (context, AsyncSnapshot snapshot) {
                                                if (snapshot.connectionState == ConnectionState.done && !snapshot.hasData) {
                                                  return SizedBox(
                                                    width: 200.0,
                                                    height: 10,
                                                    child: Shimmer.fromColors(
                                                      baseColor: Colors.grey.shade300,
                                                      highlightColor: Colors.grey.shade100,
                                                      child: Container(
                                                        height: 10,
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(4),
                                                          color: Colors.grey.shade300,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }
                                                if (snapshot.hasData) {
                                                  return Row(
                                                    children: [
                                                      Text("Assigned to:",
                                                          style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.black)),
                                                      const SizedBox(width: 10),
                                                      Text(snapshot.data['name'],
                                                          style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.grey)),
                                                    ],
                                                  );
                                                }

                                                return SizedBox(
                                                  width: 200.0,
                                                  height: 10,
                                                  child: Shimmer.fromColors(
                                                    baseColor: Colors.grey.shade300,
                                                    highlightColor: Colors.grey.shade100,
                                                    child: Container(
                                                      height: 10,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(4),
                                                        color: Colors.grey.shade300,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
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
                                    child: Image.asset('assets/bin_icon.png'),
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
