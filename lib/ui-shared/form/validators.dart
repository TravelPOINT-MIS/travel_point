class Validators {
  static String? requiredField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Required field';
    }
    return null;
  }
}
