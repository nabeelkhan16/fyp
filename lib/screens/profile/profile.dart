import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trash_collector/blocs/authentication/authentication_bloc.dart';
import 'package:trash_collector/screens/profile/user_information.dart';

import 'package:trash_collector/utils/exist_alert_dialog.dart';
import 'package:trash_collector/widgets/app_bar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlobalAppBar(context, title: "Profile", leading: false),
      backgroundColor: Colors.transparent,
      body: StreamBuilder(
          stream: FirebaseAuth.instance.userChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircleAvatar(
                    maxRadius: 65,
                    child: Icon(
                      Icons.person,
                      size: 100,
                      color: Colors.white,
                    )),
              );
            }
            return Column(
              children: [
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                        onTap: () async {
                          File? file = await showModelBottomSheet(context, 'profile/${FirebaseAuth.instance.currentUser!.uid}');
                          if (file != null) {
                            await FirebaseStorage.instance
                                .ref()
                                .child('profile/${FirebaseAuth.instance.currentUser!.uid}')
                                .putFile(File(file.path))
                                .then((value) async {
                              String url = await value.ref.getDownloadURL();
                              await FirebaseAuth.instance.currentUser!.updatePhotoURL(url);
                            });
                          }
                        },
                        child: CircleAvatar(
                            maxRadius: 65,
                            child: FirebaseAuth.instance.currentUser!.photoURL != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: CachedNetworkImage(
                                      width: 130,
                                      height: 130,
                                      imageUrl: FirebaseAuth.instance.currentUser!.photoURL!,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => const Center(child: CircularProgressIndicator.adaptive()),
                                      errorWidget: (context, url, error) => const Icon(Icons.error),
                                    ))
                                : const Icon(
                                    Icons.person,
                                    size: 100,
                                    color: Colors.white,
                                  )))
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      FirebaseAuth.instance.currentUser!.displayName ?? "Put Name",
                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 26),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      FirebaseAuth.instance.currentUser!.email ?? "Put Email",
                      style: const TextStyle(fontSize: 18),
                    )
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                const SizedBox(
                  height: 15,
                ),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      Card(
                        margin: const EdgeInsets.only(left: 18, right: 18, bottom: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        child: ListTile(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const UserInformation()));
                          },
                          leading: Icon(
                            Icons.person_outline_outlined,
                            color: Theme.of(context).primaryColor,
                          ),
                          title: const Text(
                            'User Information',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios_outlined,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Card(
                        margin: const EdgeInsets.only(left: 18, right: 18, bottom: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        child: ListTile(
                          onTap: () {
                            // Navigator.pushNamed(context, Routes.settings);
                          },
                          leading: Icon(
                            Icons.privacy_tip_sharp,
                            color: Theme.of(context).primaryColor,
                          ),
                          title: const Text(
                            'Settings',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios_outlined,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Card(
                        margin: const EdgeInsets.only(left: 18, right: 18, bottom: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        child: ListTile(
                          onTap: () async {
                            context.read<AuthenticationBloc>().add(AuthenticationLogout());
                          },
                          leading: Icon(
                            Icons.logout,
                            color: Theme.of(context).primaryColor,
                          ),
                          title: const Text(
                            'Logout',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios_outlined,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            );
          }),
    );
  }
}
