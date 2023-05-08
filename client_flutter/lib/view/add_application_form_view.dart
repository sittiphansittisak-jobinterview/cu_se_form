import 'package:client_flutter/controller/add_application_form_controller.dart';
import 'package:client_flutter/controller/send_otp_controller.dart';
import 'package:client_flutter/private/style/sized_box_style.dart';
import 'package:client_flutter/private/widget/button/dense_button_widget.dart';
import 'package:client_flutter/private/widget/button/widget_builder_button_widget.dart';
import 'package:client_flutter/private/widget/card/form_card_widget.dart';
import 'package:client_flutter/private/widget/dialog/awesome_dialog_widget.dart';
import 'package:client_flutter/private/widget/field/dropdown_search_field_widget.dart';
import 'package:client_flutter/private/widget/field/switch_field_widget.dart';
import 'package:client_flutter/private/widget/field/text_area_field_widget.dart';
import 'package:client_flutter/private/widget/field/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_flutter/object/programming_experience_object.dart';
import 'package:share_flutter/object/research_experience_object.dart';
import 'package:share_flutter/setting/study_plan.dart';
import 'package:share_flutter/setting/study_type.dart';

class AddApplicationFormView extends StatelessWidget {
  final AddApplicationFormController controller;
  final Widget? otpCardWidget;

  const AddApplicationFormView({Key? key, required this.controller, this.otpCardWidget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.applicationFormRequest.programmingExperienceList = [];
    controller.applicationFormRequest.computerExperienceList = [];
    controller.applicationFormRequest.hasPublishedPaper = false;
    controller.applicationFormRequest.researchExperienceList = [];
    controller.applicationFormRequest.computerLearningExperienceList = [];
    controller.applicationFormRequest.proposedResearchMethodologyList = [];

    final Rx<List<Key>> programmingExperienceListKeyList = Rx([]);
    final Rx<List<Key>> computerExperienceListKeyList = Rx([]);
    final Rx<bool> hasPublishedPaper = Rx(controller.applicationFormRequest.hasPublishedPaper!);
    final Rx<List<Key>> researchExperienceListKeyList = Rx([]);
    final Rx<List<Key>> computerLearningExperienceListKeyList = Rx([]);
    final Rx<List<Key>> proposedResearchMethodologyListKeyList = Rx([]);

    final Widget programmingExperienceListButton = WidgetBuilderButtonWidget(text: '+ เพิ่มข้อมูลประสบการณ์เขียนโปรแกรม', keyList: programmingExperienceListKeyList, itemList: controller.applicationFormRequest.programmingExperienceList!, item: () => ProgrammingExperienceObject());
    final Widget computerExperienceListButton = WidgetBuilderButtonWidget(text: '+ ประสบการณ์การทำงานด้านคอมพิวเตอร์', keyList: computerExperienceListKeyList, itemList: controller.applicationFormRequest.computerExperienceList!, item: () => '');
    final Widget researchExperienceListButton = WidgetBuilderButtonWidget(text: '+ รายชื่อบทความและแหล่งตีพิมพ์', keyList: researchExperienceListKeyList, itemList: controller.applicationFormRequest.researchExperienceList!, item: () => ResearchExperienceObject());
    final Widget computerLearningExperienceListButton = WidgetBuilderButtonWidget(text: '+ ประสบการณ์การเรียนรู้ด้านคอมพิวเตอร์', keyList: computerLearningExperienceListKeyList, itemList: controller.applicationFormRequest.computerLearningExperienceList!, item: () => '');
    final Widget proposedResearchMethodologyListButton = WidgetBuilderButtonWidget(text: '+ หัวข้อที่ต้องการทำ พร้อมแนวทางการทำ', keyList: proposedResearchMethodologyListKeyList, itemList: controller.applicationFormRequest.proposedResearchMethodologyList!, item: () => '');
    final Widget nameFieldWidget = TextFieldWidget(title: 'ชื่อ', onChange: (value) => controller.applicationFormRequest.name = value);
    final Widget surnameFieldWidget = TextFieldWidget(title: 'นามสกุล', onChange: (value) => controller.applicationFormRequest.surname = value);
    final Widget studyTypeFieldWidget = DropdownSearchField<String>(title: 'ภาคเรียน', item: StudyType.list, getText: (value) => value, onChange: ({value, String? text}) => controller.applicationFormRequest.studyType = value);
    final Widget studyPlanFieldWidget = DropdownSearchField<String>(title: 'แผนการเรียน', item: StudyPlan.list, getText: (value) => value, onChange: ({value, String? text}) => controller.applicationFormRequest.studyPlan = value);
    final Widget programmingExperienceListFieldWidget = Obx(() {
      Widget languageBuilder(int index) => TextFieldWidget(title: 'ภาษา', onChange: (value) => controller.applicationFormRequest.programmingExperienceList![index].language = value);
      Widget frameworkBuilder(int index) => TextFieldWidget(title: 'เฟรมเวิร์ก', onChange: (value) => controller.applicationFormRequest.programmingExperienceList![index].framework = value);
      Widget toolBuilder(int index) => TextFieldWidget(title: 'เครื่องมือ', onChange: (value) => controller.applicationFormRequest.programmingExperienceList![index].tool = value);
      Widget environmentBuilder(int index) => TextFieldWidget(title: 'สภาพแวดล้อม', onChange: (value) => controller.applicationFormRequest.programmingExperienceList![index].environment = value);
      Widget durationBuilder(int index) => TextFieldWidget(title: 'ระยะเวลา', onChange: (value) => controller.applicationFormRequest.programmingExperienceList![index].duration = value);
      Widget mostLinesOfCodeBuilder(int index) => TextFieldWidget(title: 'จำนวน Lines of code มากที่สุดที่เคยเขียน', onChange: (value) => controller.applicationFormRequest.programmingExperienceList![index].mostLinesOfCode = value);
      Widget descriptionBuilder(int index) => TextAreaFieldWidget(title: 'คำอธิบายของงานที่ทำ', onChange: (value) => controller.applicationFormRequest.programmingExperienceList![index].description = value);
      List<Widget> children = [];
      for (int index = 0; index < programmingExperienceListKeyList.value.length; index++) {
        children.add(FormCardWidget(
            key: programmingExperienceListKeyList.value[index],
            isSubCard: true,
            title: 'ประสบการณ์เขียนโปรแกรมที่ ${index + 1}',
            childrenList: [
              [languageBuilder(index), frameworkBuilder(index)],
              [toolBuilder(index), environmentBuilder(index)],
              [durationBuilder(index), mostLinesOfCodeBuilder(index)],
              [descriptionBuilder(index)],
            ],
            onClose: () {
              programmingExperienceListKeyList.value = [...programmingExperienceListKeyList.value..removeAt(index)];
              controller.applicationFormRequest.programmingExperienceList!.removeAt(index);
            }));
      }
      return Column(children: children);
    });
    final Widget computerExperienceListFieldWidget = Obx(() {
      Widget languageBuilder(int index) => TextAreaFieldWidget(title: 'รายละเอียด', onChange: (value) => controller.applicationFormRequest.computerExperienceList![index] = value ?? '');
      List<Widget> children = [];
      for (int index = 0; index < computerExperienceListKeyList.value.length; index++) {
        children.add(FormCardWidget(
            key: computerExperienceListKeyList.value[index],
            isSubCard: true,
            title: 'ประสบการณ์การทำงานด้านคอมพิวเตอร์ที่ ${index + 1}',
            childrenList: [
              [languageBuilder(index)],
            ],
            onClose: () {
              computerExperienceListKeyList.value = [...computerExperienceListKeyList.value..removeAt(index)];
              controller.applicationFormRequest.computerExperienceList!.removeAt(index);
            }));
      }
      return Column(children: children);
    });
    final Widget hasPublishedPaperFieldWidget = SwitchFieldWidget(
        title: 'ไม่เคยตีพิมพ์บทความวิชาการ',
        titleOn: 'เคยตีพิมพ์บทความวิชาการ',
        initialValue: controller.applicationFormRequest.hasPublishedPaper,
        onChange: (value) {
          hasPublishedPaper.value = controller.applicationFormRequest.hasPublishedPaper = value ?? false;
          controller.applicationFormRequest.researchExperienceList!.removeWhere((element) => true);
          researchExperienceListKeyList.value = [];
        });
    final Widget researchExperienceListFieldWidget = Obx(() {
      Widget paperTitleBuilder(int index) => TextFieldWidget(title: 'ชื่อบทความ', onChange: (value) => controller.applicationFormRequest.researchExperienceList![index].paperTitle = value);
      Widget paperSourceBuilder(int index) => TextFieldWidget(title: 'แหล่งตีพิมพ์', onChange: (value) => controller.applicationFormRequest.researchExperienceList![index].paperSource = value);
      List<Widget> children = [];
      for (int index = 0; index < researchExperienceListKeyList.value.length; index++) {
        children.add(FormCardWidget(
            key: researchExperienceListKeyList.value[index],
            isSubCard: true,
            title: 'ประสบการณ์ตีพิมพ์บทความวิชาการที่ ${index + 1}',
            childrenList: [
              [paperTitleBuilder(index), paperSourceBuilder(index)],
            ],
            onClose: () {
              researchExperienceListKeyList.value = [...researchExperienceListKeyList.value..removeAt(index)];
              controller.applicationFormRequest.researchExperienceList!.removeAt(index);
            }));
      }
      return Column(children: children);
    });
    final Widget experienceDescriptionFieldWidget = TextAreaFieldWidget(title: 'บรรยายประสบการณ์ด้านวิจัย (หากมี)', onChange: (value) => controller.applicationFormRequest.experienceDescription = value);
    final Widget computerLearningExperienceListFieldWidget = Obx(() {
      Widget languageBuilder(int index) => TextAreaFieldWidget(title: 'รายละเอียด', onChange: (value) => controller.applicationFormRequest.computerLearningExperienceList![index] = value ?? '');
      List<Widget> children = [];
      for (int index = 0; index < computerLearningExperienceListKeyList.value.length; index++) {
        children.add(FormCardWidget(
            key: computerLearningExperienceListKeyList.value[index],
            isSubCard: true,
            title: 'ประสบการณ์การเรียนรู้ด้านคอมพิวเตอร์ที่ ${index + 1}',
            childrenList: [
              [languageBuilder(index)],
            ],
            onClose: () {
              computerLearningExperienceListKeyList.value = [...computerLearningExperienceListKeyList.value..removeAt(index)];
              controller.applicationFormRequest.computerLearningExperienceList!.removeAt(index);
            }));
      }
      return Column(children: children);
    });
    final Widget researchInterestsFieldWidget = TextAreaFieldWidget(title: 'ด้านที่อยากทำ', onChange: (value) => controller.applicationFormRequest.researchInterests = value);
    final Widget proposedResearchMethodologyListFieldWidget = Obx(() {
      Widget languageBuilder(int index) => TextAreaFieldWidget(title: 'รายละเอียด', onChange: (value) => controller.applicationFormRequest.proposedResearchMethodologyList![index] = value ?? '');
      List<Widget> children = [];
      for (int index = 0; index < proposedResearchMethodologyListKeyList.value.length; index++) {
        children.add(FormCardWidget(
            key: proposedResearchMethodologyListKeyList.value[index],
            isSubCard: true,
            title: 'หัวข้อที่ต้องการทำ พร้อมแนวทางการทำที่ ${index + 1}',
            childrenList: [
              [languageBuilder(index)],
            ],
            onClose: () {
              proposedResearchMethodologyListKeyList.value = [...proposedResearchMethodologyListKeyList.value..removeAt(index)];
              controller.applicationFormRequest.proposedResearchMethodologyList!.removeAt(index);
            }));
      }
      return Column(children: children);
    });
    final Widget addApplicationFormButtonWidget = DenseButtonWidget(
        text: 'บันทึกข้อมูล',
        onClick: () async {
          String? errorMessage;
          errorMessage = controller.validateRequest();
          if (errorMessage != null) return await AwesomeDialogWidget.warning(title: 'ข้อมูลไม่ถูกต้อง', detail: errorMessage);
          if (!await controller.sendRequest()) return await AwesomeDialogWidget.failed(detail: controller.api.message);
          await AwesomeDialogWidget.success(title: 'บันทึกข้อมูลสำเร็จ', detail: controller.api.message);
        });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormCardWidget(
          title: 'ข้อมูลพื้นฐาน',
          childrenList: [
            [nameFieldWidget, surnameFieldWidget],
            [studyTypeFieldWidget, studyPlanFieldWidget],
          ],
        ),
        FormCardWidget(
          title: '1. ประสบการณ์เขียนโปรแกรม ได้แก่ ภาษาโปรแกรมที่ใช้ เฟรมเวิร์กที่ใช้ เครื่องมือที่ใช้ สภาพแวดล้อม',
          detail: 'เช่น web, mobile, enterprise app, IoT, robotics เป็นต้น',
          childrenList: [
            [programmingExperienceListFieldWidget],
            [programmingExperienceListButton],
          ],
        ),
        FormCardWidget(
          title: '2. ประสบการณ์การทำงานด้านคอมพิวเตอร์',
          detail: 'เช่น วิเคราะห์ระบบ, ออกแบบระบบ, พัฒนาระบบ, ทดสอบระบบ, จัดการโครงการซอฟต์แวร์, ผู้นำทีมพัฒนา, วิเคราะห์ข้อมูล, ดูแลระบบ เป็นต้น',
          childrenList: [
            [computerExperienceListFieldWidget],
            [computerExperienceListButton],
          ],
        ),
        FormCardWidget(
          title: '3. ประสบการณ์ด้านงานวิจัย',
          childrenList: [
            [hasPublishedPaperFieldWidget],
            [experienceDescriptionFieldWidget],
          ],
          widgetInsertion: {
            1: Obx(() {
              if (!hasPublishedPaper.value) return SizedBoxStyle.none;
              return Column(
                children: [
                  researchExperienceListFieldWidget,
                  researchExperienceListButton,
                ],
              );
            })
          },
        ),
        FormCardWidget(
          title: '4. ประสบการณ์การเรียนรู้ด้านคอมพิวเตอร์ นอกเหนือจากสาขาที่จบมา',
          detail: 'เช่น เรียนรู้ด้วยตัวเองผ่านหลักสูตรออนไลน์ การสอบได้ใบรับรองด้านคอมพิวเตอร์ การฝึกอบรมด้านคอมฯ การแข่งขันด้านคอมฯ เป็นต้น',
          childrenList: [
            [computerLearningExperienceListFieldWidget],
            [computerLearningExperienceListButton],
          ],
        ),
        FormCardWidget(
          title: '5. ด้านที่อยากทำวิทยานิพนธ์/โครงงานมหาบัณฑิต',
          detail: 'เช่น Requirements Engineering, Software Design and Development, Software Testing, Software Measurement, Software Project Management, Software Process Improvement, Formal Verification, User Interface, Software Maintenance เป็นต้น',
          childrenList: [
            [researchInterestsFieldWidget],
            [proposedResearchMethodologyListFieldWidget],
            [proposedResearchMethodologyListButton],
          ],
        ),
        if (otpCardWidget != null) ...[otpCardWidget!, Center(child: addApplicationFormButtonWidget)],
      ],
    );
  }
}
