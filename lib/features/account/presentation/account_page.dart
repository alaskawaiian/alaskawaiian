import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starter_architecture_flutter_firebase/features/custom_colors.dart';

import '../../../repositories/firestore/firestore_providers.dart';
import '../../show_alert_dialog.dart';
import '../../show_exception_alert_dialog.dart';
import '../../strings.dart';
import '../../user/data/user_database_provider.dart';
import 'avatar.dart';

class AccountPage extends ConsumerWidget {
  Future<void> _signOut(BuildContext context, FirebaseAuth firebaseAuth) async {
    try {
      await firebaseAuth.signOut();
    } catch (e) {
      unawaited(showExceptionAlertDialog(
        context: context,
        title: Strings.logoutFailed,
        exception: e,
      ));
    }
  }

  Future<void> _confirmSignOut(
      BuildContext context, FirebaseAuth firebaseAuth) async {
    final bool didRequestSignOut = (await showAlertDialog(
          context: context,
          title: Strings.logout,
          content: Strings.logoutAreYouSure,
          cancelActionText: Strings.cancel,
          defaultActionText: Strings.logout,
        )) ??
        false;
    if (didRequestSignOut == true) {
      // Warning: Do not use BuildContexts across async gaps. This seems to indicate that
      // this widget should be stateful? There is no mounted property in ConsumerWidget
      await _signOut(context, firebaseAuth);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firebaseAuth = ref.watch(firebaseAuthProvider);
    final user = firebaseAuth.currentUser!;
    final userStream = ref.watch(userStreamProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [hawaiianPink, alaskaBlue],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  Avatar(
                    photoUrl: user.photoURL,
                    radius: 50,
                    borderColor: Colors.white,
                    borderWidth: 3.0,
                  ),
                  Text(
                    user.displayName ?? 'Guest',
                    style: const TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            const SizedBox(height: 20),
            userStream.when(
              data: (userData) => _buildInfoCard(
                icon: Icons.trending_up,
                label: 'Streak',
                value: '${userData.streak} days',
              ),
              loading: () => _buildInfoCard(
                icon: Icons.trending_up,
                label: 'Streak',
                value: 'Loading...',
              ),
              error: (error, stack) => _buildInfoCard(
                icon: Icons.trending_up,
                label: 'Streak',
                value: 'Error loading streak',
              ),
            ),
            _buildInfoCard(
              icon: Icons.directions_walk,
              label: 'Miles/Points',
              value: '120 miles',
            ),
            _buildInfoCard(
              icon: Icons.person,
              label: 'Name',
              value: user.displayName ?? 'N/A',
            ),
            _buildInfoCard(
              icon: Icons.email,
              label: 'Email',
              value: user.email ?? 'N/A',
            ),
            _buildInfoCard(
              icon: Icons.lock,
              label: 'Password',
              value: '********',
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                backgroundColor: Colors.blue[900],
              ),
              onPressed: () => _confirmSignOut(context, firebaseAuth),
              child: const Text(
                'Log Out',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Widget for building each information card
  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
    bool hasEditOption = false,
    VoidCallback? onEditPressed,
  }) {
    return Card(
      color: Colors.grey[200],
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 4,
      child: ListTile(
        leading: Icon(icon, color: Colors.blue[900]),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value),
        trailing: hasEditOption
            ? IconButton(
                icon: const Icon(Icons.edit, color: Colors.grey),
                onPressed: onEditPressed,
              )
            : null,
      ),
    );
  }
}
