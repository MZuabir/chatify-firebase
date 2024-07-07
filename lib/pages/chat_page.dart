import 'package:chatify_with_firebase/pages/group_info_page.dart';
import 'package:chatify_with_firebase/service/database_service.dart';
import 'package:chatify_with_firebase/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../widgets/global_appBar_widget.dart';

class ChatPage extends StatefulWidget {
  const ChatPage(
      {super.key,
      required this.groupId,
      required this.groupName,
      required this.userName});
  final String groupId;
  final String groupName;
  final String userName;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Stream<QuerySnapshot>? chats;
  String adminName = '';
  @override
  void initState() {
    getChatAndAdmin();
    super.initState();
  }

  getChatAndAdmin() {
    DatabaseService().getChats(widget.groupId).then((value) {
      setState(() {
        chats = value;
      });
    });
    DatabaseService().getGroupAdmin(widget.groupId).then((value) {
      setState(() {
        adminName = value;
      });
    });
  }

  String getNameOfAdminFromFullString(String res) {
    return res.substring(res.indexOf('_') + 1);
  }

  @override
  Widget build(BuildContext context) {
    final mediaHeight = MediaQuery.of(context).size.height;
    final mediaWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size(mediaWidth, mediaHeight / 15),
          child: GlobalAppBar(
            icon: Icons.info,
            onIconTap: () {
              gotoNextScreen(
                  context,
                  GroupInfoPage(
                      groupId: widget.groupId,
                      groupName: widget.groupName,
                      adminName: getNameOfAdminFromFullString(adminName)));
            },
            title: widget.groupName,
          )),
    );
  }
}
