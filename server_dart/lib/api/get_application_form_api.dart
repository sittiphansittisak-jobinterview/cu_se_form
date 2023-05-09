import 'dart:io';
import 'package:server_dart/controller/get_application_form_controller.dart';
import 'package:server_dart/private/utility/generate_respone.dart';
import 'package:share_flutter/object/key/application_form_key.dart';
import 'package:share_flutter/private/utility/map_filter.dart';
import 'package:share_flutter/utility/my_alert_message.dart';
import 'package:shelf/shelf.dart';

Future<Response> getApplicationFormApi(Request request) async {
  final GetApplicationFormController controller = GetApplicationFormController(request: request);
  try {
    print(1);
    if (!await controller.receiveRequest()) return generateResponse(message: controller.messageResponse);
    print(2);
    if (!await controller.validateRequest()) return generateResponse(message: controller.messageResponse);
    print(3);
    if (!await controller.validateOtp()) return generateResponse(message: controller.messageResponse);
    print(4);
    if (!await controller.findUser()) return generateResponse(message: controller.messageResponse);
    print(5);
    if (!await controller.findApplicationForm()) return generateResponse(message: controller.messageResponse);
    print(6);
    controller.applicationFormResponse
      ..toObject()
      ..toMap(); //reformat
    controller.applicationFormResponse.map = mapFilter(controller.applicationFormResponse.map, removeKey: [ApplicationFormKey.id, ApplicationFormKey.userId]);
    return generateResponse(httpStatus: HttpStatus.ok, isSuccess: true, data: {'applicationForm': controller.applicationFormResponse.map});
  } catch (e) {
    return generateResponse(httpStatus: HttpStatus.internalServerError, message: '$e\n${MyAlertMessage.reportIssue}');
  }
}
