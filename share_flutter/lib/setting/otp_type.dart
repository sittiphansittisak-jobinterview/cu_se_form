class OtpType {
  static const addApplicationForm = 'addApplicationForm';
  static const getApplicationForm = 'getApplicationForm';
  static const list = [addApplicationForm, getApplicationForm];

  static bool isCorrect(value) => list.contains(value);
}
