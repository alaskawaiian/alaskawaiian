import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../job/data/job_database_providers.dart';
import '../../job/presentation/list_items_builder.dart';
import '../../strings.dart';
import '../data/entry_database_providers.dart';
import 'entries_list_tile.dart';
import 'entries_view_model.dart';

final entriesTileModelStreamProvider =
    StreamProvider.autoDispose<List<EntriesListTileModel>>(
  (ref) {
    final entryDatabase = ref.watch(entryDatabaseProvider)!;
    final jobDatabase = ref.watch(jobDatabaseProvider)!;
    final vm = EntriesViewModel(
        entryDatabase: entryDatabase, jobDatabase: jobDatabase);
    return vm.entriesTileModelStream;
  },
);

class EntriesPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesTileModelStream = ref.watch(entriesTileModelStreamProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.entries),
        elevation: 2.0,
      ),
      body: ListItemsBuilder<EntriesListTileModel>(
        data: entriesTileModelStream,
        itemBuilder: (context, model) => EntriesListTile(model: model),
      ),
    );
  }
}
