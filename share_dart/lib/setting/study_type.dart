class StudyType {
  static const normal = 'ภาคปกติ';
  static const extended = 'ภาคนอกเวลา';
  static const list = [normal, extended];

  static bool isCorrect(value) => list.contains(value);
}
