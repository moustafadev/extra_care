import 'dart:convert';
import 'package:extra_care/api/apiService.dart';
import 'package:extra_care/widgets/appBarWithArrow.dart';
import 'package:http/http.dart' as http;
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:video_player/video_player.dart';
import '../../global/globals.dart' as globals;
import 'package:extra_care/localization/localizationConstants.dart';
import 'package:extra_care/screens/cart/mycart.dart';
import 'package:extra_care/utils/reusable.dart';
import 'package:extra_care/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import '../../consts.dart';

class AfterScan extends StatefulWidget {
  final Map details;

  const AfterScan({Key key, this.details}) : super(key: key);
  @override
  _AfterScanState createState() => _AfterScanState();
}

List adminAcceptStatusAdd;

class _AfterScanState extends State<AfterScan> {
  VideoPlayerController _controller;
  TextEditingController agree = TextEditingController();
  TextEditingController touristName = TextEditingController();
  var rating = 1.0;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isSelected = false;
  bool isSelected2 = false;
  int _itemCount = 1;
  bool medOk = false;
  bool natOk = false;
  var lang;

  LinkedScrollControllerGroup _controllers;
  ScrollController _area;
  ScrollController _places;

  bool loading = false;

  @override
  void initState() {
    super.initState();
    getLists();
    _controllers = LinkedScrollControllerGroup();
    _area = _controllers.addAndGet();
    _places = _controllers.addAndGet();
    _controller = VideoPlayerController.network(widget.details['video'])
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
    _controller.setLooping(true);
    _controller.initialize().then((_) => setState(() {}));
    _controller.play();
  }

  @override
  void dispose() {
    _area.dispose();
    _places.dispose();
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Scaffold(
          key: _scaffoldKey,
          drawer: drawer(context),
          backgroundColor: Colors.white,
          body: InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            focusColor: Colors.transparent,
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    controller: _area,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        appBarWithArrow(
                            context, getTranslated(context, 'proD')),
                        Container(
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: Container(
                                  child: Image.network(
                                    widget.details['product']['photo'],
                                    height:
                                        MediaQuery.of(context).size.height * .3,
                                    width: MediaQuery.of(context).size.width,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8, right: 12),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          .6,
                                      child: Text(
                                        widget.details['product']['p_gname'] ==
                                                null
                                            ? getTranslated(context, 'noTitle')
                                            : widget.details['product']
                                                ['p_gname'],
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.black),
                                      ),
                                    ),
                                    Text(
                                        widget.details['product']['p_price'] ==
                                                null
                                            ? getTranslated(context, 'noPrice')
                                            : widget.details['product']
                                                        ['p_price']
                                                    .toString() +
                                                getTranslated(context, 'le'),
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.black87,
                                            decoration: widget
                                                            .details['product']
                                                        ['is_discount'] ==
                                                    "0"
                                                ? null
                                                : TextDecoration.lineThrough)),
                                    Text(
                                        widget.details['product']
                                                    ['is_discount'] ==
                                                "0"
                                            ? ""
                                            : widget.details['product']
                                                        ['offer_price']
                                                    .toString() +
                                                getTranslated(context, 'le'),
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Constants.redColor(),
                                        )),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0, bottom: 8, left: 15, right: 15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        (widget.details['product']['additions']
                                                        as List)
                                                    .length ==
                                                0
                                            ? Reusable.showToast(
                                                getTranslated(context, 'havnt'))
                                            : medicalDialog(context);
                                      },
                                      child: Container(
                                        child: Text(
                                          getTranslated(context, 'medical'),
                                          style: TextStyle(
                                              fontSize: 17,
                                              color: Constants.greenColor()),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        (widget.details['product']['additions']
                                                        as List)
                                                    .length ==
                                                0
                                            ? Reusable.showToast(
                                                getTranslated(context, 'havnt'))
                                            : nutritionDialog(context);
                                      },
                                      child: Container(
                                        child: Text(
                                          getTranslated(context, 'nutrition'),
                                          style: TextStyle(
                                              fontSize: 17,
                                              color: Constants.greenColor()),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8.0, right: 12),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () {},
                                      child: Container(
                                        height: 35,
                                        //width: 100,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                              color: Colors.grey[500],
                                              style: BorderStyle.solid,
                                            ),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(25))),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8.0, right: 8),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                getTranslated(context, 'type'),
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12),
                                              ),
                                              SizedBox(width: 5),
                                              Text(
                                                widget.details['product']
                                                            ['type'] ==
                                                        null
                                                    ? getTranslated(
                                                        context, 'noType')
                                                    : widget.details['product']
                                                        ['type'],
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14),
                                              ),
                                            ],
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {},
                                      child: Container(
                                        height: 35,
                                        width: 110,
                                        decoration: BoxDecoration(
                                            color: Colors.grey[400],
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(25))),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            new IconButton(
                                              icon: new Icon(Icons.remove),
                                              onPressed: () {
                                                setState(() {
                                                  if (_itemCount > 1)
                                                    _itemCount--;
                                                });
                                              },
                                            ),
                                            new Text(
                                              _itemCount.toString(),
                                              style: TextStyle(fontSize: 15),
                                            ),
                                            new IconButton(
                                                icon: new Icon(Icons.add),
                                                onPressed: () => setState(
                                                    () => _itemCount++))
                                          ],
                                        ),
                                        alignment: Alignment.center,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        SharedPreferences preferences =
                                            await SharedPreferences
                                                .getInstance();
                                        var isLog =
                                            preferences.getBool("islog");
                                        isLog == false
                                            ? Reusable.showToast(
                                                getTranslated(context, 'open'),
                                                gravity: ToastGravity.CENTER)
                                            : upload(context);
                                      },
                                      child: Container(
                                        height: 35,
                                        width: 100,
                                        decoration: BoxDecoration(
                                            color: Constants.redColor(),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(25))),
                                        child: Text(
                                          getTranslated(context, 'addCart'),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 11),
                                        ),
                                        alignment: Alignment.center,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            getTranslated(context, 'related'),
                            textAlign: TextAlign.start,
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Directionality(
                            textDirection: TextDirection.ltr,
                            child: Container(
                              child: _controller.value.isInitialized
                                  ? AspectRatio(
                                      aspectRatio:
                                          _controller.value.aspectRatio,
                                      child: Stack(
                                        alignment: Alignment.bottomCenter,
                                        children: <Widget>[
                                          VideoPlayer(_controller),
                                          _ControlsOverlay(
                                              controller: _controller),
                                          VideoProgressIndicator(_controller,
                                              allowScrubbing: true),
                                        ],
                                      ),
                                    )
                                  : Container(),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            getTranslated(context, 'descrip'),
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Text(
                              widget.details['product']['p_desc'] == null
                                  ? getTranslated(context, 'noDis')
                                  : widget.details['product']['p_desc'],
                              style: TextStyle(
                                  color: Constants.hintColor(), fontSize: 14),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            getTranslated(context, 'side'),
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Text(
                              widget.details['product']['p_seffect'] == null
                                  ? getTranslated(context, 'noSide')
                                  : widget.details['product']['p_seffect'],
                              style: TextStyle(
                                  color: Constants.hintColor(), fontSize: 14),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        loading
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(left: 8.0, right: 8),
                                child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        .62,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(7.0)),
                                        border: Border.all(
                                            width: 1,
                                            color: Colors.grey[600],
                                            style: BorderStyle.solid)),
                                    child: Reusable.showLoader(loading)),
                              )
                            : adminAcceptStatusAdd.isNotEmpty ||
                                    adminAcceptStatusAdd.length != 0
                                ? ListView.builder(
                                    controller: _places,
                                    itemCount: adminAcceptStatusAdd.length ?? 0,
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return Card(
                                        color: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          side: BorderSide(
                                            color: Constants.skyColor(),
                                            width: 1.0,
                                          ),
                                        ),
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  children: [
                                                    Container(
                                                      width: 30,
                                                      height: 30,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Constants
                                                                .skyColor()),
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: new CircleAvatar(
                                                        child: Text(
                                                          adminAcceptStatusAdd[
                                                                          index]
                                                                      [
                                                                      'customer'] ==
                                                                  null
                                                              ? ""
                                                              : adminAcceptStatusAdd[
                                                                              index]
                                                                          [
                                                                          'customer']
                                                                      ['name']
                                                                  .toString()
                                                                  .substring(
                                                                      0, 1),
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color: Constants
                                                                  .skyColor()),
                                                        ),
                                                        // backgroundImage: NetworkImage(user.photo),
                                                        backgroundColor:
                                                            Colors.transparent,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            .6,
                                                        child: Text(
                                                          adminAcceptStatusAdd[
                                                                          index]
                                                                      [
                                                                      'customer'] ==
                                                                  null
                                                              ? getTranslated(
                                                                  context,
                                                                  'noTitle')
                                                              : adminAcceptStatusAdd[
                                                                          index]
                                                                      [
                                                                      'customer']
                                                                  ['name'],
                                                          style: TextStyle(
                                                              fontSize: 13,
                                                              color:
                                                                  Colors.black),
                                                        )),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  children: [
                                                    Directionality(
                                                        textDirection:
                                                            TextDirection.ltr,
                                                        child: SmoothStarRating(
                                                          allowHalfRating:
                                                              false,
                                                          onRated: (value) {
                                                            print(
                                                                "rating value -> $value");
                                                          },
                                                          starCount: 5,
                                                          rating: adminAcceptStatusAdd[
                                                                          index]
                                                                      [
                                                                      'rate'] ==
                                                                  null
                                                              ? 0.0
                                                              : double.parse(
                                                                  adminAcceptStatusAdd[
                                                                          index]
                                                                      ['rate']),
                                                          size: 20.0,
                                                          isReadOnly: true,
                                                          color: Colors.yellow,
                                                          borderColor:
                                                              Colors.yellow,
                                                          filledIconData:
                                                              Icons.star,
                                                          halfFilledIconData:
                                                              Icons.star_half,
                                                          defaultIconData:
                                                              Icons.star_border,
                                                          spacing: .5,
                                                        )),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      adminAcceptStatusAdd[
                                                                      index][
                                                                  'updated_at'] ==
                                                              null
                                                          ? getTranslated(
                                                              context,
                                                              'noTitle')
                                                          : adminAcceptStatusAdd[
                                                                      index]
                                                                  ['updated_at']
                                                              .toString()
                                                              .substring(0, 10),
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          color: Colors.black),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      .9,
                                                  child: Text(
                                                    adminAcceptStatusAdd[index]
                                                                ['comment'] ==
                                                            null
                                                        ? getTranslated(
                                                            context, 'noDis')
                                                        : adminAcceptStatusAdd[
                                                            index]['comment'],
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : Container(),
                        SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () async {
                            SharedPreferences preferences =
                                await SharedPreferences.getInstance();
                            var isLog = preferences.getBool("islog");
                            isLog == false
                                ? Reusable.showToast(
                                    getTranslated(context, 'open'),
                                    gravity: ToastGravity.CENTER)
                                : ratingDialog(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: Text(
                              getTranslated(context, 'addRev'),
                              style: TextStyle(
                                  fontSize: 20, color: Constants.redColor()),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ratingDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              getTranslated(context, 'review'),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: SmoothStarRating(
                        allowHalfRating: false,
                        onRated: (value) {
                          setState(() {
                            rating = value;
                          });
                          print("rating value -> $value");
                        },
                        starCount: 5,
                        rating: rating,
                        size: 40.0,
                        isReadOnly: false,
                        color: Colors.yellow,
                        borderColor: Colors.yellow,
                        filledIconData: Icons.star,
                        halfFilledIconData: Icons.star_half,
                        defaultIconData: Icons.star_border,
                        spacing: 2.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  TextField(
                    controller: touristName,
                    maxLines: 3,
                    minLines: 1,
                    textCapitalization: TextCapitalization.sentences,
                    keyboardType: TextInputType.text,
                    autocorrect: true,
                    autofocus: true,
                  ),
                  SizedBox(
                    height: 1,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              MaterialButton(
                elevation: 5.0,
                child: Text(
                  getTranslated(context, 'ok'),
                  style: TextStyle(color: Constants.skyColor()),
                ),
                onPressed: () async {
                  rate();
                },
              ),
            ],
          );
        });
  }

  dynamic rate() async {
    // ignore: unused_local_variable
    var headers;
    Reusable.showLoading(context);
    final response = await addRate(widget.details['product']['p_id'].toString(),
        touristName.value.text, rating.toString());
    var res = json.decode(response.body);

    if (res['status'] == 1) {
      Reusable.dismissLoading();
      //Reusable.showToast(res['massage'], gravity: ToastGravity.CENTER);
      touristName.clear();
      Navigator.of(context).pop();
      getLists();
    } else {
      Reusable.dismissLoading();

      Reusable.showToast(res['massage'], gravity: ToastGravity.CENTER);
    }
  }

  Future getLists() async {
    adminAcceptStatusAdd = [];
    setState(() {
      loading = true;
    });
    // print("object" + tabType);
    final loginresponse =
        await fetchReviews(widget.details['product']['p_id'].toString());
    var res = json.decode(loginresponse.body);

    // List adminDone = [];
    if (res['status'] == 1) {
      for (var item in res['data']) {
        if (mounted)
          setState(() {
            adminAcceptStatusAdd.add(item);
          });
      }
    } else {
      setState(() {
        loading = false;
      });
      //return;
    }
    if (mounted)
      setState(() {
        loading = false;
      });
  }

  Future<String> nutritionDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              getTranslated(context, 'sure'),
              style: TextStyle(fontSize: 22, color: Constants.redColor()),
            ),
            content: Text(
              getTranslated(context, 'accept') +
                  widget.details['product']['additions'][1]['price'] +
                  getTranslated(context, 'le'),
              style: TextStyle(fontSize: 14, color: Constants.blueColor()),
            ),
            actions: <Widget>[
              MaterialButton(
                elevation: 5.0,
                child: Text(getTranslated(context, 'ok')),
                onPressed: () async {
                  setState(() {
                    natOk = true;
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  Future<String> medicalDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              getTranslated(context, 'sureM'),
              style: TextStyle(fontSize: 22, color: Constants.redColor()),
            ),
            content: Text(
              getTranslated(context, 'accept') +
                  widget.details['product']['additions'][0]['price'] +
                  getTranslated(context, 'le'),
              style: TextStyle(fontSize: 14, color: Constants.blueColor()),
            ),
            actions: <Widget>[
              MaterialButton(
                elevation: 5.0,
                child: Text(getTranslated(context, 'ok')),
                onPressed: () async {
                  setState(() {
                    medOk = true;
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  Future<dynamic> upload(BuildContext context) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    String languageCode = _pref.getString(Language_Code);

    //var headers = {'Authorization': 'Bearer ' + globals.userData['token']}
    var uri = Uri.parse(
        "https://chromateck.com/laurus/api/v1/cart/add?lang=$languageCode");

    var request = new http.MultipartRequest("POST", uri);
    request.headers
        .addAll({'Authorization': 'Bearer ' + globals.userData['token']});

    if (medOk == false && natOk == false) {
      request.fields['type'] = 'product';
      request.fields['product_id'] =
          widget.details['product']['p_id'].toString();
      request.fields['quantity'] = _itemCount.toString();
    } else if (natOk = true && medOk == false) {
      request.fields['type'] = 'product';
      request.fields['product_id'] =
          widget.details['product']['p_id'].toString();
      request.fields['quantity'] = _itemCount.toString();
      request.fields['additions[1]'] = 2.toString();
    } else if (medOk == true && natOk == false) {
      request.fields['type'] = 'product';
      request.fields['product_id'] =
          widget.details['product']['p_id'].toString();
      request.fields['quantity'] = _itemCount.toString();
      request.fields['additions[0]'] = 1.toString();
    } else {
      request.fields['type'] = 'product';
      request.fields['product_id'] =
          widget.details['product']['p_id'].toString();
      request.fields['quantity'] = _itemCount.toString();
      request.fields['additions[0]'] = 1.toString();
      request.fields['additions[1]'] = 2.toString();
    }

    Reusable.showLoading(context);
    var response = await request.send();
    var responses = await http.Response.fromStream(response);
    print("responseData : " + responses.body);
    Map<String, dynamic> responseData = json.decode(responses.body);
    if (responseData['status'] == 1) {
      setState(() {
        Reusable.dismissLoading();
        // Reusable.showToast(responseData['massage'],
        //     gravity: ToastGravity.CENTER);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MyCartScreen()),
            (route) => false);
      });
    } else if (responseData['status'] == 0) {
      Reusable.dismissLoading();
      Reusable.showToast(responseData['massage'], gravity: ToastGravity.CENTER);
    }
  }
}

class _ControlsOverlay extends StatelessWidget {
  const _ControlsOverlay({Key key, this.controller}) : super(key: key);

  static const _examplePlaybackRates = [
    0.25,
    0.5,
    1.0,
    1.5,
    2.0,
    3.0,
    5.0,
    10.0,
  ];

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: Duration(milliseconds: 50),
          reverseDuration: Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? SizedBox.shrink()
              : Container(
                  color: Colors.black26,
                  child: Center(
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 100.0,
                    ),
                  ),
                ),
        ),
        GestureDetector(
          onTap: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
        Align(
          alignment: Alignment.topRight,
          child: PopupMenuButton<double>(
            initialValue: controller.value.playbackSpeed,
            tooltip: 'Playback speed',
            //color: Colors.white,
            onSelected: (speed) {
              controller.setPlaybackSpeed(speed);
            },
            itemBuilder: (context) {
              return [
                for (final speed in _examplePlaybackRates)
                  PopupMenuItem(
                    value: speed,
                    child: Text('${speed}x'),
                  )
              ];
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                // Using less vertical padding as the text is also longer
                // horizontally, so it feels like it would need more spacing
                // horizontally (matching the aspect ratio of the video).
                vertical: 12,
                horizontal: 16,
              ),
              child: Text('${controller.value.playbackSpeed}x'),
            ),
          ),
        ),
      ],
    );
  }
}
