//FOR SIGN IN
String? validateEmail(String? formEmail) {
  if (formEmail == null || formEmail.isEmpty)
    return 'Email address is required.';

  return null;
}

String? validatePassword(String? formPassword) {
  if (formPassword == null || formPassword.isEmpty)
    return 'Password is required.';

  return null;
}

bool isEmailCorrect = false;
bool isPasswordCorrect = false;
bool isRPwdCorrect = false;

//FOR SIGN UP
String? validatePasswordSignUp(String? formSignUpEmail) {
  if (formSignUpEmail == null || formSignUpEmail.isEmpty) {
    return 'Password is required.';
  } else if (formSignUpEmail!.length < 6) {
    return 'The password is too weak';
  }

  return null;
}

String? validateEmailSignUp(String? formSignUpPassword) {
  if (formSignUpPassword == null || formSignUpPassword.isEmpty)
    return 'Email is required.';

  return null;
}

String? validateRePwdSignUp(
    String? formSignUpRepeatPassword, String repeatPassword) {
  if (formSignUpRepeatPassword == null || formSignUpRepeatPassword.isEmpty) {
    return 'This field is required.';
  } else if (formSignUpRepeatPassword != repeatPassword) {
    return 'Does not match to password';
  }

  return null;
}
