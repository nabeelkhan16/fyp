import 'package:flutter/material.dart';
import 'package:trash_collector/constant.dart';
import 'package:trash_collector/widgets/app_bar.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlobalAppBar(
        context,
        title: 'username',
        leading: true,
        chatcreen: true,
      ),
      body: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.grey.shade300,
            child: const Icon(
              Icons.person,
              size: 40,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            'username',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            'You and username became friends on 12/12/2021',
            style: TextStyle(color: Colors.grey.shade600),
          ),
          Expanded(
            child: ListView(
              children: const [
                MessageBubble(
                  text:
                      'hello this the seending text with mmultiple lines code is working fine ',
                  isMe: true,
                ),
                MessageBubble(
                  text: 'hello this the seending text',
                  isMe: false,
                ),
                MessageBubble(
                  text: 'hello this the seending text',
                  isMe: true,
                ),
                MessageBubble(
                  text: 'hello this the recieving text',
                  isMe: false,
                ),
                MessageBubble(
                  text: 'hello this the seending text',
                  isMe: true,
                ),
                MessageBubble(
                  text: 'hello this the seending text',
                  isMe: false,
                ),
              ],
            ),
          ),
          Container(
            color: Colors.grey.shade200,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
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
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      textController.clear();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
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
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(10),
            // color: Colors.lightBlueAccent,
            // isMe! ? Colors.lightBlueAccent : Colors.white,
            color: isMe ? Colors.blue.shade700 : Colors.grey.shade300,
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
