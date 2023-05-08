import 'package:flutter/material.dart';
import 'package:kt_eclaim_template/setting/duration_setting.dart';
import 'package:kt_eclaim_template/utility/date_time_management.dart';
import 'package:kt_eclaim_template/widget_enviroment/widget/button/dense_button_widget.dart';
import 'package:kt_eclaim_template/widget_enviroment/widget/dialog/awesome_dialog_widget.dart';
import 'package:get/get.dart';
import 'package:kt_eclaim_admin/controller/application_form_send_email_controller.dart';

class ApplicationFormSendEmailView extends StatelessWidget {
  final ApplicationFormSendEmailController controller;
  final DateTime? initialTimeoutAt;

  const ApplicationFormSendEmailView({Key? key, required this.controller, required this.initialTimeoutAt}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Rx<String?> sendAt = Rx(DateTimeManagement.displayInThai(initialTimeoutAt));
    int timeoutAt = 0;

    final Widget sendEmailButton = DenseButtonWidget(
        text: 'ส่งอีเมลแจ้งผลสมัครงาน',
        onClick: () async {
          if (sendAt.value != null) {
            await AwesomeDialogWidget.warning(detail: 'ไม่สามารถส่งอีเมลได้ ส่งได้อีกครั้งใน ${(DateTime.fromMillisecondsSinceEpoch(timeoutAt).difference(DateTime.now()).inMinutes) + 1} นาที'); //Add 1 minute for rounding down by `difference` function.
            return;
          }
          if (!await controller.action()) return;
          timeoutAt = DateTime.now().millisecondsSinceEpoch + DurationSetting.preventSpamEmail.inMilliseconds;
          sendAt.value = DateTimeManagement.displayInThai(controller.timeResponse);
          Future.delayed(DurationSetting.preventSpamEmail, () => sendAt.value = null);
        });

    return Obx(() {
      if (sendAt.value == null) return sendEmailButton;
      return Tooltip(message: 'ส่งล่าสุดเมื่อ ${sendAt.value!}', child: sendEmailButton);
    });
  }
}
