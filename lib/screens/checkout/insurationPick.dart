import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:extra_care/localization/localizationConstants.dart';
import 'package:extra_care/widgets/appBarWithArrow.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../consts.dart';

class InsurationPick extends StatefulWidget {
  @override
  _InsurationPickState createState() => _InsurationPickState();
}

class _InsurationPickState extends State<InsurationPick> {
  File _image;
  final picker = ImagePicker();
  List<File> attachmentPath = [];

  Future getImage() async {
    var image = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(image.path);
      attachmentPath.add(_image);
      Navigator.pop(this.context);
    });
  }

  Future getCameraImage() async {
    // ignore: deprecated_member_use
    var image = await picker.getImage(source: ImageSource.camera);
    setState(() {
      _image = File(image.path);
      Navigator.pop(this.context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            appBarWithArrow(context, getTranslated(context, 'pp')),
            Center(
              child: _image == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                          SizedBox(
                            height: 50,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                                child: Text(
                              getTranslated(context, 'noPic'),
                              style: TextStyle(fontSize: 20),
                            )),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          _image == null
                              ? InkWell(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (_) => Dialog(
                                              child: Padding(
                                                padding: EdgeInsets.all(16),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .stretch,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Column(
                                                            children: [
                                                              IconButton(
                                                                icon: Icon(Icons
                                                                    .camera_alt_outlined),
                                                                onPressed:
                                                                    getCameraImage, //pickVideo,
                                                              ),
                                                              Text(
                                                                getTranslated(
                                                                    context,
                                                                    'cam'),
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                          flex: 1,
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            children: [
                                                              IconButton(
                                                                icon: Icon(Icons
                                                                    .image),
                                                                onPressed:
                                                                    getImage,
                                                              ),
                                                              Text(
                                                                getTranslated(
                                                                    context,
                                                                    'gal'),
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                          flex: 1,
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ));
                                  },
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: Constants.redColor(),
                                    size: 50,
                                  ),
                                )
                              : Container()
                        ])
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              padding: EdgeInsets.only(left: 16, right: 16),
                              itemCount: attachmentPath.length,
                              itemBuilder: (ctx, index) {
                                return Card(
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0, right: 8.0),
                                              child: Text(
                                                path.basename(
                                                  attachmentPath[index].path,
                                                ),
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            flex: 1,
                                          ),
                                          IconButton(
                                              icon: Icon(Icons.delete),
                                              onPressed: () {
                                                setState(() {
                                                  attachmentPath
                                                      .removeAt(index);
                                                });
                                              })
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                );
                              }),
                        ],
                      ),
                    ),
            ),
            _image != null
                ? InkWell(
                    onTap: () async {},
                    child: Container(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Icon(
                            Icons.file_upload,
                            color: Constants.skyColor(),
                            size: 35,
                          ),
                          Text(
                            getTranslated(context, 'upload'),
                            style: TextStyle(color: Constants.skyColor()),
                          )
                        ],
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
        // floatingActionButton: FloatingActionButton(
        //   backgroundColor: Constants.skyColor(),
        //   onPressed: getImage,
        //   tooltip: getTranslated(context, 'pick'),
        //   child: Icon(Icons.add_a_photo),
        // ),
      ),
    );
  }
}
