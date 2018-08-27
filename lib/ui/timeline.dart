import 'dart:async';

import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sampleboard/model/post.dart';
import 'package:sampleboard/ui/input.dart';

import 'package:sampleboard/service/firestore_service.dart';

class TimelineScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  List<Post> _posts;

  FirestoreService db = new FirestoreService();

  StreamSubscription<QuerySnapshot> postSubscription;

  Future _favorite(String id) async {
    final TransactionHandler transaction = (Transaction tx) async {
      final DocumentSnapshot snapshot =
          await tx.get(Firestore.instance.collection('posts').document(id));

      int favorite = snapshot.data['favorite'];
      snapshot.data['favorite'] = favorite + 1;
      await tx.update(snapshot.reference, snapshot.data);
    };

    Firestore.instance.runTransaction(transaction);
  }

  @override
  void initState() {
    super.initState();

    _posts = new List();

    postSubscription?.cancel();
    postSubscription = db.getPostList().listen((QuerySnapshot snapshot) {
      final List<Post> posts = snapshot.documents
          .map((snapshot) => Post.fromMap(snapshot.data))
          .toList();

      setState(() {
        _posts = posts;
      });
    });
  }

  @override
    void dispose() {
      postSubscription?.cancel();
      super.dispose();
    }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("timeline"),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: _posts.length,
          padding: const EdgeInsets.all(8.0),
          itemBuilder: (context, position) {
            return Card(
              child: new Column(
                children: <Widget>[
                  new CachedNetworkImage(
                    imageUrl: _posts[position].image,
                    placeholder: new CircularProgressIndicator(),
                    errorWidget: new Icon(Icons.error),
                    fit: BoxFit.fitWidth,
                  ),
                  new Container(
                    padding: const EdgeInsets.all(16.0),
                    child: new Row(
                      children: <Widget>[
                        new Expanded(
                          child: new Text(_posts[position].body),
                        ),
                        new GestureDetector(
                          onTap: () {
                            _favorite(_posts[position].id);
                          },
                          child: new Row(
                            children: <Widget>[
                              new Icon(
                                Icons.favorite,
                                color: Colors.red[500],
                              ),
                              new Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: new Text(
                                    _posts[position].favorite.toString()),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.edit),
        onPressed: () {
          Navigator.push(context,
              new MaterialPageRoute(builder: (context) => new InputScreen()));
        },
      ),
    );
  }
}
