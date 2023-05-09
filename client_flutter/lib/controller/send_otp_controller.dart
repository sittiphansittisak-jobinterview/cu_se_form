import 'package:share_flutter/object/key/otp_key.dart';
import 'package:share_flutter/private/utility/map_filter.dart';
import 'package:share_flutter/request_validation/send_otp_request_validation.dart';
import 'package:share_flutter/utility/my_alert_message.dart';
import 'package:share_flutter/object/otp_object.dart';
import 'package:share_flutter/private/object/api_object.dart';
import 'package:share_flutter/private/path/api_path.dart';

class SendOtpController {
  SendOtpController({required this.otpRequest});

  final ApiObject api = ApiObject(url: ApiPath.root + ApiPath.sendOtp);

  //request
  final OtpObject otpRequest;

  //response
  String? otpRefResponse;

  String? validateRequest() => sendOtpRequestValidation(otp: otpRequest);

  Future<bool> sendRequest() async {
    if (!otpRequest.toMap()) return false;
    otpRequest.map = mapFilter(otpRequest.map, allowKey: [OtpKey.email]);
    if (otpRequest.map == null) return false;
    api.parameterBody.addAll({'otp': otpRequest.map});
    if (!await api.sendPostFormDataRequest()) return false;
    return true;
  }

  String? receiveResponse() {
    otpRefResponse = null;
    final otpRef = api.data?['otpRef'];
    if (otpRef is! String) return 'ข้อมูลที่ได้รับจากเซิฟเวอร์ไม่ถูกต้อง ${MyAlertMessage.reportIssue}';
    otpRefResponse = otpRequest.otpRef = otpRef;
    return null;
  }
}
