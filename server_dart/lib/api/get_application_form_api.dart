import 'dart:io';
import 'package:server_dart/controller/get_application_form_controller.dart';
import 'package:server_dart/private/utility/generate_respone.dart';
import 'package:share_dart/object/key/application_form_key.dart';
import 'package:share_dart/private/utility/map_filter.dart';
import 'package:share_dart/utility/my_alert_message.dart';
import 'package:shelf/shelf.dart';

Future<Response> getApplicationFormApi(Request request) async {
  final GetApplicationFormController controller = GetApplicationFormController(request: request);
  try {
    if (!await controller.receiveRequest()) return generateResponse(message: 'ข้อมูลที่ได้รับไม่ถูกต้อง');
    if (!await controller.validateRequest()) return generateResponse(message: controller.messageResponse);
    if (!await controller.validateOtp()) return generateResponse(message: controller.messageResponse);
    if (!await controller.findUser()) return generateResponse(message: controller.messageResponse);
    if (!await controller.findApplicationForm()) return generateResponse(message: controller.messageResponse);
    controller.applicationFormResponse
      ..toObject()
      ..toMap(); //reformat
    controller.applicationFormResponse.map = mapFilter(controller.applicationFormResponse.map, removeKey: [ApplicationFormKey.id, ApplicationFormKey.userId]);
    return generateResponse(httpStatus: HttpStatus.ok, isSuccess: true, data: {'applicationForm': controller.applicationFormResponse.map});
  } catch (e) {
    return generateResponse(httpStatus: HttpStatus.internalServerError, message: '$e\n${MyAlertMessage.reportIssue}');
  }
}
