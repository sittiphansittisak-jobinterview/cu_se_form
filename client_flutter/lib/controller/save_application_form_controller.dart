import 'package:share_dart/object/key/otp_key.dart';
import 'package:share_dart/private/utility/map_filter.dart';
import 'package:share_dart/request_validation/save_application_form_request_validation.dart';
import 'package:share_dart/object/application_form_object.dart';
import 'package:share_dart/object/otp_object.dart';
import 'package:share_dart/private/object/api_object.dart';
import 'package:share_dart/private/path/api_path.dart';
import 'package:share_dart/utility/delay_future_function.dart';

class SaveApplicationFormController {
  SaveApplicationFormController({required this.otpRequest, required this.applicationFormRequest});

  final ApiObject api = ApiObject(url: ApiPath.root + ApiPath.saveApplicationForm);

  //request
  final OtpObject otpRequest;
  final ApplicationFormObject applicationFormRequest;

  //response

  String? validateRequest() => saveApplicationFormRequestValidation(otp: otpRequest, applicationForm: applicationFormRequest);

  Future<bool> sendRequest() async {
    otpRequest.toMap();
    applicationFormRequest.toMap();
    otpRequest.map = mapFilter(otpRequest.map, allowKey: [OtpKey.email, OtpKey.otpRef, OtpKey.otpValue]);
    if (otpRequest.map == null) return false;
    api.parameterBody.addAll({'otp': otpRequest.map, 'applicationForm': applicationFormRequest.map});
    if (!await delayedFutureFunction(function: api.sendPostFormDataRequest)) return false;
    return true;
  }
}
