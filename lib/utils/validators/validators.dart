import 'package:email_validator/email_validator.dart';
import 'package:wajanja/utils/constants/app_constants.dart';

///? Confirms if the email is valid
String? emailValidator(value) {
  // log.i("Validating Email $value");
  if (EmailValidator.validate(value.trim().toString())) {
    return null;
  } else {
    return 'Please provide a valid email address';
  }
}

///? Confirms if the handle is valid
String? handleValidator(value) {
  if (value.toString().replaceAll('@', '').trim() != '') {
    return null;
  }
  return 'invalid handle';
}

///? confirms if the password is valid
String? passwordValidator(value) {
  // log.i("Validating password $value");
  if (value.split('').length >= AppConstants.passwordLowerLimit) {
    return null;
  } else {
    return 'Your password must be atleast ${AppConstants.passwordLowerLimit} characters long';
  }
}

///? Confirms if the confirmPassword field is valid and matches the password
///field
String? signupConfirmPasswordValidator(value, passwordValue) {
  //TODO

  // log.i("Value = $value Password value = $passwordValue");
  if (value == '') {
    return "Please confirm your password";
  } else if (value != passwordValue) {
    return "Your password and confirm password don't match";
  } else {
    return null;
  }
}

///? Confirms if the lastName is valid
String? lastNameFieldValidator(value) {
  //TODO
  if (value == '') {
    return "Please enter your last name";
  } else if (value.split("").length < 2) {
    return "Atleast two letters long";
  } else {
    return null;
  }
}

///? Confirms if the firstName is valid
String? firstNameFieldValidator(value) {
  //TODO
  if (value == '') {
    return "Please enter your first name";
  } else if (value.split("").length < 2) {
    return "Atleast two letters long";
  } else {
    return null;
  }
}

///? Ensures that the user either a male or female
String? signupGenderFieldValidator(String? value) {
  if (value == '') {
    return 'Please choose your gender';
  }
  return null;
}

///? Ensures that the phone number is of appropriate length
String? signupPhoneNumberValidator(String? value) {
  if (value != null) {
    if (value.length < 5) {
      return 'Should have atleast 5 characters';
    }
  } else {
    return 'Please provide your phone number';
  }

  return null;
}

///? Ensures that otp has value
String? otpValidator(value) {
  if (value == '') {
    return '';
  }
  return null;
}

String? descriptionValidator(value) {
  if (value == null || value == '') {
    return 'Description can\'t be empty';
  }
  if (value.trim().length < 5) {
    return 'Too short';
  }

  return null;
}

String? nonNullValidator(String? value, {String? message}) {
  if (value == null || value.isEmpty) {
    return message ?? 'field can\'t be empty';
  }
  return null;
}
