import 'package:mongo_dart/mongo_dart.dart';
import 'package:server_dart/private/setting/mongodb.dart';
import 'package:share_dart/object/key/user_key.dart';

class UserModel {
  static Future<ObjectId?> insertOne(Mongodb mongodb, {required Map<String, dynamic> map}) async {
    final WriteResult writeResult = await mongodb.userCollection.insertOne(map);
    if (!writeResult.isSuccess || writeResult.nInserted != 1 || writeResult.id is! ObjectId) return null;
    return writeResult.id;
  }

  static Future<Map<String, dynamic>?> findOneByEmail(Mongodb mongodb, {required String email}) async {
    return await mongodb.userCollection.findOne(where.eq(UserKey.email, email));
  }

  static Future<bool> removeOne(Mongodb mongodb, {required ObjectId id}) async {
    final WriteResult writeResult = await mongodb.userCollection.deleteOne(where.id(id));
    if (!writeResult.isSuccess || writeResult.nRemoved != 1) return false;
    return true;
  }
}
