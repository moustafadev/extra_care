import 'dart:async';
import 'dart:io';

import 'package:extra_care/api/models/auth.dart';
import 'package:extra_care/api/models/loading.dart';
import 'package:extra_care/api/provider/loginProvider.dart';
import 'package:extra_care/api/provider/productProvider.dart';
import 'package:extra_care/api/provider/userProvider.dart';
import 'package:extra_care/localization/demoLocalization.dart';
import 'package:extra_care/localization/localizationConstants.dart';
import 'package:extra_care/screens/buttombar/buttomBar.dart';
import 'package:extra_care/screens/intro.dart';
import 'package:extra_care/screens/notification/notification.dart';
import 'package:extra_care/utils/reusable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'global/globals.dart' as globals;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

/// Create a [AndroidNotificationChannel] for heads up notifications
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
);

/// Initialize the [FlutterLocalNotificationsPlugin] package.
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  LoginModel userModel = await Reusable.getUserModel();
  globals.userModel = userModel;
  HttpOverrides.global = new MyHttpOverrides();
  runApp(MyApp(
    userModel: userModel,
  ));
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatefulWidget {
  final LoginModel userModel;

  const MyApp({Key key, this.userModel}) : super(key: key);

  static restartApp(BuildContext context) {
    final _MyAppState state = context.findAncestorStateOfType<State<MyApp>>();
    state.restartApp();
  }

  static void setLocale(BuildContext context, Locale locale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.setLocale(locale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale;
  Key key = new UniqueKey();

  void restartApp() {
    this.setState(() {
      key = new UniqueKey();
    });
  }

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) {
      setState(() {
        this._locale = locale;
      });
    });
    super.didChangeDependencies();
  }

  @override
  initState() {
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      if (message != null) {
        // Navigator.pushNamed(context, '/message',
        //     arguments: MessageArguments(message, true));
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => NotificationScreen()));
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                //      one that already exists in example app.
                icon: 'launch_background',
              ),
            ));
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      // Navigator.pushNamed(context, '/message',
      //     arguments: MessageArguments(message, true));
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => NotificationScreen()));
    });
    FirebaseMessaging.instance.getToken().then((String token) async {
      assert(token != null);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('fcmToken', token);
      setState(() {
        print("Push Messaging token: $token");
      });
    });
    super.initState();
  }

  // Future<void> onActionSelected(String value) async {
  //   switch (value) {
  //     case 'subscribe':
  //       {
  //         print(
  //             'FlutterFire Messaging Example: Subscribing to topic "fcm_test".');
  //         await FirebaseMessaging.instance.subscribeToTopic('fcm_test');
  //         print(
  //             'FlutterFire Messaging Example: Subscribing to topic "fcm_test" successful.');
  //       }
  //       break;
  //     case 'unsubscribe':
  //       {
  //         print(
  //             'FlutterFire Messaging Example: Unsubscribing from topic "fcm_test".');
  //         await FirebaseMessaging.instance.unsubscribeFromTopic('fcm_test');
  //         print(
  //             'FlutterFire Messaging Example: Unsubscribing from topic "fcm_test" successful.');
  //       }
  //       break;
  //     case 'get_apns_token':
  //       {
  //         if (defaultTargetPlatform == TargetPlatform.iOS ||
  //             defaultTargetPlatform == TargetPlatform.macOS) {
  //           print('FlutterFire Messaging Example: Getting APNs token...');
  //           String token = await FirebaseMessaging.instance.getAPNSToken();
  //           print('FlutterFire Messaging Example: Got APNs token: $token');
  //         } else {
  //           print(
  //               'FlutterFire Messaging Example: Getting an APNs token is only supported on iOS and macOS platforms.');
  //         }
  //       }
  //       break;
  //     default:
  //       break;
  //   }
  // }

  Widget _buildDialog(BuildContext context, Item item) {
    return AlertDialog(
      content: Text("Item ${item.itemId} has been updated"),
      actions: <Widget>[
        // ignore: deprecated_member_use
        FlatButton(
          child: const Text('CLOSE'),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
        // ignore: deprecated_member_use
        FlatButton(
          child: const Text('SHOW'),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ],
    );
  }

  // ignore: unused_element
  void _showItemDialog(Map<String, dynamic> message) {
    showDialog<bool>(
      context: context,
      builder: (_) => _buildDialog(context, _itemForMessage(message)),
    ).then((bool shouldNavigate) {
      if (shouldNavigate == true) {
        _navigateToItemDetail(message);
      }
    });
  }

  void _navigateToItemDetail(Map<String, dynamic> message) {
    final Item item = _itemForMessage(message);
    // Clear away dialogs
    Navigator.popUntil(context, (Route<dynamic> route) => route is PageRoute);
    if (!item.route.isCurrent) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => NotificationScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_locale == null) {
      return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: UserProvider()),
          ChangeNotifierProvider.value(value: ProductProvider()),
          ChangeNotifierProvider.value(value: LoginUserProvider()),
          ChangeNotifierProvider(
            create: (BuildContext context) => LoadingModel(),
          ),
        ],
        child: MaterialApp(
          builder: EasyLoading.init(),
          title: 'Extra Care',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              fontFamily: "Metropolis-Light"),
          locale: _locale,
          supportedLocales: [Locale('en', 'US'), Locale('ar', 'EG')],
          localizationsDelegates: [
            DemoLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          localeResolutionCallback: (deviceLocale, supportedLocales) {
            for (var locale in supportedLocales) {
              if (locale.languageCode == deviceLocale.languageCode &&
                  locale.countryCode == deviceLocale.countryCode) {
                return deviceLocale;
              }
            }
            return supportedLocales.first;
          },
          home: getPage(widget.userModel),
          //initialRoute: Splash.routeName,
        ),
      );
    }
  }
}

Widget getPage(LoginModel userModel) {
  if (userModel == null) {
    return SplashScreen();
  } else {
    return BottomTabScreen();
  }
}

final Map<String, Item> _items = <String, Item>{};
Item _itemForMessage(Map<String, dynamic> message) {
  final dynamic data = message['data'] ?? message;
  final String itemId = data['id'];
  final Item item = _items.putIfAbsent(itemId, () => Item(itemId: itemId))
    ..status = data['status'];
  return item;
}

class Item {
  Item({this.itemId});
  final String itemId;

  StreamController<Item> _controller = StreamController<Item>.broadcast();
  Stream<Item> get onChanged => _controller.stream;

  String _status;
  String get status => _status;
  set status(String value) {
    _status = value;
    _controller.add(this);
  }

  static final Map<String, Route<void>> routes = <String, Route<void>>{};
  Route<void> get route {
    final String routeName = '/detail/$itemId';
    return routes.putIfAbsent(
      routeName,
      () => MaterialPageRoute<void>(
        settings: RouteSettings(name: routeName),
        builder: (BuildContext context) => DetailPage(itemId),
      ),
    );
  }
}

class DetailPage extends StatefulWidget {
  DetailPage(this.itemId);
  final String itemId;
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Item _item;
  StreamSubscription<Item> _subscription;

  @override
  void initState() {
    super.initState();
    _item = _items[widget.itemId];
    _subscription = _item.onChanged.listen((Item item) {
      if (!mounted) {
        _subscription.cancel();
      } else {
        setState(() {
          _item = item;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Item ${_item.itemId}"),
      ),
      body: Material(
        child: Center(child: Text("Item status: ${_item.status}")),
      ),
    );
  }
}
