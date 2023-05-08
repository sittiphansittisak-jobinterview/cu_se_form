import 'package:share_flutter/request_validation/send_otp_request_validation.dart';
import 'package:share_flutter/utility/my_alert_message.dart';
import 'package:share_flutter/object/otp_object.dart';
import 'package:share_flutter/private/object/api_object.dart';
import 'package:share_flutter/private/path/api_path.dart';

class SendOtpController {
  SendOtpController({required String otpType, required this.otpRequest}) : _otpTypeRequest = otpType;

  final ApiObject api = ApiObject(url: ApiPath.root + ApiPath.sendOtp);

  //request
  final String _otpTypeRequest;
  final OtpObject otpRequest;

  //response
  String? otpRefResponse;

  String? validateRequest() => sendOtpRequestValidation(otp: otpRequest..type = _otpTypeRequest);

  Future<bool> sendRequest() async {
    api.parameterBody.addAll({'type': otpRequest.type, 'email': otpRequest.email});
    if (!await api.sendPostFormDataRequest()) return false;
    return true;
  }

  String? receiveResponse() {
    otpRefResponse = null;
    final otpRef = api.data?['otpRef'];
    if (otpRef is! String) return 'ข้อมูลที่ได้รับจากเซิฟเวอร์ไม่ถูกต้อง ${MyAlertMessage.reportIssue}';
    otpRefResponse = otpRef;
    return null;
  }
}
