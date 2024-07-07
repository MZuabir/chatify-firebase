import 'package:flutter/material.dart';

import '../shared/constants.dart';

class DrawerSingleItemWidget extends StatelessWidget {
  const DrawerSingleItemWidget(
      {Key? key,
      required this.itemName,
      required this.isSelected,
      required this.icon,
      required this.ontap})
      : super(key: key);
  final String itemName;
  final bool isSelected;
  final VoidCallback ontap;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: ontap,
      selectedColor: Constants.primaryColor,
      selected: isSelected,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      leading: Icon(
        icon,
        size: 30,
      ),
      title: Text(
        itemName,
        style: const TextStyle(color: Colors.black),
      ),
    );
  }
}
