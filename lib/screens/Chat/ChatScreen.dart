import 'dart:convert';
import 'package:extra_care/widgets/drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../global/globals.dart' as globals;
import 'package:extra_care/api/apiService.dart';
import 'package:extra_care/consts.dart';
import 'package:extra_care/localization/localizationConstants.dart';
import 'package:extra_care/utils/reusable.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

List adminAcceptStatusAdd;

class _ChatScreenState extends State<ChatScreen> {
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  bool loading = false;
  var lang;
  TextEditingController chatController = TextEditingController();

  _chatBubble(i, isSameUser) {
    if (adminAcceptStatusAdd[i]['sender'] == 'admin') {
      return Column(
        children: <Widget>[
          Container(
            alignment: lang == 'en' ? Alignment.topRight : Alignment.topLeft,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.80,
              ),
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                // color: Theme.of(context).primaryColor,
                color: Constants.skyColor(),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Text(
                adminAcceptStatusAdd[i]['message'],
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          !isSameUser
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      adminAcceptStatusAdd[i]['created_at'].toString(),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black45,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 15,
                        backgroundImage: NetworkImage(
                            adminAcceptStatusAdd[i]['admin']['attachment']),
                      ),
                    ),
                  ],
                )
              : Container(
                  child: null,
                ),
        ],
      );
    } else if (adminAcceptStatusAdd[i]['sender'] == 'customer') {
      return Column(
        children: <Widget>[
          Container(
            alignment: lang == 'en' ? Alignment.topLeft : Alignment.topRight,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.80,
              ),
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey[700],
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Text(
                adminAcceptStatusAdd[i]['message'],
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          !isSameUser
              ? Row(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 15,
                        backgroundImage: NetworkImage(
                            globals.userData['user']['attachment']),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      adminAcceptStatusAdd[i]['created_at'].toString(),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black45,
                      ),
                    ),
                  ],
                )
              : Container(
                  child: null,
                ),
        ],
      );
    }
  }

  // ignore: non_constant_identifier_names
  Widget TypeMessage() {
    return Padding(
      padding: const EdgeInsets.all(8), //kant mwgoda
      child: Container(
        alignment: Alignment.center,
        //height: 60,
        child: Row(
          children: [
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width * 0.8,
              //height: 40,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: TextFormField(
                  textAlign: TextAlign.left,
                  decoration: new InputDecoration(
                      border: new OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(5.0),
                        ),
                      ),
                      hintText: getTranslated(context, 'sendMsg')),
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.newline,
                  minLines: 1,
                  maxLines: 4,
                  controller: chatController,
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.send,
                  color: chatController.text == ""
                      ? Colors.grey
                      : Constants.skyColor()),
              onPressed: () async {
                if (chatController.text == "") {
                } else {
                  sendChat();
                  chatController.clear();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  getLang() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    String languageCode = _pref.getString(Language_Code);
    setState(() {
      lang = languageCode;
    });
  }

  @override
  void initState() {
    super.initState();
    getLang();
    getLists();
  }

  @override
  Widget build(BuildContext context) {
    int prevUserId;
    return Scaffold(
      backgroundColor: Color(0xFFF6F6F6),
      key: _scaffoldkey,
      drawer: drawer(context),
      appBar: AppBar(
        backgroundColor: Colors.white,
        brightness: Brightness.dark,
        // centerTitle: true,
        title: Text(getTranslated(context, 'chat'),
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            )),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: loading
                ? Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8),
                    child: Container(
                        height: MediaQuery.of(context).size.height * .62,
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(7.0)),
                            border: Border.all(
                                width: 1,
                                color: Colors.grey[600],
                                style: BorderStyle.solid)),
                        child: Reusable.showLoader(loading)),
                  )
                : adminAcceptStatusAdd.isNotEmpty ||
                        adminAcceptStatusAdd.length != 0
                    ? ListView.builder(
                        reverse: true,
                        padding: EdgeInsets.all(20),
                        itemCount: adminAcceptStatusAdd.length,
                        itemBuilder: (BuildContext context, int index) {
                          // final ChatModels message = adminAcceptStatusAdd[index];
                          // //final Message message = messages[index];
                          // final bool isMe = message.data[index].id ==
                          //     adminAcceptStatusAdd[index].id;
                          final bool isSameUser =
                              prevUserId == adminAcceptStatusAdd[index]['id'];
                          //prevUserId = message.sender.id;
                          return _chatBubble(index, isSameUser);
                        },
                      )
                    : Padding(
                        padding: EdgeInsets.only(left: 8, right: 8, top: 4),
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 200,
                            child: Reusable.noData(
                                msg: getTranslated(context, 'noData')))),
          ),
          // _sendMessageArea(),
          TypeMessage(),
        ],
      ),
    );
  }

  Future getLists() async {
    adminAcceptStatusAdd = [];
    setState(() {
      loading = true;
    });
    // print("object" + tabType);
    final loginresponse = await fetchChatList();
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

  dynamic sendChat() async {
    //Reusable.showLoading(context);

    final response = await sendMsg(chatController.value.text);
    var res = json.decode(response.body);
    if (res['status'] == 1) {
      getLists();
    } else {
      Reusable.showToast("false", gravity: ToastGravity.CENTER);
    }
  }
}
