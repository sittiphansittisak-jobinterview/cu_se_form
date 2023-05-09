import 'package:share_flutter/object/application_form_object.dart';
import 'package:share_flutter/object/otp_object.dart';
import 'package:share_flutter/setting/otp_type.dart';
import 'package:share_flutter/utility/is_email.dart';
import 'package:share_flutter/utility/my_alert_message.dart';

String? sendOtpRequestValidation({required OtpObject otp}) {
  if (!OtpType.isCorrect(otp.type)) return 'ไม่พบข้อมูลชนิดของ OTP กรุณาแจ้งปัญหาได้ที่ ${MyAlertMessage.reportIssue}';
  if (!isEmail(otp.email)) return 'กรุณาเพิ่มข้อมูลอีเมลให้ถูกต้อง';
  return null;
}
