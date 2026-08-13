/// Shared form validators.
///
/// Centralized here (instead of inline per-screen) so login, register,
/// and "edit profile" all enforce the exact same rules — you never want
/// register to accept a password that login's validator would reject.
class Validators {
  Validators._();

  // Letters (incl. common accented characters), spaces, hyphens, and
  // apostrophes only — covers names like "Anne-Marie" or "O'Brien"
  // without allowing digits or symbols.
  static final RegExp _namePattern = RegExp(r"^[a-zA-Z\u00C0-\u017F' -]+$");

  // Practical email pattern: local part, @, domain with a TLD of at
  // least 2 letters. Not full RFC 5322 (nothing simple is), but catches
  // the mistakes users actually make.
  static final RegExp _emailPattern = RegExp(
    r'^[\w.+-]+@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*\.[a-zA-Z]{2,}$',
  );

  static final RegExp _hasUppercase = RegExp(r'[A-Z]');
  static final RegExp _hasLowercase = RegExp(r'[a-z]');
  static final RegExp _hasDigit = RegExp(r'[0-9]');
  static final RegExp _hasSpecialChar = RegExp(
    r'[!@#$%^&*(),.?":{}|<>_\-\[\]/\\+=~`]',
  );

  /// Full name: required, 2-50 chars after trimming, letters/spaces/
  /// hyphens/apostrophes only, and must contain at least two parts
  /// (first + last) so "a" or "asdf" doesn't pass as a name.
  static String? fullName(String? value) {
    final name = value?.trim() ?? '';

    if (name.isEmpty) return 'Enter your full name.';
    if (name.length < 2) return 'Name is too short.';
    if (name.length > 50) return 'Name is too long.';
    if (!_namePattern.hasMatch(name)) {
      return 'Name can only contain letters, spaces, and hyphens.';
    }
    if (!name.contains(RegExp(r'\s'))) {
      return 'Enter your first and last name.';
    }
    if (name.contains(RegExp(r'\s{2,}'))) {
      return 'Remove extra spaces between names.';
    }
    return null;
  }

  /// Email: required, trimmed, must match a practical email shape.
  static String? email(String? value) {
    final email = value?.trim() ?? '';

    if (email.isEmpty) return 'Enter your email.';
    if (email.length > 254) return 'Email is too long.';
    if (!_emailPattern.hasMatch(email)) {
      return 'Enter a valid email address.';
    }
    return null;
  }

  /// Password strength: at least 8 characters, with at least one
  /// uppercase letter, one lowercase letter, one digit, and one special
  /// character. Reports the *first* unmet rule rather than a generic
  /// "invalid password" so the student knows exactly what to fix.
  static String? password(String? value) {
    final password = value ?? '';

    if (password.isEmpty) return 'Enter a password.';
    if (password.length < 8) return 'Password needs at least 8 characters.';
    if (password.length > 72) return 'Password is too long.';
    if (password.contains(' ')) return 'Password cannot contain spaces.';
    if (!_hasUppercase.hasMatch(password)) {
      return 'Add at least one uppercase letter.';
    }
    if (!_hasLowercase.hasMatch(password)) {
      return 'Add at least one lowercase letter.';
    }
    if (!_hasDigit.hasMatch(password)) {
      return 'Add at least one number.';
    }
    if (!_hasSpecialChar.hasMatch(password)) {
      return 'Add at least one special character (e.g. ! @ # ?).';
    }
    return null;
  }

  /// Confirm-password: must be non-empty and equal to [original].
  static String? confirmPassword(String? value, String original) {
    if (value == null || value.isEmpty) return 'Re-enter your password.';
    if (value != original) return "Passwords don't match.";
    return null;
  }
}
