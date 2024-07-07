import 'package:chatify_with_firebase/service/database_service.dart';
import 'package:chatify_with_firebase/shared/constants.dart';
import 'package:chatify_with_firebase/shared/helperFunctions.dart';
import 'package:chatify_with_firebase/widgets/group_tile_home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/global_appBar_widget.dart';

class GroupInfoPage extends StatefulWidget {
  const GroupInfoPage(
      {super.key,
      required this.groupId,
      required this.groupName,
      required this.adminName});
  final String groupId;
  final String groupName;
  final String adminName;

  @override
  State<GroupInfoPage> createState() => _GroupInfoPageState();
}

class _GroupInfoPageState extends State<GroupInfoPage> {
  @override
  Widget build(BuildContext context) {
    final mediaHeight = MediaQuery.of(context).size.height;
    final mediaWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size(mediaWidth, mediaHeight / 15),
            child: GlobalAppBar(
              title: widget.groupName,
              icon: Icons.exit_to_app,
              onIconTap: () {},
            )),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 20, bottom: 10),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    color: Constants.primaryColor.withOpacity(0.4)),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      foregroundColor: Colors.white,
                      backgroundColor: Constants.primaryColor,
                      child: Text(
                        widget.adminName.substring(0, 1).toUpperCase(),
                        style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Group: ',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                widget.groupName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                'Admin: ',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w400),
                              ),
                              Text(
                                widget.adminName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w400),
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Constants.primaryColor.withOpacity(0.4),
                ),
                child: const Text(
                  'Group Members',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: DatabaseService().getGroupMembers(widget.groupId),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data['members'] != null) {
                      if (snapshot.data['members'].length > 0) {
                        return ListView.builder(
                          itemCount: snapshot.data['members'].length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.only(left: 40, bottom: 20),
                              child: GroupMemberTileWidget(
                                memberName: getNameOfGroupFromFullString(
                                    snapshot.data['members'][index]),
                                memberId: getIdOfGroupFromFullString(
                                    snapshot.data['members'][index]),
                              ),
                            );
                          },
                        );
                      }
                    } else {
                      return const Center(
                        child: Text("No Members Found"),
                      );
                    }
                  }
                  return const CircularProgressIndicator();
                },
              ),
            )
          ],
        ));
  }
}

class GroupMemberTileWidget extends StatelessWidget {
  const GroupMemberTileWidget({
    super.key,
    required this.memberName,
    required this.memberId,
  });
  final String memberName;
  final String memberId;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 30,
          foregroundColor: Colors.white,
          backgroundColor: Constants.primaryColor,
          child: Text(
            memberName.substring(0, 1).toUpperCase(),
            style: const TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  memberName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Text(
                  memberId,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w400),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
