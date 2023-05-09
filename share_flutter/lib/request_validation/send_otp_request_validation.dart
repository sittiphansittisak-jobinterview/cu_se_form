import 'package:share_flutter/object/otp_object.dart';
import 'package:share_flutter/utility/is_email.dart';

String? sendOtpRequestValidation({required OtpObject otp}) {
  if (!isEmail(otp.email)) return 'กรุณาเพิ่มข้อมูลอีเมลให้ถูกต้อง';
  return null;
}
