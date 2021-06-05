class Regex {
  static final email = RegExp(
      r"^[^\s@]+@[^\s@]+\.[^\s@]+$");
  static final onlyCharacter = RegExp("[a-zA-Z ]");

  static final onlyDigits = RegExp("[0-9]");
}
