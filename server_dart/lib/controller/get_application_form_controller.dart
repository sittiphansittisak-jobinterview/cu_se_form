import 'package:server_dart/model/application_form_model.dart';
import 'package:server_dart/model/otp_model.dart';
import 'package:server_dart/model/user_model.dart';
import 'package:server_dart/private/setting/mongodb.dart';
import 'package:server_dart/private/utility/request_to_api.dart';
import 'package:share_flutter/object/application_form_object.dart';
import 'package:share_flutter/object/user_object.dart';
import 'package:share_flutter/request_validation/get_application_form_request_validation.dart';
import 'package:shelf/shelf.dart';
import 'package:share_flutter/object/otp_object.dart';

class GetApplicationFormController {
  GetApplicationFormController({required Request request}) : _request = request;

  final Request _request;
  final Mongodb _mongodb = Mongodb();
  final UserObject _user = UserObject();

  //request
  final OtpObject _otpRequest = OtpObject();

  //response
  String? messageResponse;
  ApplicationFormObject applicationFormResponse = ApplicationFormObject();

  Future<bool> receiveRequest() async {
    final api = await requestToApi(_request);
    if (api == null) return false;
    final otpMap = api.data?['otp'];
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
    final bool isUpdated = await OtpModel.updateToUseOtp(_mongodb, email: _otpRequest.email!, otpRef: _otpRequest.otpRef!, otpValue: _otpRequest.otpValue!, expireAt: DateTime.now().toUtc());
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

/* Future<bool> insertUser() async {
    _user.createAt = DateTime.now().toUtc();
    _user.email = _otpRequest.email;
    if (!_user.toMap() || _user.map == null) return (messageResponse = 'เกิดข้อผิดพลาดระหว่างเตรียมข้อมูลเพื่อเพิ่มบัญชีผู้ใช้ \n${MyAlertMessage.reportIssue}') == null; //worst case
    await _mongodb.openDb();
    _user.id = await UserModel.insertOne(_mongodb, map: _user.map!);
    if (_user.id == null) return (messageResponse = 'เกิดข้อผิดพลาดระหว่างเพิ่มข้อมูลบัญชีผู้ใช้  \n${MyAlertMessage.reportIssue}') == null; //worst case
    await _mongodb.closeDb();
    return true;
  }

  Future<bool> insertUserCancel() async {
    await _mongodb.openDb();
    if (!await UserModel.removeOne(_mongodb, id: _user.id!)) return false;
    await _mongodb.closeDb();
    return true;
  }

  Future<bool> sendEmailForNewUser() async {
    final String subject = 'สมาชิกใหม่';
    final String body = 'ยินดีต้อนรับสมาชิกใหม่เข้าสู่ CU SE FORM'
        '\nเราพบว่าคุณพึ่งเข้าร่วม CU SE FORM เมื่อ ${thaiDateTime(_user.createAt) ?? '-'}'
        '\nหากนี่ไม่ใช่คุณ ${MyAlertMessage.reportIssue}';
    if (!await sendEmailFunction(emailTarget: _otpRequest.email, subject: subject, body: body)) return (messageResponse = 'ส่งอีเมลแจ้งสมาชิกใหม่ไม่สำเร็จ') == null;
    return true;
  }*/
}
