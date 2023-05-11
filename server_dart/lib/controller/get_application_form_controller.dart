import 'package:server_dart/model/application_form_model.dart';
import 'package:server_dart/model/otp_model.dart';
import 'package:server_dart/model/user_model.dart';
import 'package:server_dart/private/setting/mongodb.dart';
import 'package:share_dart/object/application_form_object.dart';
import 'package:share_dart/object/user_object.dart';
import 'package:share_dart/private/object/api_object.dart';
import 'package:share_dart/request_validation/get_application_form_request_validation.dart';
import 'package:share_dart/object/otp_object.dart';

class GetApplicationFormController {
  GetApplicationFormController({required ApiObject? api}) : _api = api;

  final ApiObject? _api;
  final Mongodb _mongodb = Mongodb();
  final UserObject _user = UserObject();

  //request
  final OtpObject _otpRequest = OtpObject();

  //response
  String? messageResponse;
  ApplicationFormObject applicationFormResponse = ApplicationFormObject();

  Future<bool> receiveRequest() async {
    if (_api == null) return false;
    final otpMap = _api!.data?['otp'];
    if (otpMap is! Map<String, dynamic>) return false;
    _otpRequest.map = otpMap;
    if (!_otpRequest.toObject()) return false;
    return true;
  }

  Future<bool> validateRequest() async {
    if ((messageResponse = getApplicationFormRequestValidation(otp: _otpRequest)) != null) return messageResponse == null;
    return true;
  }

  Future<bool> validateOtp() async {
    await _mongodb.openDb();
    final bool isUpdated = await OtpModel.updateToUseOtp(_mongodb, note: 'ใช้ค้นหาข้อมูล แบบฟอร์มประกอบการสมัครหลักสูตร SE', email: _otpRequest.email!, otpRef: _otpRequest.otpRef!, otpValue: _otpRequest.otpValue!, expireAt: DateTime.now().toUtc());
    await _mongodb.closeDb();
    if (!isUpdated) return (messageResponse = 'OTP ไม่ถูกต้องหรือถูกใช้/หมดอายุแล้ว') == null;
    return true;
  }

  Future<bool> findUser() async {
    await _mongodb.openDb();
    _user.map = await UserModel.findOneByEmail(_mongodb, email: _otpRequest.email!);
    await _mongodb.closeDb();
    if (_user.map == null) return (messageResponse = 'ไม่พบข้อมูลบัญชี/ใบงาน') == null; //No forms can exist if the user doesn't exist, since a form can only be created by a user
    _user.toObject();
    return true;
  }

  Future<bool> findApplicationForm() async {
    await _mongodb.openDb();
    applicationFormResponse.map = await ApplicationFormModel.findOneByUserId(_mongodb, userId: _user.id!);
    await _mongodb.closeDb();
    if (applicationFormResponse.map == null) return (messageResponse = 'ไม่พบข้อมูลใบงาน') == null;
    return true;
  }
}
