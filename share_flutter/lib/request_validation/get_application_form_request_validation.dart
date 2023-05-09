import 'package:share_flutter/object/otp_object.dart';
import 'package:share_flutter/utility/is_email.dart';

String? getApplicationFormRequestValidation({required OtpObject otp}) {
  if (!isEmail(otp.email)) return 'กรุณาเพิ่มข้อมูลอีเมลให้ถูกต้อง';
  if (!otp.isOtpValueCorrect) return 'กรุณาเพิ่มข้อมูล OTP ให้ถูกต้อง (ได้จากการส่งรหัส OTP ไปที่อีเมล)';
  if (!otp.isOtpRefCorrect) return 'กรุณาเพิ่มข้อมูล OTP ให้ถูกต้อง (ได้จากการส่งรหัส OTP ไปที่อีเมล)';
  return null;
}
