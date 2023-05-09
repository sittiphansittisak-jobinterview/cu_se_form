import 'dart:io';
import 'package:server_dart/controller/save_application_form_controller.dart';
import 'package:server_dart/private/utility/generate_respone.dart';
import 'package:share_flutter/utility/my_alert_message.dart';
import 'package:shelf/shelf.dart';

Future<Response> saveApplicationFormApi(Request request) async {
  final SaveApplicationFormController controller = SaveApplicationFormController(request: request);
  bool? isSendEmailSuccess;
  try {
    if (!await controller.receiveRequest()) return generateResponse(message: 'ข้อมูลที่ได้รับไม่ถูกต้อง');
    if (!await controller.validateRequest()) return generateResponse(message: controller.messageResponse);
    if (!await controller.validateOtp()) return generateResponse(message: controller.messageResponse);
    if (!await controller.findUser()) {
      if (!await controller.insertUser()) return generateResponse(httpStatus: HttpStatus.internalServerError, message: controller.messageResponse);
      isSendEmailSuccess = await controller.sendEmailToNewUser();
      if (!isSendEmailSuccess && await controller.insertUserCancel()) return generateResponse(httpStatus: HttpStatus.internalServerError, message: controller.messageResponse);
    }
    final String message = isSendEmailSuccess == null ? '' : '\nยินดีต้อนรับสมาชิกใหม่${isSendEmailSuccess ? '(ระบบได้ส่งอีเมลแจ้งการเป็นสมาชิกใหม่ให้แล้ว)' : '(ระบบส่งอีเมลแจ้งการเป็นสมาชิกใหม่ไม่สำเร็จ)'}';
    if (!await controller.replaceApplicationForm()) return generateResponse(httpStatus: HttpStatus.internalServerError, message: '${controller.messageResponse}$message');
    return generateResponse(httpStatus: HttpStatus.ok, isSuccess: true, message: 'บันทึกข้อมูลสำเร็จ$message');
  } catch (e) {
    return generateResponse(httpStatus: HttpStatus.internalServerError, message: '$e\n${MyAlertMessage.reportIssue}');
  }
}
