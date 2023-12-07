import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trash_collector/blocs/authentication/authentication_bloc.dart';
import 'package:trash_collector/constant.dart';
import 'package:trash_collector/models/chat_model.dart';
import 'package:trash_collector/models/user_model.dart';
import 'package:trash_collector/widgets/app_bar.dart';

class ChatScreen extends StatefulWidget {
  final ChatModel chat;
  const ChatScreen({super.key, required this.chat});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final textController = TextEditingController();
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
          title: context.read<AuthenticationBloc>().userModel!.accountType == AccountType.user ? widget.chat.collectorName : widget.chat.userName,
          leading: true,
          chatcreen: true,
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('chats')
                .doc(widget.chat.chatId)
                .collection('messages')
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              return Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                      child: ListView.builder(
                    reverse: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final message = snapshot.data!.docs[index];
                      return MessageBubble(
                        text: message['text'],
                        isMe: message['senderId'] == context.read<AuthenticationBloc>().userModel!.uId,
                      );
                    },
                  )),
                  Container(
                    color: Colors.grey.shade200,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12).copyWith(bottom: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: textController,
                              decoration: kMessageTextField.copyWith(
                                hintText: 'Type a message...',
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.send, color: Colors.blue),
                            onPressed: () {
                              if (textController.text.isNotEmpty) {
                                FirebaseFirestore.instance.collection('chats').doc(widget.chat.chatId).collection('messages').add({
                                  'text': textController.text,
                                  'createdAt': Timestamp.now(),
                                  'senderId': context.read<AuthenticationBloc>().userModel!.uId,
                                  'receiverId': context.read<AuthenticationBloc>().userModel!.accountType == AccountType.user
                                      ? widget.chat.collectorId
                                      : widget.chat.userId,
                                  'receiverName': context.read<AuthenticationBloc>().userModel!.accountType == AccountType.user
                                      ? widget.chat.collectorName
                                      : widget.chat.userName,
                                  'userId': context.read<AuthenticationBloc>().userModel!.uId,
                                  'userName': context.read<AuthenticationBloc>().userModel!.name,
                                });
                                FirebaseFirestore.instance.collection('chats').doc(widget.chat.chatId).update({
                                  'lastMessage': textController.text,
                                  'lastMessageTime': Timestamp.now(),
                                });
                              }

                              textController.clear();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble({super.key, required this.text, required this.isMe});
  final String text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Material(
            elevation: 2.0,
            borderRadius: BorderRadius.circular(10),
            // color: Colors.lightBlueAccent,
            // isMe! ? Colors.lightBlueAccent : Colors.white,
            color: isMe ? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 20.0,
              ),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 15.0,
                  color: isMe ? Colors.white : Colors.black54,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
