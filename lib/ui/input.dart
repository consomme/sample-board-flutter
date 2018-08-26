import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class InputScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final bodyController = new TextEditingController();

  File _image;

  Future<void> _send(String body) async {
    Uri imageUrl;
    int time = DateTime.now().millisecondsSinceEpoch;
    String uuid = Uuid().v4();

    if(_image != null) {
      StorageUploadTask uploadTask = FirebaseStorage.instance.ref().child('image').child(uuid + '-' + time.toString()).putFile(_image);
      imageUrl = (await uploadTask.future).downloadUrl;
    }

    Firestore.instance.collection('posts').document().setData({
      'body': body,
      'image': imageUrl == null ? null : imageUrl.toString(),
      'order': -time
    }).then((_) => Navigator.pop(context));
  }

  Future _getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  @override
  void dispose() {
    bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("input"),
      ),
      body: new ListView(
        padding: const EdgeInsets.all(32.0),
        children: <Widget>[
          new Center(
            child:
                _image == null ? new Text('No image') : new Image.file(_image),
          ),
          const SizedBox(height: 24.0),
          new ConstrainedBox(
              constraints: const BoxConstraints(minWidth: double.infinity),
              child: new RaisedButton(
                  padding: const EdgeInsets.all(16.0),
                  color: Colors.green,
                  textColor: Colors.white,
                  child: new Text(
                    'Select image',
                    style: new TextStyle(fontSize: 16.0),
                  ),
                  onPressed: () => _getImage())),
          const SizedBox(height: 24.0),
          new TextField(
            controller: bodyController,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: 'Body',
            ),
          ),
          const SizedBox(height: 24.0),
          new ConstrainedBox(
              constraints: const BoxConstraints(minWidth: double.infinity),
              child: new RaisedButton(
                  padding: const EdgeInsets.all(16.0),
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: new Text(
                    'Confirm',
                    style: new TextStyle(fontSize: 16.0),
                  ),
                  onPressed: () =>
                      _send(bodyController.text)))
        ],
      ),
    );
  }
}
