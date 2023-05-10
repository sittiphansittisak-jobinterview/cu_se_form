class StudyPlan {
  static const planA = 'แผน ก';
  static const planB = 'แผน ข';
  static const list = [planA, planB];

  static bool isCorrect(value) => list.contains(value);
}
