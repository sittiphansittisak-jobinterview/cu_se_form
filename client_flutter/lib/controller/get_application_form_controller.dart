import 'package:share_flutter/request_validation/get_application_form_request_validation.dart';
import 'package:share_flutter/utility/my_alert_message.dart';
import 'package:share_flutter/object/application_form_object.dart';
import 'package:share_flutter/object/otp_object.dart';
import 'package:share_flutter/private/object/api_object.dart';
import 'package:share_flutter/private/path/api_path.dart';

class GetApplicationFormController {
  GetApplicationFormController({required this.otpRequest});

  final ApiObject api = ApiObject(url: ApiPath.root + ApiPath.addApplicationForm);

  //request
  final OtpObject otpRequest;

  //response
  ApplicationFormObject? applicationFormResponse;

  String? validateRequest() => getApplicationFormRequestValidation(otp: otpRequest);

  Future<bool> sendRequest() async {
    api.parameterBody.addAll({'email': otpRequest.email, 'otpValue': otpRequest.otpValue});
    if (!await api.sendPostFormDataRequest()) return false;
    return true;
  }

  String? receiveResponse() {
    applicationFormResponse = null;
    final map = api.data?['applicationForm'];
    if (map is! Map<String, dynamic>) return 'ข้อมูลที่ได้รับจากเซิฟเวอร์ไม่ถูกต้อง ${MyAlertMessage.reportIssue}';
    final ApplicationFormObject applicationForm = ApplicationFormObject()..map = map;
    if (!applicationForm.toObject()) return 'ข้อมูลที่ได้รับจากเซิฟเวอร์ไม่ถูกต้อง ${MyAlertMessage.reportIssue}';
    applicationFormResponse = applicationForm;
    return null;
  }
}
