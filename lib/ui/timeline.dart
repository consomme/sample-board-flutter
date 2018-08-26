import 'dart:async';

import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sampleboard/ui/input.dart';

class TimelineScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {

  Future _favorite(String id) async {
    final TransactionHandler transaction = (Transaction tx) async {
      final DocumentSnapshot snapshot = await tx.get(Firestore.instance.collection('posts').document(id));

      int favorite = snapshot.data['favorite'];
      snapshot.data['favorite'] = favorite + 1;
      await tx.update(snapshot.reference, snapshot.data);
    };

    Firestore.instance.runTransaction(transaction);
  }

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
              return Container(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: new Column(
                    children: <Widget>[
                      new Image.network(
                        document['image'], 
                        fit: BoxFit.fitWidth,
                      ),
                      new Container(
                        padding: const EdgeInsets.all(16.0),
                        child: new Row(
                          children: <Widget>[
                            new Expanded(
                              child: new Text(document['body']),
                            ),
                            new GestureDetector(
                              onTap: () {
                                _favorite(document.documentID);
                              },
                              child: new Row(
                                children: <Widget>[
                                  new Icon(
                                    Icons.favorite,
                                    color: Colors.red[500],
                                  ),
                                  new Padding(
                                    padding: EdgeInsets.only(left: 8.0),
                                    child: new Text(document['favorite'].toString()),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
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