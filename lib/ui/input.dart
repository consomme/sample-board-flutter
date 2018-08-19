import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class InputScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {

  final titleController = new TextEditingController();
  final authorController = new TextEditingController();

  Future<void> _send(String title, String author) async {
    Firestore.instance.collection('posts').document()
      .setData({
        'title': title,
        'author': author,
      });
  }

  @override
  void dispose() {
    titleController.dispose();
    authorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("input"),
      ),
      body: new Container(
        padding: const EdgeInsets.all(32.0),
        child: new Column(
          children: <Widget>[
            new TextField(
              controller: titleController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Title',
              ),
            ),
            const SizedBox(height: 24.0),
            new TextField(
              controller: authorController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Author',
              ),
            ),
            const SizedBox(height: 24.0),
            new ConstrainedBox(
              constraints: const BoxConstraints(minWidth: double.infinity),
              child: new RaisedButton(
                padding: const EdgeInsets.all(16.0),
                color: Colors.blue,
                textColor: Colors.white,
                child: new Text('Confirm', style: new TextStyle(fontSize: 16.0),),
                onPressed: () => _send(titleController.text, authorController.text)
              )
            )
          ],
        ),
      ),
    );
  }
}