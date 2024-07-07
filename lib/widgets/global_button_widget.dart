import 'package:flutter/material.dart';

import '../shared/constants.dart';

class GlobalButtonWidget extends StatelessWidget {
  const GlobalButtonWidget({
    Key? key,
    required this.buttonText,
    required this.onTap,
  }) : super(key: key);

  final String buttonText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 50,
        width: double.infinity,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Constants.primaryColor,
                foregroundColor: Colors.white),
            onPressed: onTap,
            child: Text(buttonText)));
  }
}
