import 'package:client_flutter/private/style/sized_box_style.dart';
import 'package:client_flutter/private/widget/button/widget_builder_button_widget.dart';
import 'package:client_flutter/private/widget/card/form_card_widget.dart';
import 'package:client_flutter/private/widget/field/dropdown_search_field_widget.dart';
import 'package:client_flutter/private/widget/field/switch_field_widget.dart';
import 'package:client_flutter/private/widget/field/text_area_field_widget.dart';
import 'package:client_flutter/private/widget/field/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_flutter/object/application_form_object.dart';
import 'package:share_flutter/object/programming_experience_object.dart';
import 'package:share_flutter/object/research_experience_object.dart';
import 'package:share_flutter/setting/study_plan.dart';
import 'package:share_flutter/setting/study_type.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class ApplicationFormView extends StatelessWidget {
  final bool isWrite;
  final ApplicationFormObject applicationForm;

  const ApplicationFormView({Key? key, required this.isWrite, required this.applicationForm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    applicationForm.programmingExperienceList ??= [];
    applicationForm.computerExperienceList ??= [];
    applicationForm.hasPublishedPaper ??= false;
    applicationForm.researchExperienceList ??= [];
    applicationForm.computerLearningExperienceList ??= [];
    applicationForm.proposedResearchMethodologyList ??= [];

    final Rx<List<Key>> programmingExperienceListKeyList = Rx(applicationForm.programmingExperienceList!.map((e) => Key(mongo.ObjectId().$oid)).toList());
    final Rx<List<Key>> computerExperienceListKeyList = Rx(applicationForm.computerExperienceList!.map((e) => Key(mongo.ObjectId().$oid)).toList());
    final Rx<bool> hasPublishedPaper = Rx(applicationForm.hasPublishedPaper!);
    final Rx<List<Key>> researchExperienceListKeyList = Rx(applicationForm.researchExperienceList!.map((e) => Key(mongo.ObjectId().$oid)).toList());
    final Rx<List<Key>> computerLearningExperienceListKeyList = Rx(applicationForm.computerLearningExperienceList!.map((e) => Key(mongo.ObjectId().$oid)).toList());
    final Rx<List<Key>> proposedResearchMethodologyListKeyList = Rx(applicationForm.proposedResearchMethodologyList!.map((e) => Key(mongo.ObjectId().$oid)).toList());

    final Widget programmingExperienceListButton = WidgetBuilderButtonWidget(text: '+ เพิ่มข้อมูลประสบการณ์เขียนโปรแกรม', keyList: programmingExperienceListKeyList, itemList: applicationForm.programmingExperienceList!, item: () => ProgrammingExperienceObject());
    final Widget computerExperienceListButton = WidgetBuilderButtonWidget(text: '+ ประสบการณ์การทำงานด้านคอมพิวเตอร์', keyList: computerExperienceListKeyList, itemList: applicationForm.computerExperienceList!, item: () => '');
    final Widget researchExperienceListButton = WidgetBuilderButtonWidget(text: '+ รายชื่อบทความและแหล่งตีพิมพ์', keyList: researchExperienceListKeyList, itemList: applicationForm.researchExperienceList!, item: () => ResearchExperienceObject());
    final Widget computerLearningExperienceListButton = WidgetBuilderButtonWidget(text: '+ ประสบการณ์การเรียนรู้ด้านคอมพิวเตอร์', keyList: computerLearningExperienceListKeyList, itemList: applicationForm.computerLearningExperienceList!, item: () => '');
    final Widget proposedResearchMethodologyListButton = WidgetBuilderButtonWidget(text: '+ หัวข้อที่ต้องการทำ พร้อมแนวทางการทำ', keyList: proposedResearchMethodologyListKeyList, itemList: applicationForm.proposedResearchMethodologyList!, item: () => '');
    final Widget nameFieldWidget = TextFieldWidget(title: 'ชื่อ', initialValue: applicationForm.name, onChange: !isWrite ? null : (value) => applicationForm.name = value);
    final Widget surnameFieldWidget = TextFieldWidget(title: 'นามสกุล', initialValue: applicationForm.surname, onChange: !isWrite ? null : (value) => applicationForm.surname = value);
    final Widget studyTypeFieldWidget = DropdownSearchField<String>(title: 'ภาคเรียน', item: StudyType.list, initialValue: applicationForm.studyType, getText: (value) => value, onChange: !isWrite ? null : ({value, String? text}) => applicationForm.studyType = value);
    final Widget studyPlanFieldWidget = DropdownSearchField<String>(title: 'แผนการเรียน', item: StudyPlan.list, initialValue: applicationForm.studyPlan, getText: (value) => value, onChange: !isWrite ? null : ({value, String? text}) => applicationForm.studyPlan = value);
    final Widget programmingExperienceListFieldWidget = Obx(() {
      Widget languageBuilder(int index) => TextFieldWidget(title: 'ภาษา', initialValue: applicationForm.programmingExperienceList![index].language, onChange: !isWrite ? null : (value) => applicationForm.programmingExperienceList![index].language = value);
      Widget frameworkBuilder(int index) => TextFieldWidget(title: 'เฟรมเวิร์ก', initialValue: applicationForm.programmingExperienceList![index].framework, onChange: !isWrite ? null : (value) => applicationForm.programmingExperienceList![index].framework = value);
      Widget toolBuilder(int index) => TextFieldWidget(title: 'เครื่องมือ', initialValue: applicationForm.programmingExperienceList![index].tool, onChange: !isWrite ? null : (value) => applicationForm.programmingExperienceList![index].tool = value);
      Widget environmentBuilder(int index) => TextFieldWidget(title: 'สภาพแวดล้อม', initialValue: applicationForm.programmingExperienceList![index].environment, onChange: !isWrite ? null : (value) => applicationForm.programmingExperienceList![index].environment = value);
      Widget durationBuilder(int index) => TextFieldWidget(title: 'ระยะเวลา', initialValue: applicationForm.programmingExperienceList![index].duration, onChange: !isWrite ? null : (value) => applicationForm.programmingExperienceList![index].duration = value);
      Widget mostLinesOfCodeBuilder(int index) => TextFieldWidget(title: 'จำนวน Lines of code มากที่สุดที่เคยเขียน', initialValue: applicationForm.programmingExperienceList![index].mostLinesOfCode, onChange: !isWrite ? null : (value) => applicationForm.programmingExperienceList![index].mostLinesOfCode = value);
      Widget descriptionBuilder(int index) => TextAreaFieldWidget(title: 'คำอธิบายของงานที่ทำ', initialValue: applicationForm.programmingExperienceList![index].description, onChange: !isWrite ? null : (value) => applicationForm.programmingExperienceList![index].description = value);
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
              applicationForm.programmingExperienceList!.removeAt(index);
            }));
      }
      return Column(children: children);
    });
    final Widget computerExperienceListFieldWidget = Obx(() {
      Widget languageBuilder(int index) => TextAreaFieldWidget(title: 'รายละเอียด', initialValue: applicationForm.computerExperienceList![index], onChange: !isWrite ? null : (value) => applicationForm.computerExperienceList![index] = value ?? '');
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
              applicationForm.computerExperienceList!.removeAt(index);
            }));
      }
      return Column(children: children);
    });
    final Widget hasPublishedPaperFieldWidget = SwitchFieldWidget(
        title: 'ไม่เคยตีพิมพ์บทความวิชาการ',
        titleOn: 'เคยตีพิมพ์บทความวิชาการ',
        initialValue: applicationForm.hasPublishedPaper,
        onChange: !isWrite
            ? null
            : (value) {
                hasPublishedPaper.value = applicationForm.hasPublishedPaper = value ?? false;
                applicationForm.researchExperienceList!.removeWhere((element) => true);
                researchExperienceListKeyList.value = [];
              });
    final Widget researchExperienceListFieldWidget = Obx(() {
      Widget paperTitleBuilder(int index) => TextFieldWidget(title: 'ชื่อบทความ', initialValue: applicationForm.researchExperienceList![index].paperTitle, onChange: !isWrite ? null : (value) => applicationForm.researchExperienceList![index].paperTitle = value);
      Widget paperSourceBuilder(int index) => TextFieldWidget(title: 'แหล่งตีพิมพ์', initialValue: applicationForm.researchExperienceList![index].paperSource, onChange: !isWrite ? null : (value) => applicationForm.researchExperienceList![index].paperSource = value);
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
              applicationForm.researchExperienceList!.removeAt(index);
            }));
      }
      return Column(children: children);
    });
    final Widget experienceDescriptionFieldWidget = TextAreaFieldWidget(title: 'บรรยายประสบการณ์ด้านวิจัย (หากมี)', initialValue: applicationForm.experienceDescription, onChange: !isWrite ? null : (value) => applicationForm.experienceDescription = value);
    final Widget computerLearningExperienceListFieldWidget = Obx(() {
      Widget languageBuilder(int index) => TextAreaFieldWidget(title: 'รายละเอียด', initialValue: applicationForm.computerLearningExperienceList![index], onChange: !isWrite ? null : (value) => applicationForm.computerLearningExperienceList![index] = value ?? '');
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
              applicationForm.computerLearningExperienceList!.removeAt(index);
            }));
      }
      return Column(children: children);
    });
    final Widget researchInterestsFieldWidget = TextAreaFieldWidget(title: 'ด้านที่อยากทำ', initialValue: applicationForm.researchInterests, onChange: !isWrite ? null : (value) => applicationForm.researchInterests = value);
    final Widget proposedResearchMethodologyListFieldWidget = Obx(() {
      Widget languageBuilder(int index) => TextAreaFieldWidget(title: 'รายละเอียด', initialValue: applicationForm.proposedResearchMethodologyList![index], onChange: !isWrite ? null : (value) => applicationForm.proposedResearchMethodologyList![index] = value ?? '');
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
              applicationForm.proposedResearchMethodologyList!.removeAt(index);
            }));
      }
      return Column(children: children);
    });

    return Column(
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
            if (isWrite) [programmingExperienceListButton],
          ],
        ),
        FormCardWidget(
          title: '2. ประสบการณ์การทำงานด้านคอมพิวเตอร์',
          detail: 'เช่น วิเคราะห์ระบบ, ออกแบบระบบ, พัฒนาระบบ, ทดสอบระบบ, จัดการโครงการซอฟต์แวร์, ผู้นำทีมพัฒนา, วิเคราะห์ข้อมูล, ดูแลระบบ เป็นต้น',
          childrenList: [
            [computerExperienceListFieldWidget],
            if (isWrite) [computerExperienceListButton],
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
                  if (isWrite) researchExperienceListButton,
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
            if (isWrite) [computerLearningExperienceListButton],
          ],
        ),
        FormCardWidget(
          title: '5. ด้านที่อยากทำวิทยานิพนธ์/โครงงานมหาบัณฑิต',
          detail: 'เช่น Requirements Engineering, Software Design and Development, Software Testing, Software Measurement, Software Project Management, Software Process Improvement, Formal Verification, User Interface, Software Maintenance เป็นต้น',
          childrenList: [
            [researchInterestsFieldWidget],
            [proposedResearchMethodologyListFieldWidget],
            if (isWrite) [proposedResearchMethodologyListButton],
          ],
        ),
      ],
    );
  }
}
