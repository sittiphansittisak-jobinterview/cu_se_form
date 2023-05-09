import 'package:share_flutter/object/key/otp_key.dart';
import 'package:share_flutter/private/utility/map_filter.dart';
import 'package:share_flutter/request_validation/save_application_form_request_validation.dart';
import 'package:share_flutter/object/application_form_object.dart';
import 'package:share_flutter/object/otp_object.dart';
import 'package:share_flutter/private/object/api_object.dart';
import 'package:share_flutter/private/path/api_path.dart';

class SaveApplicationFormController {
  SaveApplicationFormController({required this.otpRequest, required this.applicationFormRequest});

  final ApiObject api = ApiObject(url: ApiPath.root + ApiPath.saveApplicationForm);

  //request
  final OtpObject otpRequest;
  final ApplicationFormObject applicationFormRequest;

  //response

  String? validateRequest() => saveApplicationFormRequestValidation(otp: otpRequest, applicationForm: applicationFormRequest);

  Future<bool> sendRequest() async {
    if (!otpRequest.toMap() || !applicationFormRequest.toMap()) return false;
    otpRequest.map = mapFilter(otpRequest.map, allowKey: [OtpKey.email, OtpKey.otpRef, OtpKey.otpValue]);
    if (otpRequest.map == null) return false;
    api.parameterBody.addAll({'otp': otpRequest.map, 'applicationForm': applicationFormRequest.map});
    if (!await api.sendPostFormDataRequest()) return false;
    return true;
  }
}
