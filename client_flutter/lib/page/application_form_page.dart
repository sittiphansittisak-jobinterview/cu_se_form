import 'package:client_flutter/controller/save_application_form_controller.dart';
import 'package:client_flutter/controller/get_application_form_controller.dart';
import 'package:client_flutter/controller/send_otp_controller.dart';
import 'package:client_flutter/path/page_path.dart';
import 'package:client_flutter/private/complex_widget/app_bar_widget.dart';
import 'package:client_flutter/private/complex_widget/drawer_widget.dart';
import 'package:client_flutter/private/style/color_style.dart';
import 'package:client_flutter/private/style/font_size_style.dart';
import 'package:client_flutter/private/style/sized_box_style.dart';
import 'package:client_flutter/private/style/space_style.dart';
import 'package:client_flutter/private/widget/button/dense_button_widget.dart';
import 'package:client_flutter/private/widget/dialog/awesome_dialog_widget.dart';
import 'package:client_flutter/private/widget/loading/circular_loading_widget.dart';
import 'package:client_flutter/private/widget/text/text_widget.dart';
import 'package:client_flutter/view/application_form_view.dart';
import 'package:client_flutter/view/send_otp_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_flutter/object/application_form_object.dart';
import 'package:share_flutter/object/otp_object.dart';

class ApplicationFormPage extends StatefulWidget {
  const ApplicationFormPage({Key? key}) : super(key: key);

  @override
  State<ApplicationFormPage> createState() => _ApplicationFormPageState();
}

class _ApplicationFormPageState extends State<ApplicationFormPage> {
  //basic
  final Rx<bool> _isApplicationFormLoading = Rx(false);
  final BoxConstraints _formWidth = const BoxConstraints(maxWidth: 210.0 * 2.83);
  final PreferredSizeWidget _appBarWidget = const AppBarWidget(url: PagePath.index);
  final Widget _drawerWidget = const DrawerWidget();
  final Widget _titleWidget = const TextWidget(text: 'แบบฟอร์มประกอบการสมัครหลักสูตร SE', isBold: true, fontSize: FontSizeStyle.big);
  final Widget _subTitleWidget = const TextWidget(text: 'กรุณาใช้รหัส OTP ในการค้นหาหรือบันทึกแบบฟอร์ม โดยรหัส OTP มีอายุการใช้งาน 5 นาที', fontSize: FontSizeStyle.basic);
  final Widget _dividerWidget = const Divider(color: ColorStyle.primary);
  final Widget _loadingWidget = const CircularLoadingWidget(title: 'กำลังดำเนินการ....');

  //controller
  final OtpObject _otp = OtpObject();
  final ApplicationFormObject _applicationForm = ApplicationFormObject();
  late final SendOtpController _sendOtpController = SendOtpController(otpRequest: _otp);
  late final GetApplicationFormController _getApplicationFormController = GetApplicationFormController(otpRequest: _otp);
  late final SaveApplicationFormController _saveApplicationFormController = SaveApplicationFormController(otpRequest: _otp, applicationFormRequest: _applicationForm);

  //view
  late final SendOtpView _sendOtpView = SendOtpView(controller: _sendOtpController);
  late final ApplicationFormView _applicationFormView = ApplicationFormView(isWrite: true, applicationForm: _applicationForm);
  late final Widget _getApplicationFormButtonWidget = DenseButtonWidget(
      text: 'ค้นหาแบบฟอร์ม',
      onClick: () async {
        _isApplicationFormLoading.value = true;
        try {
          String? errorMessage;
          errorMessage = _getApplicationFormController.validateRequest();
          if (errorMessage != null) return await AwesomeDialogWidget.warning(title: 'ข้อมูลไม่ถูกต้อง', detail: errorMessage);
          if (!await _getApplicationFormController.sendRequest()) return await AwesomeDialogWidget.failed(detail: _getApplicationFormController.api.message);
          errorMessage = _getApplicationFormController.receiveResponse();
          if (errorMessage != null) return await AwesomeDialogWidget.error(detail: errorMessage);
          if (_getApplicationFormController.api.message != null) await AwesomeDialogWidget.success(detail: _getApplicationFormController.api.message);
          _applicationForm.map = (_getApplicationFormController.applicationFormResponse?..toMap())?.map;
          _applicationForm.toObject();
        } finally {
          _isApplicationFormLoading.value = false;
        }
      });
  late final Widget _saveApplicationFormButtonWidget = DenseButtonWidget(
      text: 'บันทึกข้อมูล',
      onClick: () async {
        String? errorMessage;
        errorMessage = _saveApplicationFormController.validateRequest();
        if (errorMessage != null) return await AwesomeDialogWidget.warning(title: 'ข้อมูลไม่ถูกต้อง', detail: errorMessage);
        if (!await _saveApplicationFormController.sendRequest()) return await AwesomeDialogWidget.failed(detail: _saveApplicationFormController.api.message);
        await AwesomeDialogWidget.success(title: 'บันทึกข้อมูลสำเร็จ', detail: _saveApplicationFormController.api.message);
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBarWidget,
      endDrawer: _drawerWidget,
      body: SingleChildScrollView(
        padding: SpaceStyle.allBasic,
        child: Center(
          child: Column(
            children: [
              SizedBoxStyle.heightLarge,
              _titleWidget,
              _subTitleWidget,
              SizedBoxStyle.heightSmall,
              ConstrainedBox(
                constraints: _formWidth,
                child: Column(
                  children: [
                    _sendOtpView,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _getApplicationFormButtonWidget,
                        _saveApplicationFormButtonWidget,
                      ],
                    ),
                  ],
                ),
              ),
              Padding(padding: SpaceStyle.verticalBasic, child: _dividerWidget),
              ConstrainedBox(constraints: _formWidth, child: Obx(() => _isApplicationFormLoading.value ? _loadingWidget : _applicationFormView)),
            ],
          ),
        ),
      ),
    );
  }
}
