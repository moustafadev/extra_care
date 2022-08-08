import 'package:flutter/material.dart';
import '../consts.dart';

Widget textField(
  BuildContext context,
  String hintText, {
  TextEditingController controller,
  int max,
  bool isPhoneKeyboard = false,
}) {
  return Container(
    alignment: Alignment.center,
    height: MediaQuery.of(context).size.height * .065,
    decoration: BoxDecoration(
        color: Constants.textFieldColor(),
        border: Border.all(color: Colors.grey[400]),
        borderRadius: BorderRadius.all(Radius.circular(25))),
    child: Padding(
      padding: const EdgeInsets.only(right: 16, left: 16),
      child: TextFormField(
        maxLines: 1,
        //maxLength: 11,
        onChanged: (String txt) {},
        style: TextStyle(
          fontSize: 16,
        ),
        cursorColor: Constants.blueColor(),
        maxLength: max,
        decoration: new InputDecoration(
          errorText: null,
          counterText: "",
          border: InputBorder.none,
          labelStyle: TextStyle(
            color: Constants.skyColor(),
            fontSize: 14,
          ),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[500]),
        ),
        controller: controller,
        textInputAction: TextInputAction.done,
        keyboardType:
            isPhoneKeyboard ? TextInputType.phone : TextInputType.text,
      ),
    ),
  );
}
