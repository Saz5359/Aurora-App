String formatPhoneNumber(String number) {
  if (number.startsWith('0')) {
    return '+27${number.substring(1)}';
  }
  return number;
}

String? validatePhoneNumber(String? value) {
  final RegExp phoneRegex = RegExp(r'^0[678]\d{8}$'); // SA numbers: 06, 07, 08
  if (value == null || value.isEmpty) {
    return 'Phone number is required';
  }
  if (!phoneRegex.hasMatch(value)) {
    return 'Enter a valid South African number (e.g., 0785563421)';
  }

  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Password is required';
  }

  if (value.length < 8) {
    return 'Password must be at least 8 characters long';
  }

  if (!RegExp(r'[A-Z]').hasMatch(value)) {
    return 'Password must contain at least one uppercase letter';
  }

  if (!RegExp(r'[0-9]').hasMatch(value)) {
    return 'Password must contain at least one number';
  }

  return null; // Password is valid
}
