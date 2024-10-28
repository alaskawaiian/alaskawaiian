import '../domain/user.dart';
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
    data: { 'miles': 0, 'streak': 0, 'lastAnsweredAt': null }
  );

  Stream<User> userStream() => _service.watchDocument(
    path: FirestorePath.user(uid), 
    builder: (data, documentID) => User.fromFirebase(data!, documentID)
  );

  Future<void> addMiles(int miles) => _service.incrementData(
    path: FirestorePath.user(uid), 
    fieldName: 'miles', 
    incrementBy: miles
  );

  Future<void> incrementStreak() => _service.incrementData(
    path: FirestorePath.user(uid), 
    fieldName: 'streak', 
    incrementBy: 1
  );

  Future<void> resetStreak() => _service.setData(
    path: FirestorePath.user(uid), 
    data: { 'streak': 0 },
    merge: true
  );

  Future<void> updateLastAnsweredAt() => _service.setData(
    path: FirestorePath.user(uid),
    data: { 'lastAnsweredAt': DateTime.now() },
    merge: true
  );
}
