class OtpType {
  static const saveApplicationForm = 'saveApplicationForm';
  static const getApplicationForm = 'getApplicationForm';
  static const list = [saveApplicationForm, getApplicationForm];

  static bool isCorrect(value) => list.contains(value);

  static String toThai(value, {String defaultMessage = '-'}) {
    switch (value) {
      case saveApplicationForm:
        return 'บันทึกแบบฟอร์มประกอบการสมัครหลักสูตร SE';
      case getApplicationForm:
        return 'ค้นหาแบบฟอร์มประกอบการสมัครหลักสูตร SE';
      default:
        return defaultMessage;
    }
  }
}
