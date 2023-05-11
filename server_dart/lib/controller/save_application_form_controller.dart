import 'package:server_dart/model/application_form_model.dart';
import 'package:server_dart/model/otp_model.dart';
import 'package:server_dart/model/user_model.dart';
import 'package:server_dart/private/setting/mongodb.dart';
import 'package:server_dart/private/utility/send_email.dart';
import 'package:share_dart/object/application_form_object.dart';
import 'package:share_dart/object/user_object.dart';
import 'package:share_dart/private/object/api_object.dart';
import 'package:share_dart/request_validation/save_application_form_request_validation.dart';
import 'package:share_dart/utility/my_alert_message.dart';
import 'package:share_dart/utility/thai_date_time.dart';
import 'package:share_dart/object/otp_object.dart';

class SaveApplicationFormController {
  SaveApplicationFormController({required ApiObject? api}) : _api = api;

  final ApiObject? _api;
  final Mongodb _mongodb = Mongodb();
  final UserObject _user = UserObject();

  //request
  final OtpObject _otpRequest = OtpObject();
  final ApplicationFormObject _applicationFormRequest = ApplicationFormObject();

  //response
  String? messageResponse;

  Future<bool> receiveRequest() async {
    if (_api == null) return false;
    final otpMap = _api!.data?['otp'];
    final applicationFormMap = _api!.data?['applicationForm'];
    if (otpMap is! Map<String, dynamic>) return false;
    if (applicationFormMap is! Map<String, dynamic>) return false;
    _otpRequest.map = otpMap;
    _applicationFormRequest.map = applicationFormMap;
    if (!_otpRequest.toObject()) return false;
    if (!_applicationFormRequest.toObject()) return false;
    return true;
  }

  Future<bool> validateRequest() async {
    if ((messageResponse = saveApplicationFormRequestValidation(otp: _otpRequest, applicationForm: _applicationFormRequest)) != null) return messageResponse == null;
    return true;
  }

  Future<bool> validateOtp() async {
    await _mongodb.openDb();
    final bool isUpdated = await OtpModel.updateToUseOtp(_mongodb, note: 'ใช้บันทึกข้อมูล แบบฟอร์มประกอบการสมัครหลักสูตร SE', email: _otpRequest.email!, otpRef: _otpRequest.otpRef!, otpValue: _otpRequest.otpValue!, expireAt: DateTime.now().toUtc());
    await _mongodb.closeDb();
    if (!isUpdated) return (messageResponse = 'OTP ไม่ถูกต้องหรือถูกใช้/หมดอายุแล้ว') == null;
    return true;
  }

  Future<bool> findUser() async {
    await _mongodb.openDb();
    _user.map = await UserModel.findOneByEmail(_mongodb, email: _otpRequest.email!);
    await _mongodb.closeDb();
    if (_user.map == null) return false;
    _user.toObject();
    return true;
  }

  Future<bool> insertUser() async {
    _user.createAt = DateTime.now().toUtc();
    _user.email = _otpRequest.email;
    _user.toMap();
    await _mongodb.openDb();
    _user.id = await UserModel.insertOne(_mongodb, map: _user.map!);
    if (_user.id == null) return (messageResponse = 'เกิดข้อผิดพลาดระหว่างเพิ่มข้อมูลบัญชีผู้ใช้หรือมีข้อมูลในระบบแล้ว\n${MyAlertMessage.reportIssue}') == null; //worst case
    await _mongodb.closeDb();
    return true;
  }

  Future<bool> insertUserCancel() async {
    await _mongodb.openDb();
    if (!await UserModel.removeOne(_mongodb, id: _user.id!)) return false;
    await _mongodb.closeDb();
    return true;
  }

  Future<bool> sendEmailToNewUser() async {
    final String subject = 'สมาชิกใหม่';
    final String body = 'ยินดีต้อนรับสมาชิกใหม่เข้าสู่ CU SE form'
        '\nเราพบว่าคุณพึ่งเข้าร่วม CU SE form เมื่อ ${thaiDateTime(_user.createAt) ?? '-'}'
        '\n\n*****หากนี่ไม่ใช่คุณ ${MyAlertMessage.reportIssue}*****';
    if (!await sendEmail(emailTarget: _otpRequest.email, subject: subject, body: body)) return (messageResponse = 'ส่งอีเมลแจ้งการเป็นสมาชิกใหม่ไม่สำเร็จ') == null;
    return true;
  }

  Future<bool> replaceApplicationForm() async {
    _applicationFormRequest.userId = _user.id;
    _applicationFormRequest.toMap();
    await _mongodb.openDb();
    final isReplaced = await ApplicationFormModel.replaceOneByUserId(_mongodb, userId: _user.id!, map: _applicationFormRequest.map!);
    await _mongodb.closeDb();
    if (!isReplaced) return (messageResponse = 'บันทึกข้อมูลไม่สำเร็จ') == null; //worst case
    return true;
  }
}
