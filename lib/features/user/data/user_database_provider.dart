import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../repositories/firestore/firestore_providers.dart';
import 'user_database.dart';

/// Provides access to the [UserDatabase] associated with the logged in user,
/// or else returns null if there is no logged in user.
final userDatabaseProvider = Provider.autoDispose<UserDatabase?>((ref) {
  final auth = ref.watch(authStateChangesProvider);

  if (auth.asData?.value?.uid != null) {
    return UserDatabase(uid: auth.asData!.value!.uid);
  }
  return null;
});

/// Provides access to a single User's miles, updating it if it changes.
final milesStreamProvider = StreamProvider.autoDispose<int>((ref) {
  final database = ref.watch(userDatabaseProvider)!;
  return database.milesStream();
});

/// Provides access to check if a single User has answered the daily question, updating it if it changes.
final hasAnsweredStreamProvider =
    StreamProvider.autoDispose<bool>((ref) {
  final database = ref.watch(userDatabaseProvider)!;
  return database.hasAnsweredStream();
});
