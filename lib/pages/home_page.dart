// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chatify_with_firebase/pages/auth/login_page.dart';
import 'package:chatify_with_firebase/pages/chat_page.dart';
import 'package:chatify_with_firebase/pages/profile_page.dart';
import 'package:chatify_with_firebase/service/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:chatify_with_firebase/helper/helper_function.dart';
import 'package:chatify_with_firebase/pages/search_page.dart';
import 'package:chatify_with_firebase/service/auth_service.dart';
import 'package:chatify_with_firebase/shared/constants.dart';
import 'package:chatify_with_firebase/widgets/widgets.dart';

import '../shared/helperFunctions.dart';
import '../widgets/global_appBar_widget.dart';
import '../widgets/group_tile_home_screen.dart';
import '../widgets/single_drawer_item_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthService authService = AuthService();
  DatabaseService dbhelper = DatabaseService();
  String? userName = '';
  String? email = '';
  Stream? groups;
  String textFieldValue = '';
  bool isLoading = false;
  @override
  void initState() {
    getUserData();
    super.initState();
  }

  getUserData() async {
    await HelperFunctions.getUserEmail().then((value) {
      setState(() {
        email = value;
        debugPrint('this is email $email');
      });
    });
    await HelperFunctions.getUserName().then((value) {
      setState(() {
        userName = value;
        debugPrint('this is userName $userName');
      });
    });
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getAllGroupsOfUser()
        .then((snapshot) {
      setState(() {
        groups = snapshot;
      });
    });
  }



  @override
  Widget build(BuildContext context) {
    final mediaHeight = MediaQuery.of(context).size.height;
    final mediaWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size(mediaWidth, mediaHeight / 15),
          child: GlobalAppBar(
            icon: Icons.search,
            onIconTap: () {
              gotoNextScreen(context, const SearchPage());
            },
            title: 'Groups',
          )),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 50),
          children: [
            const Icon(
              Icons.account_circle,
              size: 150,
              color: Constants.primaryColor,
            ),
            Text(
              userName ?? '',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black),
            ),
            Text(
              email ?? '',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 30),
            const Divider(
              height: 2,
              color: Constants.primaryColor,
            ),
            DrawerSingleItemWidget(
              itemName: 'Groups',
              isSelected: true,
              icon: Icons.group,
              ontap: () {},
            ),
            DrawerSingleItemWidget(
              itemName: 'Profile',
              isSelected: false,
              icon: Icons.person,
              ontap: () {
                gotoNextScreenReplace(
                    context,
                    ProfilePage(
                      userName: userName ?? '',
                      userMail: email ?? '',
                    ));
              },
            ),
            DrawerSingleItemWidget(
              itemName: 'Log Out',
              isSelected: false,
              icon: Icons.logout,
              ontap: () async {
                showDialogBox(
                  context,
                  'Are you sure you want to log out',
                  'No',
                  () {
                    Navigator.pop(context);
                  },
                  'Yes',
                  () async {
                    await authService.signOut().whenComplete(() {
                      HelperFunctions().removeAllDataFromSharePref;
                      gotNextScreenRemoveUntill(context, const LoginPage());
                    });
                  },
                );
              },
            )
          ],
        ),
      ),
      body: StreamBuilder(
        stream: groups,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data['groups'] != null) {
              if (snapshot.data['groups'].length != 0) {
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  itemCount: snapshot.data['groups'].length,
                  itemBuilder: (context, index) {
                    int reversedIndex =
                        snapshot.data['groups'].length - index - 1;
                    return GestureDetector(
                      onTap: () {
                        gotoNextScreen(
                            context,
                            ChatPage(
                                groupId: getIdOfGroupFromFullString(
                                    snapshot.data['groups'][reversedIndex]),
                                groupName: getNameOfGroupFromFullString(
                                    snapshot.data['groups'][reversedIndex]),
                                userName: userName!));
                      },
                      child: GroupTileHomePage(
                          groupName: getNameOfGroupFromFullString(
                              snapshot.data['groups'][reversedIndex]),
                          userName: userName.toString()),
                    );
                  },
                );
              } else {
                return const Center(
                    child: Text('No Groups Found. Create One Or Join!'));
              }
            } else {
              return const Center(
                  child: Text('No Groups Found. Create One Or Join!'));
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(color: Constants.primaryColor),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
          elevation: 0,
          backgroundColor: Constants.primaryColor,
          foregroundColor: Colors.white,
          onPressed: () {
            showCrateGroupDialog(
              context,
              (value) {
                setState(() {
                  textFieldValue = value;
                });
              },
              isLoading,
              () async {
                if (textFieldValue.isNotEmpty) {
                  try {
                    setState(() {
                      isLoading = true;
                    });
                    await dbhelper.createGroup(userName!,
                        FirebaseAuth.instance.currentUser!.uid, textFieldValue);
                    setState(() {
                      isLoading = false;
                    });
                    showToastMessage('Group created successfully');
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                  } catch (e) {
                    setState(() {
                      isLoading = false;
                    });
                    throw Exception(e.toString());
                  }
                }

                // Navigator.pop(context);
              },
            );
          },
          label: const Text('Create Group')),
    );
  }
}
