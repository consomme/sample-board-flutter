import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sampleboard/model/post.dart';

final CollectionReference postCollection =
    Firestore.instance.collection('posts');

class FirestoreService {

  Stream<QuerySnapshot> getPostList() {
    return postCollection.orderBy('order').snapshots();
  }

  Future<Post> createPost(String body, String image, int order) {
    final TransactionHandler handler = (Transaction transaction) async {
      final DocumentSnapshot snapshot =
          await transaction.get(postCollection.document());

      final Post post = new Post(snapshot.documentID, body, image, order, 0);
      final Map<String, dynamic> data = post.toMap();
      await transaction.set(snapshot.reference, data);

      return data;
    };

    return Firestore.instance.runTransaction(handler).then((mapData) {
      return Post.fromMap(mapData);
    });
  }

  Future<dynamic> updatePost(Post post) {
    final TransactionHandler handler = (Transaction transaction) async {
      final DocumentSnapshot snapshot =
          await transaction.get(postCollection.document(post.id));

      await transaction.update(snapshot.reference, post.toMap());

      return {'updated': true};
    };

    return Firestore.instance.runTransaction(handler).then((result) {
      return result['updated'];
    });
  }
}
