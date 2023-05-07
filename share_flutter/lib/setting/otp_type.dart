class OtpType {
  static const applicationForm = 'applicationForm';

  static bool isCorrect(value) => [applicationForm].contains(value);
}
