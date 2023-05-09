import 'package:share_flutter/object/key/otp_key.dart';
import 'package:share_flutter/private/utility/map_filter.dart';
import 'package:share_flutter/request_validation/get_application_form_request_validation.dart';
import 'package:share_flutter/utility/delay_future_function.dart';
import 'package:share_flutter/utility/my_alert_message.dart';
import 'package:share_flutter/object/application_form_object.dart';
import 'package:share_flutter/object/otp_object.dart';
import 'package:share_flutter/private/object/api_object.dart';
import 'package:share_flutter/private/path/api_path.dart';

class GetApplicationFormController {
  GetApplicationFormController({required this.otpRequest});

  final ApiObject api = ApiObject(url: ApiPath.root + ApiPath.getApplicationForm);

  //request
  final OtpObject otpRequest;

  //response
  ApplicationFormObject? applicationFormResponse;

  String? validateRequest() => getApplicationFormRequestValidation(otp: otpRequest);

  Future<bool> sendRequest() async {
    if (!otpRequest.toMap()) return false;
    otpRequest.map = mapFilter(otpRequest.map, allowKey: [OtpKey.email, OtpKey.otpRef, OtpKey.otpValue]);
    if (otpRequest.map == null) return false;
    api.parameterBody.addAll({'otp': otpRequest.map});
    if (!await delayedFutureFunction(function: api.sendPostFormDataRequest)) return false;
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
