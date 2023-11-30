import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:trash_collector/blocs/authentication/authentication_bloc.dart';
import 'package:trash_collector/models/user_model.dart';
import 'package:trash_collector/screens/bins/location_utils.dart';

class UserInformationForm extends StatefulWidget {
  const UserInformationForm({super.key});

  @override
  State<UserInformationForm> createState() => _UserInformationFormState();
}

class _UserInformationFormState extends State<UserInformationForm> {
  LocationData locationData = LocationData.fromMap({"latitude": 0.0, "longitude": 0.0});
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _cityController = TextEditingController();
  final _areaController = TextEditingController();
  int _isCollector = 0;

  Set<Marker> markers = {};
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.blue.shade900,
      ),
      body: Container(
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
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50.0),
                Center(
                  child: ToggleSwitch(
                    minWidth: MediaQuery.of(context).size.width * 0.5,
                    initialLabelIndex: _isCollector,
                    cornerRadius: 20.0,
                    activeFgColor: Colors.white,
                    inactiveBgColor: Colors.grey.shade400,
                    inactiveFgColor: Colors.blue,
                    totalSwitches: 2,
                    animate: true,
                    borderWidth: 1,
                    borderColor: const [
                      Colors.white54,
                      Colors.white54,
                    ],
                    labels: const ['User', 'Collector'],
                    activeBgColors: const [
                      [Colors.blue],
                      [Colors.blue]
                    ],
                    onToggle: (index) {
                      setState(() {
                        _isCollector = index ?? 0;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 18.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                      prefixIcon: const Icon(Icons.person, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 18.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextField(
                    controller: _emailController,
                    cursorColor: Colors.blue.shade900,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      hintStyle: const TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      prefixIcon: const Icon(Icons.email, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 18.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextField(
                    controller: _phoneNumberController,
                    cursorColor: Colors.blue.shade900,
                    decoration: InputDecoration(
                      hintText: 'Phone Number',
                      hintStyle: const TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      prefixIcon: const Icon(Icons.phone, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 18.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextField(
                    controller: _cityController,
                    cursorColor: Colors.blue.shade900,
                    decoration: InputDecoration(
                      hintText: 'City',
                      hintStyle: const TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      prefixIcon: const Icon(Icons.location_city_rounded, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 18.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextField(
                    controller: _areaController,
                    cursorColor: Colors.blue.shade900,
                    decoration: InputDecoration(
                      hintText: 'Area',
                      hintStyle: const TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      prefixIcon: const Icon(Icons.location_on, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 18.0),
                _isCollector == 1
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: SizedBox(
                          height: 350,
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GoogleMap(
                                zoomControlsEnabled: false,
                                mapType: MapType.normal,
                                initialCameraPosition: CameraPosition(
                                  target: LatLng(locationData.latitude ?? 0.0, locationData.longitude ?? 0.0),
                                  zoom: 16.4746,
                                ),
                                onMapCreated: (GoogleMapController controller) {
                                  if (!_controller.isCompleted) _controller.complete(controller);
                                },
                                markers: markers,
                                onTap: (LatLng latLng) {
                                  setState(() {
                                    markers.clear();
                                    markers.add(Marker(
                                      markerId: const MarkerId('1'),
                                      position: latLng,
                                    ));
                                  });
                                  _controller.future.then(
                                    (controller) {
                                      controller.animateCamera(CameraUpdate.newCameraPosition(
                                        CameraPosition(
                                          target: latLng,
                                          zoom: 16.4746,
                                        ),
                                      ));
                                    },
                                  );
                                }),
                          ),
                        ))
                    : SizedBox(),
                const SizedBox(height: 30.0),
                Center(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.blue[900],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 80.0),
                      ),
                      onPressed: () {
                        BlocProvider.of<AuthenticationBloc>(context).add(SaveUserProfile(UserModel(
                          name: _nameController.text,
                          email: _emailController.text,
                          phoneNo: _phoneNumberController.text,
                          city: _cityController.text,
                          area: _areaController.text,
                          location: markers.isNotEmpty ? GeoPoint(markers.first.position.latitude, markers.first.position.longitude) : null,
                          accountType: _isCollector == 0 ? AccountType.user : AccountType.collector,
                          isApproved: true,
                          uId: FirebaseAuth.instance.currentUser!.uid,
                        )));
                      },
                      child: const Text('Submit')),
                ),
                const SizedBox(height: 30.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
