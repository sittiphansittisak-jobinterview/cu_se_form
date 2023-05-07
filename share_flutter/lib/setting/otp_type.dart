class OtpType {
  static const seApplicationForm = 'seApplicationForm';

  static bool isCorrect(value) => [seApplicationForm].contains(value);
}
