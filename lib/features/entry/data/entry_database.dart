import '../../../repositories/firestore/firestore_path.dart';
import '../../../repositories/firestore/firestore_service.dart';
import '../../job/domain/job.dart';
import '../domain/entry.dart';

class EntryDatabase {
  EntryDatabase({required this.uid});

  final String uid;

  final _service = FirestoreService.instance;

  Stream<List<Entry>> entriesStream({Job? job}) =>
      _service.watchCollection<Entry>(
        path: FirestorePath.entries(uid),
        queryBuilder: job != null
            ? (query) => query.where('jobId', isEqualTo: job.id)
            : null,
        builder: (data, documentID) => Entry.fromFirestore(data!, documentID),
        sort: (lhs, rhs) => rhs.start.compareTo(lhs.start),
      );

  Future<void> deleteEntry(Entry entry) async {
    try {
      _service.deleteData(path: FirestorePath.entry(uid, entry.id));
    } catch (e) {
      print('operation failed');
    }
  }
}
