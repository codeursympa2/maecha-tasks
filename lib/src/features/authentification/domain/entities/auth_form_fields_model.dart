class AuthFormFieldsModel{
  String? firstNameField;
  String? lastNameField;
  String? emailField;
  String? passwordField;
  String? passwordConfField;

  //Pour le register
  AuthFormFieldsModel(
      {
      this.firstNameField,
      this.lastNameField,
      this.emailField,
      this.passwordField,
      this.passwordConfField});

  //Pour le login
  AuthFormFieldsModel.login({required this.emailField, required this.passwordField});

  //Pour le reinitialisation
  AuthFormFieldsModel.forgot({required this.emailField});

}