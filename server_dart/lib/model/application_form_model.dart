import 'package:mongo_dart/mongo_dart.dart';
import 'package:server_dart/private/setting/mongodb.dart';
import 'package:share_flutter/object/key/application_form_key.dart';

class ApplicationFormModel {
/*  static Future<ObjectId?> insertOne(Mongodb mongodb, {required Map<String, dynamic> map}) async {
    final WriteResult writeResult = await mongodb.applicationFormCollection.insertOne(map);
    if (!writeResult.isSuccess || writeResult.nInserted != 1 || writeResult.id is! ObjectId) return null;
    return writeResult.id;
  }*/

  static Future<Map<String, dynamic>?> findOneByUserId(Mongodb mongodb, {required ObjectId userId}) async {
    return await mongodb.applicationFormCollection.findOne(where.eq(ApplicationFormKey.userId, userId));
  }

/*  static Future<bool> removeOne(Mongodb mongodb, {required ObjectId id}) async {
    final WriteResult writeResult = await mongodb.applicationFormCollection.deleteOne(where.id(id));
    if (!writeResult.isSuccess || writeResult.nRemoved != 1) return false;
    return true;
  }*/
}
