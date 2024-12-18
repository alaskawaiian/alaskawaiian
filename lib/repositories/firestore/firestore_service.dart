import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

/// Generic interface for accessing Firestore.
class FirestoreService {
  // Make the class non-instantiable outside this file.
  FirestoreService._();
  // This could (should?) be a Riverpod provider, rather than a global variable
  static final instance = FirestoreService._();

  Future<void> setData({
    required String path,
    required Map<String, dynamic> data,
    bool merge = false,
  }) async {
    final reference = FirebaseFirestore.instance.doc(path);
    print('$path: $data');
    await reference.set(data, SetOptions(merge: merge));
  }

  Future<void> incrementData({
    required String path,
    required String fieldName,
    required int incrementBy
  }) async {
    final reference = FirebaseFirestore.instance.doc(path);
    print('$path: $fieldName: $incrementBy');
    await reference.update({
      fieldName: FieldValue.increment(incrementBy)
    });
  }

  Future<void> deleteData({required String path}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    print('delete: $path');
    await reference.delete();
  }

  Stream<List<T>> watchCollection<T>({
    required String path,
    required T Function(Map<String, dynamic>? data, String documentID) builder,
    Query<Map<String, dynamic>>? Function(Query<Map<String, dynamic>> query)?
        queryBuilder,
    int Function(T lhs, T rhs)? sort,
  }) {
    Query<Map<String, dynamic>> query =
        FirebaseFirestore.instance.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query)!;
    }
    final Stream<QuerySnapshot<Map<String, dynamic>>> snapshots =
        query.snapshots();
    return snapshots.map((snapshot) {
      final result = snapshot.docs
          .map((snapshot) => builder(snapshot.data(), snapshot.id))
          .where((value) => value != null)
          .toList();
      if (sort != null) {
        result.sort(sort);
      }
      return result;
    });
  }

  Stream<T> watchDocument<T>({
    required String path,
    required T Function(Map<String, dynamic>? data, String documentID) builder,
  }) {
    final DocumentReference<Map<String, dynamic>> reference =
        FirebaseFirestore.instance.doc(path);
    final Stream<DocumentSnapshot<Map<String, dynamic>>> snapshots =
        reference.snapshots();
    return snapshots.map((snapshot) => builder(snapshot.data(), snapshot.id));
  }

  /// Fetch a snapshot of a collection.
  /// Not (yet) used in this app.
  Future<List<T>> fetchCollection<T>({
    required String path,
    required T Function(Map<String, dynamic>? data, String documentID) builder,
    Query<Map<String, dynamic>>? Function(Query<Map<String, dynamic>> query)?
        queryBuilder,
    int Function(T lhs, T rhs)? sort,
  }) async {
    Query<Map<String, dynamic>> query =
        FirebaseFirestore.instance.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query)!;
    }
    final snapshot = await query.get();
    final result = snapshot.docs
        .map((snapshot) => builder(snapshot.data(), snapshot.id))
        .where((value) => value != null)
        .toList();
    if (sort != null) {
      result.sort(sort);
    }
    return result;
  }

  /// Fetch a snapshot of a document.
  /// Not (yet) used in this app.
  Future<T> fetchDocument<T>({
    required String path,
    required T Function(Map<String, dynamic>? data, String documentID) builder,
  }) async {
    final reference = FirebaseFirestore.instance.doc(path);
    final snapshot = await reference.get();
    return builder(snapshot.data(), snapshot.id);
  }

  /// Fetch a snapshot of a random document from a collection.
  Future<T> fetchRandomDocument<T>({
    required String path,
    required T Function(Map<String, dynamic>? data, String documentID) builder,
  }) async {
    final collection = FirebaseFirestore.instance.collection(path);
    final snapshot = await collection.get();

    // Select a random document from the collection
    final document = snapshot.docs[Random().nextInt(snapshot.docs.length)];
    return builder(document.data(), document.id);
  }
}
