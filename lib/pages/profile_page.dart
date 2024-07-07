// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chatify_with_firebase/service/auth_service.dart';
import 'package:flutter/material.dart';

import 'package:chatify_with_firebase/shared/constants.dart';

import '../helper/helper_function.dart';
import '../widgets/single_drawer_item_widget.dart';
import '../widgets/widgets.dart';
import 'auth/login_page.dart';
import 'home_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    Key? key,
    required this.userName,
    required this.userMail,
  }) : super(key: key);
  final String userName;
  final String userMail;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.primaryColor,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(
              fontSize: 27, fontWeight: FontWeight.w700, color: Colors.white),
        ),
      ),
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
              widget.userName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black),
            ),
            Text(
              widget.userMail,
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
              isSelected: false,
              icon: Icons.group,
              ontap: () {
                gotoNextScreenReplace(context, const HomePage());
              },
            ),
            DrawerSingleItemWidget(
              itemName: 'Profile',
              isSelected: true,
              icon: Icons.person,
              ontap: () {},
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Center(
            child: Icon(
              Icons.person,
              size: 200,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Full Name',
                  style: TextStyle(fontSize: 17),
                ),
                Flexible(
                  child: Text(
                    widget.userName,
                    style: const TextStyle(fontSize: 17),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Email',
                  style: TextStyle(fontSize: 17),
                ),
                Flexible(
                  child: Text(
                    widget.userMail,
                    style: const TextStyle(fontSize: 17),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
