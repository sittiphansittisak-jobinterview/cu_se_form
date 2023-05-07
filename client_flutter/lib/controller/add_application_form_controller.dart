import 'package:client_flutter/utility/my_alert_message.dart';
import 'package:share_flutter/object/application_form_object.dart';
import 'package:share_flutter/object/otp_object.dart';
import 'package:share_flutter/private/object/api_object.dart';
import 'package:share_flutter/private/path/api_path.dart';
import 'package:share_flutter/setting/otp_type.dart';

class AddApplicationFormController {
  AddApplicationFormController({required this.otpRequest});

  final ApiObject api = ApiObject(url: ApiPath.root + ApiPath.sendOtp);

  //request
  final OtpObject otpRequest;
  final ApplicationFormObject applicationFormRequest = ApplicationFormObject();

  //response

  String? validateRequest() {
    bool isStringEmpty(String? string) => (string ?? '').trim().isEmpty;
    if (otpRequest.email == null) return 'กรุณาเพิ่มข้อมูลอีเมล'; // bool isEmail(){}?
    if (otpRequest.otpValue == null) return 'กรุณาเพิ่มข้อมูล OTP'; // bool isOtp(){}?
    if (isStringEmpty(applicationFormRequest.name)) return 'กรุณาเพิ่มข้อมูลชื่อ';
    if (isStringEmpty(applicationFormRequest.surname)) return 'กรุณาเพิ่มข้อมูลนามสกุุล';
    if (isStringEmpty(applicationFormRequest.studyType)) return 'กรุณาเพิ่มข้อมูลภาคเรียน';
    if (isStringEmpty(applicationFormRequest.studyPlan)) return 'กรุณาเพิ่มข้อมูลแผนการเรียน';
    if (applicationFormRequest.hasPublishedPaper == null) return 'กรุณาเพิ่มข้อมูลว่าเคยตีพิมพ์บทความวิชาการหรือไม่';
    if (isStringEmpty(applicationFormRequest.researchInterests)) return 'กรุณาเพิ่มข้อมูลด้านที่อยากทำวิทยานิพนธ์/โครงงานมหาบัณฑิต';
    if ([applicationFormRequest.proposedResearchMethodologyList ?? []].isEmpty) return 'กรุณาเพิ่มข้อมูลหัวข้อวิทยานิพนธ์/โครงงานมหาบัณฑิตที่ต้องการทำอย่างน้อย 1 รายการ';
    for (final proposedResearchMethodology in applicationFormRequest.proposedResearchMethodologyList!) {
      if (isStringEmpty(proposedResearchMethodology)) return 'กรุณาเพิ่มข้อมูลรายละเอียดของหัวข้อวิทยานิพนธ์/โครงงานมหาบัณฑิตที่ต้องการทำ';
    }
    if (!applicationFormRequest.toMap()) return 'ระบบไม่สามารถแปลงข้อมูลได้ กรุณาลองใหม่อีกครั้ง';
    return null;
  }

  Future<bool> sendRequest() async {
    api.parameterBody.addAll({'email': otpRequest.email, 'otpValue': otpRequest.otpValue, 'applicationForm': applicationFormRequest.map});
    if (!await api.sendPostFormDataRequest()) return false;
    return true;
  }
}
