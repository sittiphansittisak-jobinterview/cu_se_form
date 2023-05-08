import 'package:share_flutter/object/application_form_object.dart';
import 'package:share_flutter/object/otp_object.dart';

String? addApplicationFormRequestValidation({required OtpObject otp, required ApplicationFormObject applicationForm}) {
  if (otp.email == null) return 'กรุณาเพิ่มข้อมูลอีเมล'; // bool isEmail(){}?
  if (otp.otpValue == null) return 'กรุณาเพิ่มข้อมูล OTP (ได้จากการส่งรหัส OTP ไปที่อีเมล)'; // bool isOtp(){}?
  if (_isStringEmpty(applicationForm.name)) return 'กรุณาเพิ่มข้อมูลชื่อ';
  if (_isStringEmpty(applicationForm.surname)) return 'กรุณาเพิ่มข้อมูลนามสกุุล';
  if (_isStringEmpty(applicationForm.studyType)) return 'กรุณาเพิ่มข้อมูลภาคเรียน';
  if (_isStringEmpty(applicationForm.studyPlan)) return 'กรุณาเพิ่มข้อมูลแผนการเรียน';
  if (applicationForm.hasPublishedPaper == null) return 'กรุณาเพิ่มข้อมูลว่าเคยตีพิมพ์บทความวิชาการหรือไม่';
  if (_isStringEmpty(applicationForm.researchInterests)) return 'กรุณาเพิ่มข้อมูลด้านที่อยากทำวิทยานิพนธ์/โครงงานมหาบัณฑิต';
  if ([applicationForm.proposedResearchMethodologyList ?? []].isEmpty) return 'กรุณาเพิ่มข้อมูลหัวข้อวิทยานิพนธ์/โครงงานมหาบัณฑิตที่ต้องการทำอย่างน้อย 1 รายการ';
  for (final proposedResearchMethodology in applicationForm.proposedResearchMethodologyList!) {
    if (_isStringEmpty(proposedResearchMethodology)) return 'กรุณาเพิ่มข้อมูลรายละเอียดของหัวข้อวิทยานิพนธ์/โครงงานมหาบัณฑิตที่ต้องการทำ';
  }
  if (!applicationForm.toMap()) return 'ระบบไม่สามารถแปลงข้อมูลได้ กรุณาลองใหม่อีกครั้ง';
  return null;
}

bool _isStringEmpty(String? string) => (string ?? '').trim().isEmpty;
