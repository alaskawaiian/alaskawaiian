import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/user.dart';
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

/// Provides access to a single User, updating it if it changes.
final userStreamProvider = StreamProvider.autoDispose<User>((ref) {
  final database = ref.watch(userDatabaseProvider)!;
  return database.userStream();
});

