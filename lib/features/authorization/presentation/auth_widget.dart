import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../repositories/firestore/firestore_providers.dart';
import '../../push_notification.dart';

/// Builds either [signedInBuilder], [nonSignedInBuilder], or
/// [CircularProgressIndicator] depending upon the value of [authStateChangesProvider].
class AuthWidget extends ConsumerWidget {
  const AuthWidget({
    Key? key,
    required this.signedInBuilder,
    required this.nonSignedInBuilder,
  }) : super(key: key);
  final WidgetBuilder nonSignedInBuilder;
  final WidgetBuilder signedInBuilder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStateChanges = ref.watch(authStateChangesProvider);
    return authStateChanges.when(
      data: (user) => _data(context, user),
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (_, __) => const Scaffold(
        body: Text('Something went wrong'),
      ),
    );
  }

  /// Returns either the signedInBuilder or nonSignedInBuilder.
  Widget _data(BuildContext context, User? user) {
    if (user != null) {
      final PushNotificationApi pushNotificationApi = PushNotificationApi();
      pushNotificationApi.initNotifications();
      return signedInBuilder(context);
    }
    return nonSignedInBuilder(context);
  }
}
