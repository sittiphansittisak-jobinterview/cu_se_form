import 'package:mongo_dart/mongo_dart.dart';
import 'package:server_dart/private/setting/mongodb.dart';

class ApplicationFormModel {
  static Future<ObjectId?> insertOne(Mongodb mongodb, {required Map<String, dynamic> map}) async {
    final WriteResult writeResult = await mongodb.applicationFormCollection.insertOne(map);
    if (!writeResult.isSuccess || writeResult.nInserted != 1 || writeResult.id is! ObjectId) return null;
    return writeResult.id;
  }

  static Future<Map<String, dynamic>?> findOneByEmail(Mongodb mongodb, {required String email}) async {
    return await mongodb.userDbCollection.findOne(where.eq(UserKey.ktId, username).fields([
      UserKey.ktId,
      UserKey.companyId,
      UserKey.status,
      UserKey.token,
      UserKey.role,
      UserKey.profile,
    ]));
  }
}
