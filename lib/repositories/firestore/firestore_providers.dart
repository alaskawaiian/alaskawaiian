import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

/// Provides access to a [FirebaseAuth.instance].
final firebaseAuthProvider =
    Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

/// Provides access to [FirebaseAuth.authStateChanges].
final authStateChangesProvider = StreamProvider.autoDispose<User?>(
    (ref) => ref.watch(firebaseAuthProvider).authStateChanges());

/// Provides access to a [Logger] instance. Not currently used, but nice to have.
final loggerProvider = Provider<Logger>((ref) => Logger(
      printer: PrettyPrinter(
        methodCount: 1,
        printEmojis: false,
      ),
    ));
