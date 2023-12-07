import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trash_collector/blocs/authentication/authentication_bloc.dart';
import 'package:trash_collector/models/user_model.dart';
import 'package:trash_collector/screens/profile/settings.dart';

import 'package:trash_collector/utils/exist_alert_dialog.dart';
import 'package:trash_collector/widgets/app_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  AccountType? accountType;
  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: GlobalAppBar(
            context,
            title: "Profile",
            leading: false,
            chatcreen: false,
            trallingWidget: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileSettings()),
                );
              },
              child: const Padding(
                padding: EdgeInsets.all(15.0),
                child: Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          backgroundColor: Colors.transparent,
          body: NestedScrollView(
            headerSliverBuilder: ((context, innerBoxIsScrolled) {
              return <Widget>[
                SliverOverlapAbsorber(
                  handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  sliver: SliverAppBar(
                    backgroundColor: Colors.blue.shade800,
                    title: StreamBuilder(
                        stream: FirebaseAuth.instance.userChanges(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator.adaptive(),
                            );
                          }
                          return Column(
                            children: [
                              const SizedBox(
                                height: 50,
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
                                      maxRadius: 50,
                                      child: FirebaseAuth.instance.currentUser!.photoURL != null
                                          ? ClipRRect(
                                              borderRadius: BorderRadius.circular(100),
                                              child: CachedNetworkImage(
                                                width: 130,
                                                height: 130,
                                                imageUrl: FirebaseAuth.instance.currentUser!.photoURL!,
                                                fit: BoxFit.cover,
                                                placeholder: (context, url) => const Center(
                                                  child: CircularProgressIndicator.adaptive(),
                                                ),
                                                errorWidget: (context, url, error) => const Icon(Icons.error),
                                              ))
                                          : const Icon(
                                              Icons.person,
                                              size: 70,
                                              color: Colors.white,
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    context.read<AuthenticationBloc>().userModel!.name ?? "Put Name",
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 20),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    FirebaseAuth.instance.currentUser!.email ?? "Put Email",
                                    style: TextStyle(fontSize: 18, color: Colors.white.withOpacity(.5)),
                                  )
                                ],
                              ),
                              const SizedBox(height: 45),
                            ],
                          );
                        }),
                    toolbarHeight: 180,
                    collapsedHeight: 190,
                    expandedHeight: 250.0,
                    forceElevated: innerBoxIsScrolled,
                    bottom: TabBar(
                        unselectedLabelColor: Colors.white,
                        labelColor: Colors.white,
                        indicatorColor: Colors.white,
                        tabs: context.read<AuthenticationBloc>().userModel?.accountType == AccountType.admin
                            ? [
                                const Tab(
                                  text: "COLLECTORS",
                                ),
                                const Tab(
                                  text: "BINS",
                                ),
                              ]
                            : context.read<AuthenticationBloc>().userModel?.accountType == AccountType.collector
                                ? [
                                    const Tab(
                                      text: "REVIEWS",
                                    ),
                                    const Tab(
                                      text: "ASSIGNED BINS",
                                    ),
                                  ]
                                : [
                                    const Tab(
                                      text: "Related BINS",
                                    ),
                                    const Tab(
                                      text: "ASSIGNED BINS",
                                    ),
                                  ]),
                  ),
                ),
              ];
            }),
            body: accountType == AccountType.admin
                ? _adminTabs()
                : context.read<AuthenticationBloc>().userModel?.accountType == AccountType.collector
                    ? _collectorTabs()
                    : _userTabs(),
          ),
        ),
      ),
    );
  }

  _collectorTabs() {
    return TabBarView(children: [
      FutureBuilder(
          future: FirebaseFirestore.instance.collection('users').where('accountType', isEqualTo: 'user').get(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }
            if (snapshot.hasError) {
              return const Center(
                child: Text("Something went wrong"),
              );
            }
            if (snapshot.hasData) {
              QuerySnapshot data = snapshot.data as QuerySnapshot;
              return ListView.builder(
                  itemCount: data.docs.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: const Icon(
                            Icons.person,
                            color: Colors.blue,
                          ),
                        ),
                        title: Text(
                          data.docs[index]['name'],
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w300, fontSize: 20),
                        ),
                        subtitle: Text(
                          data.docs[index]['email'],
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(color: Colors.white.withOpacity(.5), fontSize: 16),
                        ),
                        trailing: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  });
            }
            return const Center(
              child: Text("No Collector Found"),
            );
          }),
      FutureBuilder(
          future: FirebaseFirestore.instance.collection('bins').get(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }
            if (snapshot.hasError) {
              return const Center(
                child: Text("Something went wrong"),
              );
            }
            if (snapshot.hasData) {
              QuerySnapshot data = snapshot.data as QuerySnapshot;
              return ListView.builder(
                  itemCount: data.docs.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: const Icon(
                            Icons.person,
                            color: Colors.blue,
                          ),
                        ),
                        title: Text(
                          data.docs[index]['name'],
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w300, fontSize: 20),
                        ),
                        subtitle: Text(
                          data.docs[index]['address'],
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(color: Colors.white.withOpacity(.5), fontSize: 16),
                        ),
                        trailing: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  });
            }
            return const Center(
              child: Text("No Bin Found"),
            );
          }),
    ]);
  }

  _adminTabs() {
    return TabBarView(
      children: [
        FutureBuilder(
            future: FirebaseFirestore.instance.collection('users').where('accountType', isEqualTo: 'collector').get(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }
              if (snapshot.hasError) {
                return const Center(
                  child: Text("Something went wrong"),
                );
              }
              if (snapshot.hasData) {
                QuerySnapshot data = snapshot.data as QuerySnapshot;
                return ListView.builder(
                    itemCount: data.docs.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: Container(
                            width: 50,
                            height: 50,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: const Icon(
                              Icons.person,
                              color: Colors.blue,
                            ),
                          ),
                          title: Text(
                            data.docs[index]['name'],
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w300, fontSize: 20),
                          ),
                          subtitle: Text(
                            data.docs[index]['email'],
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(color: Colors.white.withOpacity(.5), fontSize: 16),
                          ),
                          trailing: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    });
              }
              return const Center(
                child: Text("No Collector Found"),
              );
            }),
        FutureBuilder(
            future: FirebaseFirestore.instance.collection('bins').get(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }
              if (snapshot.hasError) {
                return const Center(
                  child: Text("Something went wrong"),
                );
              }
              if (snapshot.hasData) {
                QuerySnapshot data = snapshot.data as QuerySnapshot;
                return ListView.builder(
                    itemCount: data.docs.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: Container(
                            width: 50,
                            height: 50,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: const Icon(
                              Icons.person,
                              color: Colors.blue,
                            ),
                          ),
                          title: Text(
                            data.docs[index]['name'],
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w300, fontSize: 20),
                          ),
                          subtitle: Text(
                            data.docs[index]['address'],
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(color: Colors.white.withOpacity(.5), fontSize: 16),
                          ),
                          trailing: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    });
              }
              return const Center(
                child: Text("No Bin Found"),
              );
            }),
      ],
    );
  }

  _userTabs() {
    return TabBarView(
      children: [
        FutureBuilder(
            future: FirebaseFirestore.instance.collection('users').where('accountType', isEqualTo: 'collector').get(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }
              if (snapshot.hasError) {
                return const Center(
                  child: Text("Something went wrong"),
                );
              }
              if (snapshot.hasData) {
                QuerySnapshot data = snapshot.data as QuerySnapshot;
                return ListView.builder(
                    itemCount: data.docs.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: Container(
                            width: 50,
                            height: 50,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: const Icon(
                              Icons.person,
                              color: Colors.blue,
                            ),
                          ),
                          title: Text(
                            data.docs[index]['name'],
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w300, fontSize: 20),
                          ),
                          subtitle: Text(
                            data.docs[index]['email'],
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(color: Colors.white.withOpacity(.5), fontSize: 16),
                          ),
                          trailing: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    });
              }
              return const Center(
                child: Text("No Collector Found"),
              );
            }),
        FutureBuilder(
            future: FirebaseFirestore.instance.collection('bins').get(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }
              if (snapshot.hasError) {
                return const Center(
                  child: Text("Something went wrong"),
                );
              }
              if (snapshot.hasData) {
                QuerySnapshot data = snapshot.data as QuerySnapshot;
                return ListView.builder(
                    itemCount: data.docs.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: Container(
                            width: 50,
                            height: 50,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: const Icon(
                              Icons.person,
                              color: Colors.blue,
                            ),
                          ),
                          title: Text(
                            data.docs[index]['name'],
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w300, fontSize: 20),
                          ),
                          subtitle: Text(
                            data.docs[index]['address'],
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(color: Colors.white.withOpacity(.5), fontSize: 16),
                          ),
                          trailing: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    });
              }
              return const Center(
                child: Text("No Bin Found"),
              );
            }),
      ],
    );
  }
}
