import 'package:server_dart/model/otp_model.dart';
import 'package:server_dart/private/setting/mongodb.dart';
import 'package:server_dart/private/utility/generate_otp_ref.dart';
import 'package:server_dart/private/utility/generate_otp_value.dart';
import 'package:server_dart/private/utility/request_to_api.dart';
import 'package:server_dart/private/utility/send_email_function.dart';
import 'package:share_flutter/setting/otp_type.dart';
import 'package:shelf/shelf.dart';
import 'package:share_flutter/object/otp_object.dart';
import 'package:share_flutter/request_validation/send_otp_request_validation.dart';

class SendOtpController {
  SendOtpController({required Request request}) : _request = request;

  final Request _request;
  final Mongodb _mongodb = Mongodb();

  //request
  final OtpObject _otpRequest = OtpObject();

  //response
  String? messageResponse;
  String? otpRefResponse;

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
    if ((messageResponse = sendOtpRequestValidation(otp: _otpRequest)) != null) return messageResponse == null;
    final DateTime beforeExpire5Min = DateTime.now().toUtc().subtract(Duration(minutes: 5));
    await _mongodb.openDb();
    final int countBeforeExpire = await OtpModel.countBeforeExpire(_mongodb, email: _otpRequest.email!, expireAt: beforeExpire5Min);
    await _mongodb.closeDb();
    if (countBeforeExpire >= 3) return (messageResponse = 'มีการขอส่ง OTP มากเกินไป โปรดรอสักครู่แล้วลองอีกครั้ง') == null; //prevent spammer
    return true;
  }

  Future<bool> insertOtp() async {
    final DateTime now = DateTime.now().toUtc();
    _otpRequest.createAt = now;
    _otpRequest.expireAt = now.add(Duration(minutes: 5));
    _otpRequest.isUsed = false;
    _otpRequest.otpRef = otpRefResponse = generateOtpRef();
    _otpRequest.otpValue = generateOtpValue();
    if (!_otpRequest.toMap()) return (messageResponse = 'เกิดข้อผิดพลาดระหว่างเตรียมข้อมูลสำหรับบันทึก OTP') == null;
    await _mongodb.openDb();
    _otpRequest.id = await OtpModel.insertOne(_mongodb, map: _otpRequest.map!);
    await _mongodb.closeDb();
    if (_otpRequest.id == null) return (messageResponse = 'เกิดข้อผิดพลาดระหว่างบันทึก OTP') == null;
    return true;
  }

  Future<bool> insertOtpCancel() async {
    await _mongodb.openDb();
    if (!await OtpModel.removeOne(_mongodb, id: _otpRequest.id!)) return false;
    await _mongodb.closeDb();
    return true;
  }

  Future<bool> sendEmail() async {
    final String subject = 'รหัส OTP';
    final String body = 'ใช้สำหรับยืนยันตัวตนเพื่อ${OtpType.toThai(_otpRequest.type)}'
        '\nรหัสอ้างอิง: ${_otpRequest.otpRef}'
        '\nรหัส OTP: ${_otpRequest.otpValue}';
    if (!await sendEmailFunction(emailTarget: _otpRequest.email, subject: subject, body: body)) return (messageResponse = 'ส่งอีเมลไม่สำเร็จ') == null;
    return true;
  }
}
