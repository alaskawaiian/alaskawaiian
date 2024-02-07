import '../../job/domain/job.dart';
import '../domain/entry.dart';

class EntryJob {
  EntryJob(this.entry, this.job);

  final Entry entry;
  final Job job;
}
