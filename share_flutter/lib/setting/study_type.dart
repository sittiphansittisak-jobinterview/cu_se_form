class StudyType {
  static const normal = 'ภาคปกติ';
  static const extended = 'ภาคนอกเวลา';

  static bool isCorrect(value) => [normal, extended].contains(value);
}
