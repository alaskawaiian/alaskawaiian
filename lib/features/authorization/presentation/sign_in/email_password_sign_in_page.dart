import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../show_alert_dialog.dart';
import '../../../show_exception_alert_dialog.dart';
import 'email_password_sign_in_model.dart';
import 'email_password_sign_in_strings.dart';
import 'form_submit_button.dart';

class EmailPasswordSignInPage extends StatefulWidget {
  const EmailPasswordSignInPage(
      {Key? key, required this.model, this.onSignedIn})
      : super(key: key);
  final EmailPasswordSignInModel model;
  final VoidCallback? onSignedIn;

  factory EmailPasswordSignInPage.withFirebaseAuth(FirebaseAuth firebaseAuth,
      {VoidCallback? onSignedIn}) {
    return EmailPasswordSignInPage(
      model: EmailPasswordSignInModel(firebaseAuth: firebaseAuth),
      onSignedIn: onSignedIn,
    );
  }

  @override
  EmailPasswordSignInPageState createState() => EmailPasswordSignInPageState();
}

class EmailPasswordSignInPageState extends State<EmailPasswordSignInPage> {
  final FocusScopeNode _node = FocusScopeNode();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _displayNameController = TextEditingController();

  EmailPasswordSignInModel get model => widget.model;

  @override
  void initState() {
    super.initState();
    // Temporary workaround to update state until a replacement for ChangeNotifierProvider is found
    model.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    model.dispose();
    _node.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _displayNameController.dispose();
    super.dispose();
  }

  void _showSignInError(EmailPasswordSignInModel model, dynamic exception) {
    showExceptionAlertDialog(
      context: context,
      title: model.errorAlertTitle,
      exception: exception,
    );
  }

  Future<void> _submit() async {
    try {
      final bool success = await model.submit();
      if (success) {
        if (model.formType == EmailPasswordSignInFormType.forgotPassword) {
          await showAlertDialog(
            context: context,
            title: EmailPasswordSignInStrings.resetLinkSentTitle,
            content: EmailPasswordSignInStrings.resetLinkSentMessage,
            defaultActionText: EmailPasswordSignInStrings.ok,
          );
        } else {
          if (widget.onSignedIn != null) {
            widget.onSignedIn?.call();
          }
        }
      }
    } catch (e) {
      _showSignInError(model, e);
    }
  }

  void _emailEditingComplete() {
    if (model.canSubmitEmail) {
      _node.nextFocus();
    }
  }

  void _passwordEditingComplete() {
    if (!model.canSubmitEmail) {
      _node.previousFocus();
      return;
    }
    _submit();
  }

  void _displayNameEditingComplete() {
    if (model.canSubmitDisplayName) {
      _node.nextFocus();
    }
  }

  void _updateFormType(EmailPasswordSignInFormType formType) {
    model.updateFormType(formType);
    _emailController.clear();
    _passwordController.clear();
    _displayNameController.clear();
  }

  Widget _buildEmailField() {
    return TextFormField(
      key: const Key('email'),
      controller: _emailController,
      decoration: InputDecoration(
        labelText: EmailPasswordSignInStrings.emailLabel,
        hintText: EmailPasswordSignInStrings.emailHint,
        errorText: model.emailErrorText,
        enabled: !model.isLoading,
      ),
      autocorrect: false,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.emailAddress,
      keyboardAppearance: Brightness.light,
      onEditingComplete: _emailEditingComplete,
      inputFormatters: <TextInputFormatter>[
        model.emailInputFormatter,
      ],
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      key: const Key('password'),
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: model.passwordLabelText,
        errorText: model.passwordErrorText,
        enabled: !model.isLoading,
      ),
      obscureText: true,
      autocorrect: false,
      textInputAction: TextInputAction.done,
      keyboardAppearance: Brightness.light,
      onEditingComplete: _passwordEditingComplete,
    );
  }

  Widget  _buildDisplayNameField() {
    return TextFormField(
      key: const Key('displayName'),
      controller: _displayNameController,
      decoration: InputDecoration(
        labelText: 'Display Name',
        hintText: 'Enter your display name',
        errorText: model.displayNameErrorText,
        enabled: !model.isLoading,
      ),
      autocorrect: false,
      textInputAction: TextInputAction.next,
      keyboardAppearance: Brightness.light,
      onEditingComplete: _displayNameEditingComplete,
    );
  }

  Widget _buildContent() {
    return FocusScope(
      node: _node,
      child: Form(
        onChanged: () =>
            model.updateWith(
                email: _emailController.text,
                password: _passwordController.text,
                displayName: _displayNameController.text),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(height: 8.0),
            if (model.formType == EmailPasswordSignInFormType.register) ...[
              const SizedBox(height: 8.0),
              _buildDisplayNameField(),
            ],
            _buildEmailField(),
            if (model.formType !=
                EmailPasswordSignInFormType.forgotPassword) ...<Widget>[
              const SizedBox(height: 8.0),
              _buildPasswordField(),
            ],
            if (model.formType == EmailPasswordSignInFormType.signIn)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  key: const Key('tertiary-button'),
                  child: Text(
                      EmailPasswordSignInStrings.forgotPasswordQuestion,
                      style: TextStyle(color: Colors.blue[900]),
                  ),
                  onPressed: model.isLoading
                      ? null
                      : () =>
                      _updateFormType(
                          EmailPasswordSignInFormType.forgotPassword),
                ),
              ),
            const SizedBox(height: 8.0),
            FormSubmitButton(
              key: const Key('primary-button'),
              text: model.primaryButtonText,
              loading: model.isLoading,
              onPressed: model.isLoading ? null : _submit,
              color: Colors.blue[900],
            ),
            const SizedBox(height: 8.0),
            TextButton(
              key: const Key('secondary-button'),
              child: Text(
                  model.secondaryButtonText,
                  style: TextStyle(color: Colors.blue[900]),
              ),
              onPressed: model.isLoading
                  ? null
                  : () => _updateFormType(model.secondaryActionFormType),
            ),
          ],
        ),
      ),
    );
  }

  String _getHeaderMessage() {
    switch (model.formType) {
      case EmailPasswordSignInFormType.register:
        return 'Get Started';
      case EmailPasswordSignInFormType.forgotPassword:
        return 'Reset Password';
      case EmailPasswordSignInFormType.signIn:
      default:
        return 'Welcome back!';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.blue[900],
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
            return Container(
              width: min(constraints.maxWidth, 600),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    _getHeaderMessage(),
                    style: TextStyle(
                      fontSize: 24.0,
                      color: Colors.blue[900],
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Jomolhari',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Card(
                    color: Colors.white,
                    elevation: 0.0,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: _buildContent(),
                    ),
                  ),
                ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
