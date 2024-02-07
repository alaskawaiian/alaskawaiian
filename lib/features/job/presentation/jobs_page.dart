import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../strings.dart';
import '../data/job_database_providers.dart';
import '../domain/job.dart';
import 'edit_job_page.dart';
import 'job_entry/job_entries_page.dart';
import 'job_list_tile.dart';
import 'list_items_builder.dart';

/// Builds the Jobs page by watching [jobsStreamProvider] and displaying each job
/// using [ListItemsBuilder] to display [JobListTile]s.
/// Uses [Dismissible] to delete the corresponding [Job].
class JobsPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.jobs),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () => EditJobPage.show(context),
          ),
        ],
      ),
      body: _buildContents(context, ref),
    );
  }

  Widget _buildContents(BuildContext context, WidgetRef ref) {
    final jobsAsyncValue = ref.watch(jobsStreamProvider);
    final jobDatabase = ref.watch(jobDatabaseProvider);
    return ListItemsBuilder<Job>(
      data: jobsAsyncValue,
      itemBuilder: (context, job) => Dismissible(
        key: Key('job-${job.id}'),
        background: Container(color: Colors.red),
        direction: DismissDirection.endToStart,
        // TODO: Remove the "?" in the following line.
        // Not sure how to guarantee that jobDatabase is not null.
        onDismissed: (direction) => jobDatabase?.deleteJob(job),
        child: JobListTile(
          job: job,
          onTap: () => JobEntriesPage.show(context, job),
        ),
      ),
    );
  }
}
