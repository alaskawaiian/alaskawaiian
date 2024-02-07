import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../repositories/firestore/firestore_providers.dart';
import 'entry_database.dart';

/// Provides access to the [EntryDatabase] associated with the logged in user,
/// or else returns null if there is no logged in user.
final entryDatabaseProvider = Provider.autoDispose<EntryDatabase?>((ref) {
  final auth = ref.watch(authStateChangesProvider);

  if (auth.asData?.value?.uid != null) {
    return EntryDatabase(uid: auth.asData!.value!.uid);
  }
  return null;
});
