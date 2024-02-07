import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../features/entry/domain/entry.dart';
import '../../../../features/job/domain/job.dart';
import '../../../../features/job/presentation/edit_job_page.dart';
import '../../../../features/job/presentation/job_entry/entry_list_item.dart';
import '../../../../features/job/presentation/job_entry/entry_page.dart';
import '../../../cupertino_tab_view_router.dart';
import '../../../entry/data/entry_database_providers.dart';
import '../../data/job_database_providers.dart';
import '../list_items_builder.dart';

class JobEntriesPage extends StatelessWidget {
  const JobEntriesPage({required this.job});
  final Job job;

  static Future<void> show(BuildContext context, Job job) async {
    await Navigator.of(context).pushNamed(
      CupertinoTabViewRoutes.jobEntriesPage,
      arguments: job,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: JobEntriesAppBarTitle(job: job),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () => EditJobPage.show(
              context,
              job: job,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () => EntryPage.show(
              context: context,
              job: job,
            ),
          ),
        ],
      ),
      body: JobEntriesContents(job: job),
    );
  }
}

class JobEntriesAppBarTitle extends ConsumerWidget {
  const JobEntriesAppBarTitle({required this.job});
  final Job job;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobAsyncValue = ref.watch(jobStreamProvider(job.id));
    return jobAsyncValue.when(
      data: (job) => Text(job.name),
      loading: () => Container(),
      error: (_, __) => Container(),
    );
  }
}

class JobEntriesContents extends ConsumerWidget {
  final Job job;
  const JobEntriesContents({required this.job});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesStream = ref.watch(jobEntriesStreamProvider(job));
    final entryDatabase = ref.watch(entryDatabaseProvider)!;
    return ListItemsBuilder<Entry>(
      data: entriesStream,
      itemBuilder: (context, entry) {
        return DismissibleEntryListItem(
          dismissibleKey: Key('entry-${entry.id}'),
          entry: entry,
          job: job,
          onDismissed: () => entryDatabase.deleteEntry(entry),
          onTap: () => EntryPage.show(
            context: context,
            job: job,
            entry: entry,
          ),
        );
      },
    );
  }
}
