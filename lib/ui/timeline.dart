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
              return new ListTile(
                title: new Text(document['title']),
                subtitle: new Text(document['author']),
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