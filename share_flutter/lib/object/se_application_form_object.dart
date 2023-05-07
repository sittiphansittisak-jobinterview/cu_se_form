import 'package:mongo_dart/mongo_dart.dart';
import 'package:share_flutter/object/abstract/object_converter_abstract.dart';
import 'package:share_flutter/object/key/se_application_form_key.dart';
import 'package:share_flutter/object/programming_experience_object.dart';
import 'package:share_flutter/object/research_experience_object.dart';

class SeApplicationFormObject extends ObjectConverterAbstract {
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

  SeApplicationFormObject({
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
        SeApplicationFormKey.id: id?.$oid,
        SeApplicationFormKey.userId: userId?.$oid,
        SeApplicationFormKey.name: name,
        SeApplicationFormKey.surname: surname,
        SeApplicationFormKey.studyType: studyType,
        SeApplicationFormKey.studyPlan: studyPlan,
        SeApplicationFormKey.programmingExperienceList: programmingExperienceList?.map((e) => (e..toMap()).map).whereType<Map<String, dynamic>>().toList(),
        SeApplicationFormKey.computerExperienceList: computerExperienceList,
        SeApplicationFormKey.hasPublishedPaper: hasPublishedPaper,
        SeApplicationFormKey.researchExperienceList: researchExperienceList?.map((e) => (e..toMap()).map).whereType<Map<String, dynamic>>().toList(),
        SeApplicationFormKey.experienceDescription: experienceDescription,
        SeApplicationFormKey.computerLearningExperienceList: computerLearningExperienceList,
        SeApplicationFormKey.researchInterests: researchInterests,
        SeApplicationFormKey.proposedResearchMethodologyList: proposedResearchMethodologyList,
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
      id = map![SeApplicationFormKey.id] == null ? null : ObjectId.parse(map![SeApplicationFormKey.id]);
      userId = map![SeApplicationFormKey.userId] == null ? null : ObjectId.parse(map![SeApplicationFormKey.userId]);
      name = map![SeApplicationFormKey.name];
      surname = map![SeApplicationFormKey.surname];
      studyType = map![SeApplicationFormKey.studyType];
      studyPlan = map![SeApplicationFormKey.studyPlan];
      programmingExperienceList = (map![SeApplicationFormKey.programmingExperienceList] as List?)
          ?.map((e) => ProgrammingExperienceObject()
            ..map = e
            ..toObject())
          .toList();
      computerExperienceList = map![SeApplicationFormKey.computerExperienceList]?.whereType<String?>().toList();
      hasPublishedPaper = map![SeApplicationFormKey.hasPublishedPaper];
      researchExperienceList = (map![SeApplicationFormKey.researchExperienceList] as List?)
          ?.map((e) => ResearchExperienceObject()
            ..map = e
            ..toObject())
          .toList();
      experienceDescription = map![SeApplicationFormKey.experienceDescription];
      computerLearningExperienceList = map![SeApplicationFormKey.computerLearningExperienceList]?.whereType<String>().toList();
      researchInterests = map![SeApplicationFormKey.researchInterests];
      proposedResearchMethodologyList = map![SeApplicationFormKey.proposedResearchMethodologyList]?.whereType<String>().toList();
      return true;
    } catch (_) {
      return false;
    }
  }
}
