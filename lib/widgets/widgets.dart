import 'package:chatify_with_firebase/shared/constants.dart';
import 'package:chatify_with_firebase/widgets/global_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

const textinputDecoration = InputDecoration(
  labelStyle: TextStyle(color: Colors.black),
  focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Constants.primaryColor, width: 2)),
  errorBorder:
      OutlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 2)),
  enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Constants.primaryColor, width: 2)),
);

void gotoNextScreen(BuildContext context, nextPage) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => nextPage));
}

void gotoNextScreenReplace(BuildContext context, nextPage) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => nextPage));
}

void gotNextScreenRemoveUntill(BuildContext context, nextPage) {
  Navigator.pushAndRemoveUntil(context,
      MaterialPageRoute(builder: (context) => nextPage), (route) => false);
}

showToastMessage(String message) {
  return Fluttertoast.showToast(
      msg: message,
      textColor: Colors.white,
      backgroundColor: Constants.primaryColor);
}

showDialogBox(
    BuildContext context,
    String titleText,
    String firstBtnTxt,
    VoidCallback firstBtnOnTap,
    String secondBtnTxt,
    VoidCallback secondBtnOnTap) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          titleTextStyle: const TextStyle(
              fontSize: 16,
              color: Constants.primaryColor,
              fontWeight: FontWeight.bold),
          title: Text(
            titleText,
            textAlign: TextAlign.center,
          ),
          actions: [
            Row(
              children: [
                Flexible(
                  child: GlobalButtonWidget(
                    buttonText: firstBtnTxt,
                    onTap: firstBtnOnTap,
                  ),
                ),
                const SizedBox(width: 20),
                Flexible(
                  child: GlobalButtonWidget(
                    buttonText: secondBtnTxt,
                    onTap: secondBtnOnTap,
                  ),
                ),
              ],
            )

            // ElevatedButton(onPressed: () {}, child: Text('No'))
          ],
        );
      });
}

showCrateGroupDialog(BuildContext context, ValueChanged textFieldvalueChanged,
    bool isLoading, VoidCallback onCreateTap) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text(
          'Create Group',
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              onChanged: textFieldvalueChanged,
              decoration: InputDecoration(
                  label: const Text('Group Name'),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide:
                          const BorderSide(color: Constants.primaryColor)),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide:
                          const BorderSide(color: Constants.primaryColor)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide:
                          const BorderSide(color: Constants.primaryColor))),
            )
          ],
        ),
        actions: [
          isLoading == false
              ? GlobalButtonWidget(
                  buttonText: 'Create Group',
                  onTap: onCreateTap,
                )
              : const CircularProgressIndicator(
                  color: Constants.primaryColor,
                ),
        ],
      );
    },
  );
}
