import 'package:flutter/material.dart';

import '../shared/constants.dart';

class GlobalAppBar extends StatelessWidget {
  const GlobalAppBar({
    super.key,
    required this.title,
    this.icon,
    this.onIconTap,
    this.isShowIcon = true,
  });

  final String title;
  final IconData? icon;
  final VoidCallback? onIconTap;
  final bool isShowIcon;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0,
      foregroundColor: Colors.white,
      backgroundColor: Constants.primaryColor,
      centerTitle: true,
      title: Text(
        title,
        style: const TextStyle(
            fontSize: 27, fontWeight: FontWeight.w700, color: Colors.white),
      ),
      actions: [
        isShowIcon
            ? IconButton(
                onPressed: onIconTap,
                icon: Icon(
                  icon,
                  color: Colors.white,
                ))
            : const SizedBox.shrink()
      ],
    );
  }
}
