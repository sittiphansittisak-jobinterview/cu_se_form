import 'dart:io';
import 'package:server_dart/controller/send_otp_controller.dart';
import 'package:server_dart/private/utility/generate_respone.dart';
import 'package:share_flutter/utility/my_alert_message.dart';
import 'package:shelf/shelf.dart';

Future<Response> sendOtpApi(Request request) async {
  final SendOtpController controller = SendOtpController(request: request);
  try {
    if (!await controller.receiveRequest()) return generateResponse(httpStatus: HttpStatus.badRequest, isSuccess: false, message: controller.messageResponse);
    if (!await controller.validateRequest()) return generateResponse(httpStatus: HttpStatus.badRequest, isSuccess: false, message: controller.messageResponse);
    if (!await controller.insertOtp()) return generateResponse(httpStatus: HttpStatus.internalServerError, isSuccess: false, message: controller.messageResponse);
    if (!await controller.sendEmail()) {
      if (!await controller.insertOtpCancel()) return generateResponse(httpStatus: HttpStatus.internalServerError, isSuccess: false, message: 'เพิ่มข้อมูล OTP ลงในระบบแล้ว แต่ส่งอีเมลไม่สำเร็จ กรุณาตรวจสอบอีเมล'); //worst case
      return generateResponse(httpStatus: HttpStatus.internalServerError, isSuccess: false, message: controller.messageResponse);
    }
    return generateResponse(httpStatus: HttpStatus.ok, isSuccess: true, data: {'otpRef': controller.otpRefResponse});
  } catch (e) {
    return generateResponse(httpStatus: HttpStatus.internalServerError, isSuccess: false, message: '$e\n${MyAlertMessage.reportIssue}');
  }
}
