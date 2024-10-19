import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'authorization/presentation/sign_in/email_password_sign_in_page.dart';

/// Defines the routes to the signin page, job page, and entry page.
class AppRoutes {
  static const emailPasswordSignInPage = '/email-password-sign-in-page';
  // static const entryPage = '/entry-page';
}

/// Provides an [onGenerateRoute] method that returns a [MaterialPageRoute] to
/// build either the Signin Page, the Edit Job page, or the Entry Page.
/// Routes are passed args which are cast or destructured to appropriate types
/// for the page being built.
class AppRouter {
  static Route<dynamic>? onGenerateRoute(
      RouteSettings settings, FirebaseAuth firebaseAuth) {
    final args = settings.arguments;
    switch (settings.name) {
      case AppRoutes.emailPasswordSignInPage:
        return MaterialPageRoute<dynamic>(
          builder: (_) => EmailPasswordSignInPage.withFirebaseAuth(firebaseAuth,
              onSignedIn: args as void Function()),
          settings: settings,
          fullscreenDialog: false,
        );
      // case AppRoutes.entryPage:
      //   final mapArgs = args as Map<String, dynamic>;
      //   final job = mapArgs['job'] as Job;
      //   final entry = mapArgs['entry'] as Entry?;
      //   return MaterialPageRoute<dynamic>(
      //     builder: (_) => EntryPage(job: job, entry: entry),
      //     settings: settings,
      //     fullscreenDialog: true,
      //   );
      default:
        // TODO: Throw
        return null;
    }
  }
}
