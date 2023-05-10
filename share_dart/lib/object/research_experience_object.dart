import 'package:mongo_dart/mongo_dart.dart';
import 'package:share_dart/object/abstract/object_converter_abstract.dart';
import 'package:share_dart/object/key/research_experience_key.dart';

class ResearchExperienceObject extends ObjectConverterAbstract {
  ObjectId? id;
  String? paperTitle;
  String? paperSource;

  ResearchExperienceObject({
    this.id,
    this.paperTitle,
    this.paperSource,
  });

  @override
  void toMap() {
    map = null;
    map = {
      ResearchExperienceKey.id: id,
      ResearchExperienceKey.paperTitle: paperTitle,
      ResearchExperienceKey.paperSource: paperSource,
    };
    map!.removeWhere((key, value) => value == null);
  }

  @override
  bool toObject() {
    if (map == null) return false;
    try {
      id = map![ResearchExperienceKey.id] is String ? ObjectId.parse(map![ResearchExperienceKey.id]) : map![ResearchExperienceKey.id];
      paperTitle = map![ResearchExperienceKey.paperTitle];
      paperSource = map![ResearchExperienceKey.paperSource];
      return true;
    } catch (_) {
      return false;
    }
  }
}
