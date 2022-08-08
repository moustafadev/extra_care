import 'package:extra_care/consts.dart';
import 'package:flutter/material.dart';
import 'package:slide_countdown_clock/slide_countdown_clock.dart';

class CountDownScreen extends StatefulWidget {
  @override
  _CountDownScreenState createState() => _CountDownScreenState();
}

class _CountDownScreenState extends State<CountDownScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  Duration _duration = Duration(minutes: 2, days: 0, seconds: 0);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
      key: _scaffoldKey,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            /* Text('Slide direction Up'),
            SlideCountdownClock(
              duration: Duration(days: 0, minutes: 100),
              slideDirection: SlideDirection.Up,
              separator: ":",
              textStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              //shouldShowDay: true,
              onDone: () {
                _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Clock 1 finished')));
              },
            ),
            _buildSpace(),
            Text('Slide direction Down'),
            SlideCountdownClock(
              duration: _duration,
              slideDirection: SlideDirection.Down,
              separator: ":",
              textStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              onDone: () {
                _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Clock 1 finished')));
              },
            ),
            _buildSpace(),*/
            Text(
              'Your Order Will Delivered In :',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: SlideCountdownClock(
                duration: _duration,
                slideDirection: SlideDirection.Up,
                separator: ":",
                textStyle: TextStyle(
                  wordSpacing: 1,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                // shouldShowDays: true,
                separatorTextStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Constants.redColor(),
                ),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Constants.redColor(), shape: BoxShape.circle),
                onDone: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Your Order Had Arrived')));
                },
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
