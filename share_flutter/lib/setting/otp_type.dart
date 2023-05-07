class OtpType {
  static const addApplicationForm = 'addApplicationForm';
  static const getApplicationForm = 'getApplicationForm';

  static bool isCorrect(value) => [addApplicationForm, getApplicationForm].contains(value);
}
