import 'package:share_flutter/object/otp_object.dart';

String? getApplicationFormRequestValidation({required OtpObject otp}) {
  if (otp.email == null) return 'กรุณาเพิ่มข้อมูลอีเมล'; // bool isEmail(){}?
  if (otp.otpValue == null) return 'กรุณาเพิ่มข้อมูล OTP (ได้จากการส่งรหัส OTP ไปที่อีเมล)'; // bool isOtp(){}?
  return null;
}
