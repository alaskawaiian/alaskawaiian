import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../repositories/firestore/firestore_path.dart';
import '../../../repositories/firestore/firestore_service.dart';

DateTime currentDateAtMidnight() {
  DateTime now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
}

class UserDatabase {
  UserDatabase({required this.uid});

  final String uid;

  final _service = FirestoreService.instance;

  Future<void> initUser() => _service.setData(
    path: FirestorePath.user(uid), 
    data: { 'miles': 0, 'lastAnsweredAt': null }
  );

  Stream<int> milesStream() => _service.watchDocument(
    path: FirestorePath.user(uid), 
    builder: (data, documentID) => data?['miles']
  );

  Future<void> addMiles(int miles) => _service.incrementData(
    path: FirestorePath.user(uid), 
    fieldName: 'miles', 
    incrementBy: miles
  );

  Stream<bool> hasAnsweredStream() => _service.watchDocument(
    path: FirestorePath.user(uid),
    builder: (data, documentID) => 
      data?['lastAnsweredAt'] != null 
        ? (data?['lastAnsweredAt'] as Timestamp).toDate().isAfter(currentDateAtMidnight()) 
        : false
  );

  Future<void> updateLastAnsweredAt() => _service.setData(
    path: FirestorePath.user(uid),
    data: { 'lastAnsweredAt': DateTime.now() },
    merge: true
  );
}
