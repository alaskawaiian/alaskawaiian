import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../user/data/user_database.dart';
import 'email_password_sign_in_strings.dart';
import 'string_validators.dart';

enum EmailPasswordSignInFormType { signIn, register, forgotPassword }

/// {@category Features}
/// {@subCategory SignIn}
class EmailAndPasswordValidators {
  final TextInputFormatter emailInputFormatter =
      ValidatorInputFormatter(editingValidator: EmailEditingRegexValidator());
  final StringValidator emailSubmitValidator = EmailSubmitRegexValidator();
  final StringValidator passwordRegisterSubmitValidator =
      MinLengthStringValidator(8);
  final StringValidator passwordSignInSubmitValidator =
      NonEmptyStringValidator();
  final StringValidator displayNameValidator = MinLengthStringValidator(3);
}

class EmailPasswordSignInModel extends EmailAndPasswordValidators
    with ChangeNotifier {
  EmailPasswordSignInModel({
    required this.firebaseAuth,
    this.email = '',
    this.password = '',
    this.displayName = '',
    this.formType = EmailPasswordSignInFormType.signIn,
    this.isLoading = false,
    this.submitted = false,
  });
  final FirebaseAuth firebaseAuth;

  String email;
  String password;
  String displayName;
  EmailPasswordSignInFormType formType;
  bool isLoading;
  bool submitted;

  Future<bool> submit() async {
    try {
      updateWith(submitted: true);
      if (!canSubmit) {
        return false;
      }
      updateWith(isLoading: true);
      switch (formType) {
        case EmailPasswordSignInFormType.signIn:
          await firebaseAuth.signInWithCredential(
              EmailAuthProvider.credential(email: email, password: password));
          break;
        case EmailPasswordSignInFormType.register:
          UserCredential userCredential = await firebaseAuth
              .createUserWithEmailAndPassword(email: email, password: password);
          await userCredential.user!.updateDisplayName(displayName);
          await UserDatabase(uid: userCredential.user!.uid).initUser();
          break;
        case EmailPasswordSignInFormType.forgotPassword:
          await firebaseAuth.sendPasswordResetEmail(email: email);
          updateWith(isLoading: false);
          break;
      }
      return true;
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

  void updateEmail(String email) => updateWith(email: email);

  void updatePassword(String password) => updateWith(password: password);

  void updateDisplayName(String displayName) =>
      updateWith(displayName: displayName);

  void updateFormType(EmailPasswordSignInFormType formType) {
    updateWith(
      email: '',
      password: '',
      displayName: '',
      formType: formType,
      isLoading: false,
      submitted: false,
    );
  }

  void updateWith({
    String? email,
    String? password,
    String? displayName,
    EmailPasswordSignInFormType? formType,
    bool? isLoading,
    bool? submitted,
  }) {
    this.email = email ?? this.email;
    this.password = password ?? this.password;
    this.displayName = displayName ?? this.displayName;
    this.formType = formType ?? this.formType;
    this.isLoading = isLoading ?? this.isLoading;
    this.submitted = submitted ?? this.submitted;
    notifyListeners();
  }

  String get passwordLabelText {
    if (formType == EmailPasswordSignInFormType.register) {
      return EmailPasswordSignInStrings.password8CharactersLabel;
    }
    return EmailPasswordSignInStrings.passwordLabel;
  }

  // Getters
  String get primaryButtonText {
    return <EmailPasswordSignInFormType, String>{
      EmailPasswordSignInFormType.register:
          EmailPasswordSignInStrings.createAnAccount,
      EmailPasswordSignInFormType.signIn: EmailPasswordSignInStrings.signIn,
      EmailPasswordSignInFormType.forgotPassword:
          EmailPasswordSignInStrings.sendResetLink,
    }[formType]!;
  }

  String get secondaryButtonText {
    return <EmailPasswordSignInFormType, String>{
      EmailPasswordSignInFormType.register:
          EmailPasswordSignInStrings.haveAnAccount,
      EmailPasswordSignInFormType.signIn:
          EmailPasswordSignInStrings.needAnAccount,
      EmailPasswordSignInFormType.forgotPassword:
          EmailPasswordSignInStrings.backToSignIn,
    }[formType]!;
  }

  EmailPasswordSignInFormType get secondaryActionFormType {
    return <EmailPasswordSignInFormType, EmailPasswordSignInFormType>{
      EmailPasswordSignInFormType.register: EmailPasswordSignInFormType.signIn,
      EmailPasswordSignInFormType.signIn: EmailPasswordSignInFormType.register,
      EmailPasswordSignInFormType.forgotPassword:
          EmailPasswordSignInFormType.signIn,
    }[formType]!;
  }

  String get errorAlertTitle {
    return <EmailPasswordSignInFormType, String>{
      EmailPasswordSignInFormType.register:
          EmailPasswordSignInStrings.registrationFailed,
      EmailPasswordSignInFormType.signIn:
          EmailPasswordSignInStrings.signInFailed,
      EmailPasswordSignInFormType.forgotPassword:
          EmailPasswordSignInStrings.passwordResetFailed,
    }[formType]!;
  }

  String get title {
    return <EmailPasswordSignInFormType, String>{
      EmailPasswordSignInFormType.register: EmailPasswordSignInStrings.register,
      EmailPasswordSignInFormType.signIn: EmailPasswordSignInStrings.signIn,
      EmailPasswordSignInFormType.forgotPassword:
          EmailPasswordSignInStrings.forgotPassword,
    }[formType]!;
  }

  bool get canSubmitEmail {
    return emailSubmitValidator.isValid(email);
  }

  bool get canSubmitPassword {
    if (formType == EmailPasswordSignInFormType.register) {
      return passwordRegisterSubmitValidator.isValid(password);
    }
    return passwordSignInSubmitValidator.isValid(password);
  }

  bool get canSubmitDisplayName {
    return displayNameValidator.isValid(displayName);
  }

  bool get canSubmit {
    final bool canSubmitFields;

    if (formType == EmailPasswordSignInFormType.forgotPassword) {
      canSubmitFields = canSubmitEmail;
    } else if (formType == EmailPasswordSignInFormType.register) {
      canSubmitFields =
          canSubmitEmail && canSubmitPassword && canSubmitDisplayName;
    } else {
      canSubmitFields = canSubmitEmail && canSubmitPassword;
    }

    return canSubmitFields && !isLoading;
  }

  String? get emailErrorText {
    final bool showErrorText = submitted && !canSubmitEmail;
    final String errorText = email.isEmpty
        ? EmailPasswordSignInStrings.invalidEmailEmpty
        : EmailPasswordSignInStrings.invalidEmailErrorText;
    return showErrorText ? errorText : null;
  }

  String? get passwordErrorText {
    final bool showErrorText = submitted && !canSubmitPassword;
    final String errorText = password.isEmpty
        ? EmailPasswordSignInStrings.invalidPasswordEmpty
        : EmailPasswordSignInStrings.invalidPasswordTooShort;
    return showErrorText ? errorText : null;
  }

  String? get displayNameErrorText {
    final bool showErrorText = submitted && !canSubmitDisplayName;
    return showErrorText ? 'Display name can\'t be empty' : null;
  }

  @override
  String toString() {
    return 'email: $email, password: $password, displayName: $displayName, formType: $formType, isLoading: $isLoading, submitted: $submitted';
  }
}
