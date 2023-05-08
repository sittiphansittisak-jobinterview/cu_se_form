import 'package:client_flutter/controller/send_otp_controller.dart';
import 'package:client_flutter/private/style/color_style.dart';
import 'package:client_flutter/private/style/font_size_style.dart';
import 'package:client_flutter/private/style/space_style.dart';
import 'package:client_flutter/private/widget/button/dense_button_widget.dart';
import 'package:client_flutter/private/widget/dialog/awesome_dialog_widget.dart';
import 'package:client_flutter/private/widget/field/email_field_widget.dart';
import 'package:client_flutter/private/widget/text/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SendOtpView extends StatelessWidget {
  final SendOtpController controller;

  const SendOtpView({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Rx<String?> otpRef = Rx(null);

    final emailFieldWidget = Container(padding: SpaceStyle.allSmall, width: 200, child: EmailFieldWidget(title: 'อีเมล', hint: 'สำหรับตรวจสอบ OTP', onChange: (value) => controller.otpRequest.email = value));
    final sendOtpButtonWidget = Padding(
        padding: SpaceStyle.allSmall,
        child: DenseButtonWidget(
            text: 'ส่ง OTP ไปยังอีเมล',
            onClick: () async {
              String? errorMessage;
              errorMessage = controller.validateRequest();
              if (errorMessage != null) return await AwesomeDialogWidget.warning(title: 'ข้อมูลไม่ถูกต้อง', detail: errorMessage);
              if (!await controller.sendRequest()) return await AwesomeDialogWidget.failed(detail: controller.api.message);
              errorMessage = controller.receiveResponse();
              if (errorMessage != null) return await AwesomeDialogWidget.error(detail: errorMessage);
              await AwesomeDialogWidget.success(detail: 'ระบบได้ส่งอีเมลไปที่อีเมลของท่านแล้ว (รหัสอ้างอิง:${controller.otpRefResponse})');
              otpRef.value = controller.otpRefResponse;
            }));

    return Wrap(
      children: [
        Obx(() {
          if (otpRef.value == null) return emailFieldWidget;
          final otpRefWidget = TextWidget(text: 'รหัสอ้างอิง:${otpRef.value}', fontSize: FontSizeStyle.small, color: ColorStyle.accent);
          return Column(
            children: [
              emailFieldWidget,
              otpRefWidget,
            ],
          );
        }),
        sendOtpButtonWidget,
      ],
    );
  }
}
