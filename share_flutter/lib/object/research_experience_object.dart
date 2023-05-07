import 'package:mongo_dart/mongo_dart.dart';
import 'package:share_flutter/object/abstract/object_converter_abstract.dart';
import 'package:share_flutter/object/key/research_experience_key.dart';

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
  bool toMap() {
    map = null;
    try {
      map = {
        ResearchExperienceKey.id: id?.$oid,
        ResearchExperienceKey.paperTitle: paperTitle,
        ResearchExperienceKey.paperSource: paperSource,
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
      id = map![ResearchExperienceKey.id] == null ? null : ObjectId.parse(map![ResearchExperienceKey.id]);
      paperTitle = map![ResearchExperienceKey.paperTitle];
      paperSource = map![ResearchExperienceKey.paperSource];
      return true;
    } catch (_) {
      return false;
    }
  }
}
