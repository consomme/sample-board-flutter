import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sampleboard/ui/input.dart';

class TimelineScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("timeline"),
      ),
      body: new StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('posts').orderBy('order').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return new Text('Loading...');
          return new ListView(
            children: snapshot.data.documents.map((DocumentSnapshot document) {
              return Card(
                child: new Column(
                  children: <Widget>[
                    new SizedBox(
                      height: 120.0,
                      child: Image.network(document['image']),
                    ),
                    new Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: new Text(document['body']),
                    )
                  ],
                ),
              );
            }).toList()
          );
        },
      ),
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.edit),
        onPressed: () {
          Navigator.push(context, new MaterialPageRoute(
            builder: (context) => new InputScreen()
          ));
        },
      ),
    );
  }
}