import 'package:client_flutter/model/email_model.dart';
import 'package:share_dart/object/key/otp_key.dart';
import 'package:share_dart/private/utility/map_filter.dart';
import 'package:share_dart/request_validation/send_otp_request_validation.dart';
import 'package:share_dart/utility/delay_future_function.dart';
import 'package:share_dart/utility/my_alert_message.dart';
import 'package:share_dart/object/otp_object.dart';
import 'package:share_dart/private/object/api_object.dart';
import 'package:share_dart/private/path/api_path.dart';

class SendOtpController {
  SendOtpController({required this.otpRequest});

  final ApiObject api = ApiObject(url: ApiPath.root + ApiPath.sendOtp);

  //request
  final OtpObject otpRequest;

  //response
  String? otpRefResponse;

  Future initialRequest() async {
    otpRequest.email = await EmailModel.find();
  }

  String? validateRequest() => sendOtpRequestValidation(otp: otpRequest);

  Future<bool> sendRequest() async {
    otpRequest.toMap();
    otpRequest.map = mapFilter(otpRequest.map, allowKey: [OtpKey.email]);
    if (otpRequest.map == null) return false;
    api.parameterBody.addAll({'otp': otpRequest.map});
    if (!await delayedFutureFunction(function: api.sendPostFormDataRequest)) return false;
    await EmailModel.replace(otpRequest.email);
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
