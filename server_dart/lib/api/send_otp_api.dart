import 'dart:io';
import 'package:server_dart/controller/send_otp_controller.dart';
import 'package:server_dart/private/utility/generate_respone.dart';
import 'package:share_flutter/utility/my_alert_message.dart';
import 'package:shelf/shelf.dart';

Future<Response> sendOtpApi(Request request) async {
  final SendOtpController controller = SendOtpController(request: request);
  try {
    if (!await controller.receiveRequest()) return generateResponse(message: 'ข้อมูลที่ได้รับไม่ถูกต้อง');
    if (!await controller.validateRequest()) return generateResponse(message: controller.messageResponse);
    if (!await controller.insertOtp()) return generateResponse(httpStatus: HttpStatus.internalServerError, message: controller.messageResponse);
    if (!await controller.sendEmail()) {
      if (!await controller.insertOtpCancel()) return generateResponse(httpStatus: HttpStatus.internalServerError, message: 'เพิ่มข้อมูล OTP ลงในระบบแล้ว แต่ส่งอีเมลไม่สำเร็จ กรุณาตรวจสอบอีเมล'); //worst case
      return generateResponse(httpStatus: HttpStatus.internalServerError, message: controller.messageResponse);
    }
    return generateResponse(httpStatus: HttpStatus.ok, isSuccess: true, data: {'otpRef': controller.otpRefResponse}, message: 'ระบบได้ส่งรหัส OTP ไปยังอีเมลดังกล่าวแล้ว หากไม่ได้รับอีเมลกรุณาตรวจสอบอีเมลและลองใหม่อีกครั้ง');
  } catch (e) {
    return generateResponse(httpStatus: HttpStatus.internalServerError, message: '$e\n${MyAlertMessage.reportIssue}');
  }
}
