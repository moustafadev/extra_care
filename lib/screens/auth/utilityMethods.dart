import 'package:flutter/material.dart';

import '../../appConstatnt.dart';

double getScreenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double getScreenHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

OutlineInputBorder buildOutlineInputBorder(BuildContext context) {
  return OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.grey,
      width: 1,
    ),
    borderRadius: BorderRadius.circular(5),
  );
}

InputDecoration textFiledDecoraion(String text) {
  return InputDecoration(
      border: new OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            const Radius.circular(30.0),
          ),
          borderSide: BorderSide.none),
      filled: true,
      hintStyle: new TextStyle(color: Colors.grey[400]),
      hintText: text,
      fillColor: Colors.grey[200]);
}

Widget headerLogoWidget(BuildContext context) {
  return Image.asset(
    LOGO,
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height * 0.28,
    fit: BoxFit.fill,
  );
}

TextStyle getAlertButtonTextStyle(BuildContext context) {
  return TextStyle(
      fontFamily: 'SF Pro Text',
      fontSize: getScreenWidth(context) * 0.04,
      fontWeight: FontWeight.w400,
      color: Colors.blue);
}

////////////////////////////////////////////
InputDecoration getInputDecoration(BuildContext context, String hintText,
    String iconName, Color iconColor, Function onIconTap) {
  return InputDecoration(
      contentPadding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
      hintText: hintText,
      hintStyle: normalTextStyle,
      enabled: true,
      enabledBorder: buildOutlineInputBorder(context),
      focusedBorder: buildOutlineInputBorder(context),
      disabledBorder: buildOutlineInputBorder(context),
      focusedErrorBorder: buildOutlineInputBorder(context),
      filled: true,
      // fillColor: LITE_GREY.withOpacity(OPACITY),
      fillColor: Colors.grey[300],
      suffixIcon:
          (iconName != null) ? setIcon(iconName, iconColor, onIconTap) : null);
}

Widget setIcon(String iconName, Color iconColor, Function iconTapFucntion) {
  return IconButton(
    icon: Image.asset(
      iconName,
    ),
    onPressed: (iconTapFucntion != null) ? iconTapFucntion : null,
//      color: iconColor,
  );
}
