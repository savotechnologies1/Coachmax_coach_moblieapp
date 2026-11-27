extension FormValidator on String {
  String? isValidUsername(context) {
    if (isEmpty) {
      return ("Enter your name");
    } else if (length < 2) {
      return ("Name length sould be grater than three");
    }
    return null;
  }

  String? isValiddestination(context) {
    if (isEmpty) {
      return ("Enter your desination");
    } else if (length < 2) {
      return ("Desination length sould be grater than three");
    }
    return null;
  }

  String? isValidLtdlink(context) {
    if (isEmpty) {
      return ("Enter your link");
    } else if (contains("https") && contains("https")) {
      return ("link length sould be grater than three");
    }
    return null;
  }

  bool get isValidURLlinkdin {
    final urlPattern =
        r"https:\/\/[a-z]{2,3}\.linkedin\.com\/in\/[a-zA-Z0-9-]+\/?";
    final result = RegExp(urlPattern).hasMatch(this ?? '');
    return result;
  }

  bool get isValidURLfacebook {
    final urlPattern =
        r"https:\/\/(www\.)?facebook\.com\/(?:profile\.php\?id=\d+|[a-zA-Z0-9\.]+)\/?";
    final result = RegExp(urlPattern).hasMatch(this ?? '');
    return result;
  }

  bool get isValidURLtwitter {
    final urlPattern = r"https:\/\/(www\.)?x\.com\/[a-zA-Z0-9_]+\/?";
    final result = RegExp(urlPattern).hasMatch(this ?? '');
    return result;
  }

  bool get isValidURLinstagram {
    final urlPattern = r"https:\/\/(www\.)?instagram\.com\/[a-zA-Z0-9._-]+\/?";
    final result = RegExp(urlPattern).hasMatch(this ?? '');
    return result;
  }

  String? isValidUsernameinv(context) {
    if (isEmpty) {
      return ("validationName");
    } else if (length < 2) {
      return ("validationNameLenth");
    }
    return null;
  }

  String? isValidEmail(context) {
    if (isEmpty) {
      return ("Enter your email");
    } else if (!RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(this)) {
      return "Please enter valid email";
    }
    return null;
  }

  String? isValidPassword(context) {
    if (isEmpty) {
      return ("Password is not empty");
    } else if (length < 6) {
      return ("Password should be 6 letter");
    }
    // else if(!RegExp(
    //     r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@?#\^%$&*~<>.,_;:=+-]).{8,}$')
    //     .hasMatch(this)){
    //   return ("Password should contain at least one Upper, Lower, Digit, \nSpecial Character & 8 Character long.");
    // }
    return null;
  }

  String? isValidOldPassword(context) {
    if (isEmpty) {
      return ("enter_Old_Password");
    } else if (length < 6) {
      return ("validationPasswordMustContain");
    }
    // else if(!RegExp(
    //     r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@?#\^%$&*~<>.,_;:=+-]).{8,}$')
    //     .hasMatch(this)){
    //   return ("Password should contain at least one Upper, Lower, Digit, \nSpecial Character & 8 Character long.");
    // }
    return null;
  }

  String? isValidNewPassword(context) {
    if (isEmpty) {
      return ("Enter NewPassword");
    } else if (length < 6) {
      return ("Password length should be six digit");
    }

    return null;
  }

  String? isValidNewConfirmPassword(String password, context) {
    if (password != this) {
      return ("Enter your confirm password");
    }
    if (isEmpty) {
      return ("New password and confirm password should be 6");
    }
    return null;
  }

  String? isValidConfirmPassword(String password, context) {
    if (password != this) {
      return ("comfirm Password is empty");
    }
    if (isEmpty) {
      return ("validationRepeatPassword");
    }
    return null;
  }

  String? isValidMobile() {
    if (isEmpty) {
      return ("Phone number is required");
    } else if (length < 7) {
      return ("Phone number Should be at least 7 characters");
    }
    return null;
  }

  String? isValidDob(context) {
    if (isEmpty) {
      return ("birth_date_is_required");
    } else if (length < 7) {
      return ("Phone number Should be at least 7 characters");
    }
    return null;
  }

  String? isValidLink() {
    if (isEmpty) {
      return ("Link is required");
    } else if (!RegExp(
      r"(http(s)?:\/\/.)?(www\.)?[-a-zA-Z0-9@:%._"
      r"\+~#=]{2,256}\.{2,6}\b([0-9@:%_\+.~#?&//=]*)",
    ).hasMatch(this)) {
      return ("Enter a valid link");
    }
    return null;
  }

  String? isValidBusinessEmail() {
    if (isEmpty) {
      return ("Business Email is required");
    } else if (!RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(this)) {
      return "Enter a valid email";
    }
    return null;
  }

  // String? isValidBusinessEmail() {
  //   if(isNotEmpty && !RegExp(
  //       r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(this)) {
  //     return "Enter a valid email";
  //   }
  //   return null;
  // }
  String? isValidWebLink() {
    if (isNotEmpty &&
        !RegExp(
          r"(https?:\/\/(?:www\.)?|ftp:\/\/(www\.)?|www\.){1}[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b(?:[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)",
        ).hasMatch(this)) {
      return ("Enter a valid link");
    }
    return null;
  }

  String? isValidBusinessMobile() {
    if (isNotEmpty && length < 7) {
      return ("Phone number Should be at least 7 characters");
    }
    return null;
  }

  String? isValidTitle(context) {
    if (isEmpty) {
      return ("Title_is_required");
    } else if (length < 2) {
      return ("Title_Should_be_at_least_3_characters");
    }
    return null;
  }

  String? isValidReportReason() {
    if (isEmpty) {
      return ("Reason is required");
    }
    return null;
  }

  String? isValidAddress() {
    if (isEmpty) {
      return ("Address is required");
    }
    return null;
  }

  String? isValidCountryName() {
    if (isEmpty) {
      return ("Country is required");
    }
    return null;
  }

  String? isValidCityName() {
    if (isEmpty) {
      return ("City is required");
    }
    return null;
  }

  String? isValidAddressOne() {
    if (isEmpty) {
      return ("Flat/Block is required");
    }
    return null;
  }

  String? isValidAddressTwo() {
    if (isEmpty) {
      return ("Apartment/Area is required");
    }
    return null;
  }

  String? isValidZipCode() {
    if (isEmpty) {
      return ("Zip code is required");
    }
    return null;
  }

  String? isValidName() {
    if (isEmpty) {
      return ("Name is required");
    }
    return null;
  }

  String? isValidBusinessName() {
    if (isEmpty) {
      return ("Business Name is required");
    } else if (length < 2) {
      return ("Minimum characters should be 2");
    }
    return null;
  }

  String? isValidBusinessHours() {
    if (isEmpty) {
      return ("Business hours is required.");
    }
    return null;
  }

  String? isValidServiceIOffer() {
    if (isEmpty) {
      return ("Select Services");
    }
    return null;
  }

  String? isValidDescription() {
    if (isEmpty) {
      return ("Description is required");
    }
    return null;
  }

  // String? isValidOldPassword() {
  //   if(isEmpty){
  //     return ("Old password is required");
  //   }
  //   return null;
  // }

  String? isValidPreference() {
    if (isEmpty) {
      return ("Required preference.");
    }
    return null;
  }

  // String? isValidFolderName() {
  //   if(isEmpty){
  //     return ("Name required");
  //   }
  //   return null;
  // }
  //
  // String? isValidFirstname() {
  //   if(isEmpty){
  //     return ("First name is required");
  //   }else if(length < 2) {
  //     return ("Minimum characters should be 2");
  //   }
  //   return null;
  // }
  //
  // String? isValidLastname() {
  //   if(isEmpty){
  //     return ("Last name is required");
  //   }else if(length < 2) {
  //     return ("Minimum characters should be 2");
  //   }
  //   return null;
  // }
  //
  // String? isValidBankName() {
  //   if(isEmpty){
  //     return ("Bank name is required");
  //   }else if(length < 2) {
  //     return ("Minimum characters should be 2");
  //   }
  //   return null;
  // }
  //
  // String? isValidRoutingNumber() {
  //   if(isEmpty){
  //     return ("Routing number is required");
  //   }
  //   return null;
  // }
  //
  // String? isValidAccountNumber() {
  //   if(isEmpty){
  //     return ("Account number is required");
  //   }
  //   return null;
  // }
  //
  // String? isValidConfirmAccountNumber(String accNo) {
  //   if(accNo != this) {
  //     return ("Account number and Confirm account number should be same");
  //   } if(isEmpty){
  //     return ("Confirm Account number is required");
  //   }
  //   return null;
  // }
  //
  // String? isValidSocialSecurityNumber() {
  //   if(isEmpty){
  //     return ("Social security number is required");
  //   }
  //   return null;
  // }
  //
  // String? isValidDateOfBirth() {
  //   if(isEmpty){
  //     return ("DOB is required");
  //   }
  //   return null;
  // }
  //
  // String? isValidStateName() {
  //   if(isEmpty){
  //     return ("State is required");
  //   }
  //   return null;
  // }
  //
  // String? isValidBlockOutTitle() {
  //   if(isEmpty){
  //     return ("Title is required");
  //   }
  //   return null;
  // }
  //
  // String? isValidFromTime() {
  //   if(isEmpty){
  //     return ("From time is required");
  //   }
  //   return null;
  // }
  //
  // String? isValidToTime() {
  //   if(isEmpty){
  //     return ("To time is required");
  //   }
  //   return null;
  // }
  //
  // String? isValidTableName() {
  //   if(isEmpty){
  //     return ("This field is required");
  //   }else if(length < 2) {
  //     return ("Minimum characters should be 2");
  //   }
  //   return null;
  // }
  //
  // String? isValidCapacity() {
  //   if(isEmpty){
  //     return ("This field is required");
  //   } else if(int.parse(this) < 1) {
  //     return ("Min. 1 capacity\n is allowed");
  //   } else if(int.parse(this) > 8) {
  //     return ("Max. 8 capacity\n is allowed");
  //   }
  //   return null;
  // }
  //
  // String? isValidHours() {
  //   if(isEmpty){
  //     return ("Hours is required");
  //   }
  //   return null;
  // }
  //
  // String? isValidMinutes() {
  //   if(isEmpty){
  //     return ("Minutes is required");
  //   }
  //   return null;
  // }
}
