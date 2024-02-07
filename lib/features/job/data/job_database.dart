import '../../../repositories/firestore/firestore_path.dart';
import '../../../repositories/firestore/firestore_service.dart';
import '../../entry/domain/entry.dart';
import '../domain/job.dart';

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class JobDatabase {
  JobDatabase({required this.uid});

  final String uid;

  final _service = FirestoreService.instance;

  Stream<List<Job>> jobsStream() => _service.watchCollection(
      path: FirestorePath.jobs(uid),
      builder: (data, documentId) => Job.fromFirestore(data!, documentId));

  Future<void> setJob(Job job) => _service.setData(
        path: FirestorePath.job(uid, job.id),
        data: job.toJson(),
      );

  Future<void> setEntry(Entry entry) => _service.setData(
        path: FirestorePath.entry(uid, entry.id),
        data: entry.toFirestore(),
      );

  Stream<List<Entry>> entriesStream({Job? job}) =>
      _service.watchCollection<Entry>(
        path: FirestorePath.entries(uid),
        queryBuilder: job != null
            ? (query) => query.where('jobId', isEqualTo: job.id)
            : null,
        builder: (data, documentID) => Entry.fromFirestore(data!, documentID),
        sort: (lhs, rhs) => rhs.start.compareTo(lhs.start),
      );

  Stream<Job> jobStream({required String jobId}) => _service.watchDocument(
        path: FirestorePath.job(uid, jobId),
        builder: (data, documentId) => Job.fromFirestore(data!, documentId),
      );

  Future<void> deleteEntry(Entry entry) =>
      _service.deleteData(path: FirestorePath.entry(uid, entry.id));

  Future<void> _deleteJob(Job job) async {
    // delete where entry.jobId == job.jobId
    final allEntries = await entriesStream(job: job).first;
    for (final entry in allEntries) {
      if (entry.jobId == job.id) {
        await deleteEntry(entry);
      }
    }
    // delete job
    await _service.deleteData(path: FirestorePath.job(uid, job.id));
  }

  Future<void> deleteJob(Job job) async {
    try {
      _deleteJob(job);
    } catch (e) {
      print('operation failed');
    }
  }
}
