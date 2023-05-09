import 'package:client_flutter/controller/send_otp_controller.dart';
import 'package:client_flutter/private/style/color_style.dart';
import 'package:client_flutter/private/style/font_size_style.dart';
import 'package:client_flutter/private/style/sized_box_style.dart';
import 'package:client_flutter/private/style/space_style.dart';
import 'package:client_flutter/private/widget/button/dense_button_widget.dart';
import 'package:client_flutter/private/widget/card/form_card_widget.dart';
import 'package:client_flutter/private/widget/dialog/awesome_dialog_widget.dart';
import 'package:client_flutter/private/widget/field/dropdown_search_field_widget.dart';
import 'package:client_flutter/private/widget/field/email_field_widget.dart';
import 'package:client_flutter/private/widget/field/text_field_widget.dart';
import 'package:client_flutter/private/widget/text/text_widget.dart';
import 'package:flutter/material.dart';

class SendOtpView extends StatefulWidget {
  final SendOtpController controller;

  const SendOtpView({Key? key, required this.controller}) : super(key: key);

  @override
  State<SendOtpView> createState() => _SendOtpViewState();
}

class _SendOtpViewState extends State<SendOtpView> {
  Widget _otpRefWidgetBuilder() => TextWidget(text: 'รหัสอ้างอิง:${widget.controller.otpRefResponse}', fontSize: FontSizeStyle.small, color: ColorStyle.accent);
  late final Widget _emailFieldWidget = EmailFieldWidget(title: 'อีเมล', hint: 'สำหรับตรวจสอบ OTP', onChange: (value) => widget.controller.otpRequest.email = value);
  late final Widget _sendOtpButtonWidget = Padding(
      padding: SpaceStyle.allSmall,
      child: DenseButtonWidget(
          text: 'ส่ง OTP ไปยังอีเมล',
          onClick: () async {
            String? errorMessage;
            errorMessage = widget.controller.validateRequest();
            if (errorMessage != null) return await AwesomeDialogWidget.warning(title: 'ข้อมูลไม่ถูกต้อง', detail: errorMessage);
            if (!await widget.controller.sendRequest()) return await AwesomeDialogWidget.failed(detail: widget.controller.api.message);
            errorMessage = widget.controller.receiveResponse();
            if (errorMessage != null) return await AwesomeDialogWidget.error(detail: errorMessage);
            await AwesomeDialogWidget.success(detail: 'ระบบได้ส่งรหัส OTP ไปยังอีเมลของท่านแล้ว\n(รหัสอ้างอิง:${widget.controller.otpRefResponse})');
            setState(() {});
          }));
  late final _otpValueFieldWidget = TextFieldWidget(title: 'รหัส OTP', initialValue: widget.controller.otpRequest.otpValue, onChange: (value) => widget.controller.otpRequest.otpValue = value);

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgetList = widget.controller.otpRefResponse != null ? [SizedBoxStyle.heightTiny, _otpRefWidgetBuilder()] : [];
    return FormCardWidget(
      title: 'ตรวจสอบข้อมูลผู้ใช้ด้วย OTP',
      childrenList: [
        [
          Column(children: [_emailFieldWidget, ...widgetList]),
          _sendOtpButtonWidget
        ],
        if (widget.controller.otpRefResponse != null) [_otpValueFieldWidget, null],
      ],
    );
  }
}
