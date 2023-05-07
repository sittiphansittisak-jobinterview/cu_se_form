class StudyPlan {
  static const planA = 'แผน ก';
  static const planB = 'แผน ข';

  static bool isCorrect(value) => [planA, planB].contains(value);
}
