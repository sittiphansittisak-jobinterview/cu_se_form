import 'package:mongo_dart/mongo_dart.dart';
import 'package:server_dart/private/setting/mongodb.dart';
import 'package:share_flutter/object/key/application_form_key.dart';

class ApplicationFormModel {
  static Future<bool> replaceOneByUserId(Mongodb mongodb, {required ObjectId userId, required Map<String, dynamic> map}) async {
    final WriteResult writeResult = await mongodb.applicationFormCollection.replaceOne(where.eq(ApplicationFormKey.userId, userId), map, upsert: true);
    if (!writeResult.isSuccess || writeResult.nMatched != 1) return false;
    return true;
  }

  static Future<Map<String, dynamic>?> findOneByUserId(Mongodb mongodb, {required ObjectId userId}) async {
    return await mongodb.applicationFormCollection.findOne(where.eq(ApplicationFormKey.userId, userId));
  }
}
