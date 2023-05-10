import 'package:mongo_dart/mongo_dart.dart';
import 'package:share_dart/object/abstract/object_converter_abstract.dart';
import 'package:share_dart/object/key/application_form_key.dart';
import 'package:share_dart/object/programming_experience_object.dart';
import 'package:share_dart/object/research_experience_object.dart';

class ApplicationFormObject extends ObjectConverterAbstract {
  ObjectId? id;
  ObjectId? userId;
  String? name;
  String? surname;
  String? studyType;
  String? studyPlan;
  List<ProgrammingExperienceObject>? programmingExperienceList;
  List<String>? computerExperienceList;
  bool? hasPublishedPaper;
  List<ResearchExperienceObject>? researchExperienceList;
  String? experienceDescription;
  List<String>? computerLearningExperienceList;
  String? researchInterests;
  List<String>? proposedResearchMethodologyList;

  ApplicationFormObject({
    this.id,
    this.userId,
    this.name,
    this.surname,
    this.studyType,
    this.studyPlan,
    this.programmingExperienceList,
    this.computerExperienceList,
    this.hasPublishedPaper,
    this.researchExperienceList,
    this.experienceDescription,
    this.computerLearningExperienceList,
    this.researchInterests,
    this.proposedResearchMethodologyList,
  });

  @override
  bool toMap() {
    map = null;
    try {
      map = {
        ApplicationFormKey.id: id,
        ApplicationFormKey.userId: userId,
        ApplicationFormKey.name: name,
        ApplicationFormKey.surname: surname,
        ApplicationFormKey.studyType: studyType,
        ApplicationFormKey.studyPlan: studyPlan,
        ApplicationFormKey.programmingExperienceList: programmingExperienceList?.map((e) => (e..toMap()).map).whereType<Map<String, dynamic>>().toList(),
        ApplicationFormKey.computerExperienceList: computerExperienceList,
        ApplicationFormKey.hasPublishedPaper: hasPublishedPaper,
        ApplicationFormKey.researchExperienceList: researchExperienceList?.map((e) => (e..toMap()).map).whereType<Map<String, dynamic>>().toList(),
        ApplicationFormKey.experienceDescription: experienceDescription,
        ApplicationFormKey.computerLearningExperienceList: computerLearningExperienceList,
        ApplicationFormKey.researchInterests: researchInterests,
        ApplicationFormKey.proposedResearchMethodologyList: proposedResearchMethodologyList,
      };
      map!.removeWhere((key, value) => value == null);
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  bool toObject() {
    if (map == null) return false;
    try {
      id = map![ApplicationFormKey.id] is String ? ObjectId.parse(map![ApplicationFormKey.id]) : map![ApplicationFormKey.id];
      userId = map![ApplicationFormKey.userId] is String ? ObjectId.parse(map![ApplicationFormKey.userId]) : map![ApplicationFormKey.userId];
      name = map![ApplicationFormKey.name];
      surname = map![ApplicationFormKey.surname];
      studyType = map![ApplicationFormKey.studyType];
      studyPlan = map![ApplicationFormKey.studyPlan];
      programmingExperienceList = (map![ApplicationFormKey.programmingExperienceList] as List?)
          ?.map((e) => ProgrammingExperienceObject()
            ..map = e
            ..toObject())
          .toList();
      computerExperienceList = map![ApplicationFormKey.computerExperienceList]?.whereType<String>().toList();
      hasPublishedPaper = map![ApplicationFormKey.hasPublishedPaper];
      researchExperienceList = (map![ApplicationFormKey.researchExperienceList] as List?)
          ?.map((e) => ResearchExperienceObject()
            ..map = e
            ..toObject())
          .toList();
      experienceDescription = map![ApplicationFormKey.experienceDescription];
      computerLearningExperienceList = map![ApplicationFormKey.computerLearningExperienceList]?.whereType<String>().toList();
      researchInterests = map![ApplicationFormKey.researchInterests];
      proposedResearchMethodologyList = map![ApplicationFormKey.proposedResearchMethodologyList]?.whereType<String>().toList();
      return true;
    } catch (_) {
      return false;
    }
  }
}
