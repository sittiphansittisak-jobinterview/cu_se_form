import 'package:share_flutter/request_validation/add_application_form_request_validation.dart';
import 'package:share_flutter/object/application_form_object.dart';
import 'package:share_flutter/object/otp_object.dart';
import 'package:share_flutter/private/object/api_object.dart';
import 'package:share_flutter/private/path/api_path.dart';

class AddApplicationFormController {
  AddApplicationFormController({required this.otpRequest});

  final ApiObject api = ApiObject(url: ApiPath.root + ApiPath.sendOtp);

  //request
  final OtpObject otpRequest;
  final ApplicationFormObject applicationFormRequest = ApplicationFormObject();

  //response

  String? validateRequest() => addApplicationFormRequestValidation(otp: otpRequest, applicationForm: applicationFormRequest);

  Future<bool> sendRequest() async {
    api.parameterBody.addAll({'email': otpRequest.email, 'otpValue': otpRequest.otpValue, 'applicationForm': applicationFormRequest.map});
    if (!await api.sendPostFormDataRequest()) return false;
    return true;
  }
}
