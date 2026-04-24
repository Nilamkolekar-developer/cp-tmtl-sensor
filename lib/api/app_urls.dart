class AppURLs {
  static String get login => "accounts/login";
  static String get registerUser => "accounts/register/";
  static String get engineNumberCheck => "support/validate/engine-serial-no/";
  static String get receipeData =>
      "support/create/<uuid:model_validation_id>/model-validation-session/";
}
