import 'package:mongo_dart/mongo_dart.dart';
import 'package:share_dart/object/abstract/object_converter_abstract.dart';
import 'package:share_dart/object/key/user_key.dart';

class UserObject extends ObjectConverterAbstract {
  ObjectId? id;
  DateTime? createAt;
  String? email;

  UserObject({
    this.id,
    this.createAt,
    this.email,
  });

  @override
  bool toMap() {
    map = null;
    try {
      map = {
        UserKey.id: id,
        UserKey.createAt: createAt,
        UserKey.email: email,
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
      id = map![UserKey.id] is String ? ObjectId.parse(map![UserKey.id]) : map![UserKey.id];
      createAt = map![UserKey.createAt] == null ? null : DateTime.tryParse(map![UserKey.createAt]);
      email = map![UserKey.email];
      return true;
    } catch (_) {
      return false;
    }
  }
}
