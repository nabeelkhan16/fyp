import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trash_collector/blocs/authentication/authentication_bloc.dart';
import 'package:trash_collector/models/chat_model.dart';
import 'package:trash_collector/models/user_model.dart';
import 'package:trash_collector/screens/home/chat_screen.dart';
import 'package:trash_collector/widgets/app_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
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
        appBar: GlobalAppBar(
          context,
          title: 'Chat',
          leading: false,
          chatcreen: false,
          trallingWidget: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications,
              color: Colors.white,
            ),
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('chats').where('users', arrayContains: FirebaseAuth.instance.currentUser?.uid).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                List<ChatModel> chats = [];
                snapshot.data!.docs.forEach((element) {
                  chats.add(ChatModel.fromMap(element.data() as Map<String, dynamic>));
                });
                return ListView.separated(
                    itemBuilder: ((context, index) {
                      var i;
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                      chat: chats[index],
                                    )),
                          );
                        },
                        child: ListTile(
                            leading: CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.grey.shade400,
                              child: const Icon(
                                Icons.person,
                                color: Colors.white,
                              ),
                            ),
                            title: Text(
                              context.read<AuthenticationBloc>().userModel?.accountType == AccountType.user
                                  ? chats[index].collectorName.toString()
                                  : chats[index].userName.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Text(
                              chats[index].lastMessage.toString(),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                                fontSize: 16,
                              ),
                            ),
                            trailing: Text(
                              // only time
                              '${DateTime.fromMicrosecondsSinceEpoch(snapshot.data!.docs[index]['lastMessageTime'].microsecondsSinceEpoch).hour}:${DateTime.fromMicrosecondsSinceEpoch(snapshot.data!.docs[index]['lastMessageTime'].microsecondsSinceEpoch).minute}',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                                fontSize: 14,
                              ),
                            )),
                      );
                    }),
                    separatorBuilder: (context, index) {
                      return Divider(
                        indent: 20,
                        endIndent: 20,
                        color: Colors.white.withOpacity(0.2),
                      );
                    },
                    itemCount: snapshot.data!.docs.length);
              }
              if (snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text(
                    'No Chats',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                    ),
                  ),
                );
              }

              return const Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }
}
