import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../repositories/firestore/firestore_providers.dart';
import '../../entry/domain/entry.dart';
import '../domain/job.dart';
import 'job_database.dart';

/// Provides access to the [JobDatabase] associated with the logged in user,
/// or else returns null if there is no logged in user.
final jobDatabaseProvider = Provider.autoDispose<JobDatabase?>((ref) {
  final auth = ref.watch(authStateChangesProvider);

  if (auth.asData?.value?.uid != null) {
    return JobDatabase(uid: auth.asData!.value!.uid);
  }
  return null;
});

/// Provides access to a single Job, updating it if it changes.
final jobStreamProvider =
    StreamProvider.autoDispose.family<Job, String>((ref, jobId) {
  final database = ref.watch(jobDatabaseProvider)!;
  return database.jobStream(jobId: jobId);
});

/// Provides access to all entries associated with a job, updating if they change.
final jobEntriesStreamProvider =
    StreamProvider.autoDispose.family<List<Entry>, Job>((ref, job) {
  final database = ref.watch(jobDatabaseProvider)!;
  return database.entriesStream(job: job);
});

/// Provides access to all Jobs associated with this user.
final jobsStreamProvider = StreamProvider.autoDispose<List<Job>>((ref) {
  final database = ref.watch(jobDatabaseProvider)!;
  return database.jobsStream();
});
