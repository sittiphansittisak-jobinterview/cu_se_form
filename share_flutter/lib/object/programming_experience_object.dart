import 'package:mongo_dart/mongo_dart.dart';
import 'package:share_flutter/object/abstract/object_converter_abstract.dart';
import 'package:share_flutter/object/key/programming_experience_key.dart';

class ProgrammingExperienceObject extends ObjectConverterAbstract {
  ObjectId? id;
  String? language;
  String? framework;
  String? tool;
  String? environment;
  String? duration;
  String? mostLinesOfCode;
  String? description;

  ProgrammingExperienceObject({
    this.id,
    this.language,
    this.framework,
    this.tool,
    this.environment,
    this.duration,
    this.mostLinesOfCode,
    this.description,
  });

  @override
  bool toMap() {
    map = null;
    try {
      map = {
        ProgrammingExperienceKey.id: id,
        ProgrammingExperienceKey.language: language,
        ProgrammingExperienceKey.framework: framework,
        ProgrammingExperienceKey.tool: tool,
        ProgrammingExperienceKey.environment: environment,
        ProgrammingExperienceKey.duration: duration,
        ProgrammingExperienceKey.mostLinesOfCode: mostLinesOfCode,
        ProgrammingExperienceKey.description: description,
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
      id = map![ProgrammingExperienceKey.id] is String ? ObjectId.parse(map![ProgrammingExperienceKey.id]) : map![ProgrammingExperienceKey.id];
      language = map![ProgrammingExperienceKey.language];
      framework = map![ProgrammingExperienceKey.framework];
      tool = map![ProgrammingExperienceKey.tool];
      environment = map![ProgrammingExperienceKey.environment];
      duration = map![ProgrammingExperienceKey.duration];
      mostLinesOfCode = map![ProgrammingExperienceKey.mostLinesOfCode];
      description = map![ProgrammingExperienceKey.description];
      return true;
    } catch (_) {
      return false;
    }
  }
}
