import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'intro.dart';
import '../utils/reusable.dart';
import 'buttombar/buttomBar.dart';

class Splash extends StatefulWidget {
  static const routeName = '/';
  @override
  State<StatefulWidget> createState() {
    return SplashState();
  }
}

class SplashState extends State<Splash> {
  // bool alive = true;
  // bool isLoading = false;
  // UserProvider userProvider;
  // ProductProvider productProvider;

  // init() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   bool language = prefs.getBool('language');
  //   bool login = prefs.getBool('islog');
  //   if (alive) {
  //     if (language == true && login == true) {
  //       setState(() {
  //         isLoading = true;
  //       });
  //       signIn();
  //     }
  //   } else {
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }

  // signIn() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var phone = prefs.getString('email');
  //   String pass = prefs.getString("pass");
  //   print("Shared ***************resident********************************");
  //   await userProvider.loginFunction(context, phone, pass);
  //   await productProvider.getAllCategoryList();
  //   setState(() {
  //     isLoading = true;
  //   });
  //   Navigator.pushReplacement(
  //       context, MaterialPageRoute(builder: (context) => BottomTabScreen()));
  //   print('Hello Tourist !!');
  // }

  @override
  void initState() {
    super.initState();
    // init();
    new Future.delayed(new Duration(seconds: 2), () {
      SharedPreferences.getInstance().then((value) =>
          value.getString("token") != null
              ? Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => BottomTabScreen()))
              : Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => SplashScreen())));
    });
  }

  // @override
  // void dispose() {
  //   alive = false;
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    // userProvider = Provider.of<UserProvider>(context);
    // productProvider = Provider.of<ProductProvider>(context);
    Reusable.InitScreenDims(context);
    // return isLoading == true
    //     ? Column(
    //         crossAxisAlignment: CrossAxisAlignment.center,
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: <Widget>[
    //           Container(
    //             alignment: AlignmentDirectional.center,
    //             child: Padding(
    //               padding: EdgeInsets.only(bottom: 32),
    //               child: Image.asset(
    //                 'assets/images/logo.png',
    //                 height: Reusable.getSize(context).width * 0.4,
    //                 width: Reusable.getSize(context).width * 0.4,
    //               ),
    //             ),
    //           ),
    //           CircularProgressIndicator(), //show this if state is loading
    //           Text(getTranslated(context, 'loading')),
    //         ],
    //       )
    //     :
    return Scaffold(
      body: Center(
        child: Container(
          alignment: AlignmentDirectional.center,
          child: Padding(
            padding: EdgeInsets.only(bottom: 32),
            child: Image.asset(
              'assets/images/logo.png',
              height: Reusable.getSize(context).width * 0.4,
              width: Reusable.getSize(context).width * 0.4,
            ),
          ),
        ),
      ),
    );
  }
}
