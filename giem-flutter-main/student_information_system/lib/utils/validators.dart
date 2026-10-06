
class Validators {
  static String? required(String? value, [String label = 'This field']) {
    if (value == null || value.trim().isEmpty) {
      return '$label is required.';
    }
    return null;
  }

  static String? email(String? value) {
    final requiredError = required(value, 'Email');
    if (requiredError != null) return requiredError;

    final pattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return pattern.hasMatch(value!.trim()) ? null : 'Enter a valid email.';
  }

  static String? yearLevel(String? value) {
    final requiredError = required(value, 'Year level');
    if (requiredError != null) return requiredError;

    final year = int.tryParse(value!.trim());
    if (year == null || year < 1 || year > 4) {
      return 'Year level must be between 1 and 4.';
    }
    return null;
  }

  static String? studentId(String? value) {
    final error = required(value, 'Student ID');
    if (error != null) return error;
    if (value!.trim().length < 3) return 'Student ID is too short.';
    return null;
  }

  static String? password(String? value) {
    final error = required(value, 'Password');
    if (error != null) return error;
    if (value!.length < 6) return 'Password must be at least 6 characters.';
    return null;
  }
}

