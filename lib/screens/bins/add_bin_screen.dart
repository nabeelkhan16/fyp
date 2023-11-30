import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:trash_collector/blocs/bin/bins_bloc.dart';
import 'package:trash_collector/models/bin_model.dart';
import 'package:trash_collector/models/user_model.dart';
import 'package:trash_collector/screens/bins/location_utils.dart';
import 'package:trash_collector/widgets/primary_button.dart';

class AddBinScreen extends StatefulWidget {
  const AddBinScreen({super.key});

  @override
  State<AddBinScreen> createState() => _AddBinScreenState();
}

class _AddBinScreenState extends State<AddBinScreen> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  LocationData locationData = LocationData.fromMap({"latitude": 0.0, "longitude": 0.0});
  Set<Marker> markers = {};
  UserModel collector = UserModel();
  @override
  void initState() {
    getLocation().then((value) {
      setState(() {
        _controller.future.then((controller) {
          controller.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(value.latitude, value.longitude),
              zoom: 16.4746,
            ),
          ));
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade900,
              Colors.blue.shade800,
              Colors.blue.shade700,
              Colors.blue.shade600,
            ],
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.blue.shade800,
                  Colors.blue.shade700,
                  Colors.blue.shade600,
                  Colors.blue.shade500,
                ],
              ),
            ),
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30.0),
                  Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(onTap: () => Navigator.pop(context), child: Icon(Icons.arrow_back, color: Colors.white, size: 30.0)),
                        Center(child: Text("Add Bin", style: TextStyle(color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.bold))),
                        Container(width: 30.0, height: 30.0, color: Colors.transparent)
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
                    child: TextField(
                      controller: _nameController,
                      cursorColor: Colors.blue.shade900,
                      decoration: InputDecoration(
                        hintText: 'Name',
                        hintStyle: const TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
                    child: TextField(
                      controller: _addressController,
                      cursorColor: Colors.blue.shade900,
                      decoration: InputDecoration(
                        hintText: 'Address',
                        hintStyle: const TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
                    child: DropdownSearch<String>(
                      itemAsString: (item) => item.toString(),
                      asyncItems: (text) async {
                        return await FirebaseFirestore.instance.collection("users").where("isCollector", isEqualTo: true).get().then((value) {
                          List<String> list = [];
                          for (var element in value.docs) {
                            list.add(element.data()["name"]);
                          }
                          return list;
                        });
                      },
                      dropdownButtonProps: const DropdownButtonProps(color: Colors.white, icon: Icon(Icons.arrow_drop_down, color: Colors.white)),
                      dropdownBuilder: (context, selectedItem) => Text(selectedItem != null ? selectedItem : 'Select Collector',
                          style: TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold)),
                      popupProps: PopupProps.menu(
                        menuProps: MenuProps(clipBehavior: Clip.antiAlias, borderRadius: BorderRadius.circular(20.0), elevation: 5),
                        showSelectedItems: true,
                        disabledItemFn: (String s) => s.startsWith('I'),
                      ),
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.1),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide.none,
                          ),
                          hintText: "country in menu mode",
                        ),
                      ),
                      onChanged: (value) async {
                        await FirebaseFirestore.instance.collection("users").where("name", isEqualTo: value).get().then((value) {
                          setState(() {
                            collector = UserModel.fromMap(value.docs.first.data());
                          });
                        });
                      },
                      selectedItem: collector.name,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0).copyWith(left: 30.0),
                    child: const Text("Select Bin Loaction", style: TextStyle(color: Colors.white, fontSize: 18.0)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      height: 350,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                          bottomLeft: Radius.circular(30),
                        ),
                        child: GoogleMap(
                          markers: markers,
                          zoomControlsEnabled: false,
                          mapType: MapType.normal,
                          initialCameraPosition: CameraPosition(
                            target: LatLng(locationData.latitude!, locationData.longitude!),
                            zoom: 14.4746,
                          ),
                          onTap: (Value) async {
                            setState(() {
                              locationData = LocationData.fromMap({"latitude": Value.latitude, "longitude": Value.longitude});
                              markers.clear();
                              markers.add(Marker(
                                  consumeTapEvents: true,
                                  infoWindow: InfoWindow(title: _nameController.text, snippet: _addressController.text),
                                  markerId: const MarkerId("1"),
                                  position: LatLng(Value.latitude, Value.longitude)));
                              Future.delayed(const Duration(seconds: 1), () {
                                _controller.future.then((controller) {
                                  setState(() {
                                    controller.showMarkerInfoWindow(const MarkerId("1"));
                                  });
                                });
                              });
                            });
                          },
                          onMapCreated: (GoogleMapController controller) {
                            _controller.complete(controller);
                          },
                        ),
                      ),
                    ),
                  ),
                  BlocListener<BinsBloc, BinsState>(
                    listener: (context, state) {
                      if (state is BinAdded) {
                        context.read<BinsBloc>().add(GetAllBins());
                        Navigator.pop(context);
                      }
                      if (state is BinsError) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
                      }
                    },
                    child: BlocBuilder<BinsBloc, BinsState>(
                      builder: (context, state) {
                        return Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: PrimaryButton(
                              text: "Add Bin",
                              isLoading: state is BinsLoading,
                              onPressed: () {
                                DocumentReference ref = FirebaseFirestore.instance.collection("bins").doc();
                                BlocProvider.of<BinsBloc>(context).add(AddBin(
                                  BinModel(
                                    id: ref.id,
                                    name: _nameController.text,
                                    address: _addressController.text,
                                    location: GeoPoint(locationData.latitude!, locationData.longitude!),
                                    assingedTo: collector.uId,
                                    assignedToName: collector.name,
                                  ),
                                ));
                                FirebaseFirestore.instance.collection("users").doc(collector.uId).update(
                                  {
                                    "assignedBins": FieldValue.arrayUnion([ref.id])
                                  },
                                );
                              },
                              color: Theme.of(context).primaryColor),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
