import 'package:share_flutter/request_validation/add_application_form_request_validation.dart';
import 'package:share_flutter/object/application_form_object.dart';
import 'package:share_flutter/object/otp_object.dart';
import 'package:share_flutter/private/object/api_object.dart';
import 'package:share_flutter/private/path/api_path.dart';

class SaveApplicationFormController {
  SaveApplicationFormController({required this.otpRequest, required this.applicationFormRequest});

  final ApiObject api = ApiObject(url: ApiPath.root + ApiPath.sendOtp);

  //request
  final OtpObject otpRequest;
  final ApplicationFormObject applicationFormRequest;

  //response

  String? validateRequest() => addApplicationFormRequestValidation(otp: otpRequest, applicationForm: applicationFormRequest);

  Future<bool> sendRequest() async {
    api.parameterBody.addAll({'email': otpRequest.email, 'otpValue': otpRequest.otpValue, 'applicationForm': applicationFormRequest.map});
    if (!await api.sendPostFormDataRequest()) return false;
    return true;
  }
}
