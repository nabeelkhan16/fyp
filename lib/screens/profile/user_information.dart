import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trash_collector/blocs/authentication/authentication_bloc.dart';
import 'package:trash_collector/models/user_model.dart';
import 'package:trash_collector/widgets/app_bar.dart';
import 'package:trash_collector/widgets/globle_textFiled.dart';
import 'package:trash_collector/widgets/primary_button.dart';

class UserInformation extends StatefulWidget {
  final bool isFromProfile;

  const UserInformation({Key? key, this.isFromProfile = true}) : super(key: key);

  @override
  State<UserInformation> createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
  TextEditingController displayNameController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlobalAppBar(context, title: 'User Information', leading: widget.isFromProfile),
      body: Padding(
        padding: const EdgeInsets.all(8.0).copyWith(top: 30),
        child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (widget.isFromProfile) {
                  UserModel user = UserModel.fromMap(snapshot.data.data());
                  displayNameController.text = user.name ?? '';
                  contactNumberController.text = user.phoneNo ?? '';
                }

                return Column(
                  children: [
                    GlobalTextField(hintText: 'Display Name', controller: displayNameController),
                    const SizedBox(height: 10),
                    GlobalTextField(
                      hintText: 'Contact Number',
                      controller: contactNumberController,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
                      child: PrimaryButton(
                        isLoading: isLoading,
                        color: Theme.of(context).primaryColor,
                        text: 'Update',
                        onPressed: () async {
                          setState(() {
                            isLoading = true;
                          });
                          await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).set(
                              UserModel(
                                      email: FirebaseAuth.instance.currentUser!.email,
                                      name: displayNameController.text,
                                      phoneNo: contactNumberController.text)
                                  .toMap(),
                              SetOptions(merge: true));
                          setState(() {
                            isLoading = false;
                          });
                          if (widget.isFromProfile) {
                            Navigator.pop(context);
                          } else {
                            context.read<AuthenticationBloc>().add(AuthenticationCheck());
                          }
                        },
                      ),
                    ),
                  ],
                );
              }
              if (snapshot.hasError) return const Center(child: Text('Something went wrong'));
              return const Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }
}
