import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starter_architecture_flutter_firebase/features/app_router.dart';
import 'package:starter_architecture_flutter_firebase/features/keys.dart';
import 'package:starter_architecture_flutter_firebase/features/strings.dart';
import 'package:starter_architecture_flutter_firebase/repositories/firestore/firestore_providers.dart';
import 'package:flutter_svg/flutter_svg.dart';


import '../../../show_exception_alert_dialog.dart';
import 'sign_in_view_model.dart';

/// Manages access to [SignInViewModel].
final signInModelProvider = ChangeNotifierProvider<SignInViewModel>(
  (ref) => SignInViewModel(auth: ref.watch(firebaseAuthProvider)),
);

/// Builds [SignInPageContents], unless [signInModelProvider] indicates an error
/// on signin, in which case a [showExceptionAlertDialog] is also displayed.
class SignInPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signInModel = ref.watch(signInModelProvider);
    ref.listen<SignInViewModel>(signInModelProvider, (_, model) async {
      if (model.error != null) {
        await showExceptionAlertDialog(
          context: context,
          title: Strings.signInFailed,
          exception: model.error,
        );
      }
    });
    return SignInPageContents(
      viewModel: signInModel,
      title: 'Alaskawaiian Rewards',
    );
  }
}

/// Builds either the [EmailPasswordSignInPage] or
class SignInPageContents extends StatelessWidget {
  const SignInPageContents(
      {Key? key, required this.viewModel, this.title = 'Alaskawaiian Rewards'})
      : super(key: key);
  final SignInViewModel viewModel;
  final String title;

  static const Key emailPasswordButtonKey = Key(Keys.emailPassword);
  static const Key anonymousButtonKey = Key(Keys.anonymous);

  /// Navigates to [EmailPasswordSignInPage].
  Future<void> _showEmailPasswordSignInPage(BuildContext context) async {
    final navigator = Navigator.of(context);
    await navigator.pushNamed(
      AppRoutes.emailPasswordSignInPage,
      arguments: () => navigator.pop(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildSignIn(context),
    );
  }

  Widget _buildSignIn(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/homepage.png'),
          fit: BoxFit.cover,
          alignment: Alignment(0.4, 0.0),
        ),
      ),
      child: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              width: min(constraints.maxWidth, 600),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 60.0),
                    child: SvgPicture.asset(
                      'assets/logo-lockup.svg',
                      height: 25,
                    ),
                  ),
                  Column(
                    children: [
                      const Text(
                        "Alaskawaiian Rewards App",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 40.0,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Jomolhari',
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              offset: Offset(2.0, 2.0),
                              blurRadius: 4.0,
                              color: Colors.black54,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      const Text(
                        "Two beloved brands. Taking you further.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontStyle: FontStyle.italic,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              offset: Offset(1.0, 1.0),
                              blurRadius: 2.0,
                              color: Colors.black54,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50.0,
                      child: ElevatedButton(
                        onPressed: viewModel.isLoading
                            ? null
                            : () {
                          _showEmailPasswordSignInPage(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Text(
                          'Get Started',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
