import 'package:mongo_dart/mongo_dart.dart';
import 'package:server_dart/private/setting/mongodb.dart';
import 'package:share_flutter/object/key/otp_key.dart';

class OtpModel {
  static Future<int> countBeforeExpire(Mongodb mongodb, {required String email, required DateTime expireAt}) async {
    return await mongodb.otpCollection.count(where.eq(OtpKey.email, email).gt(OtpKey.expireAt, expireAt));
  }

  static Future<ObjectId?> insertOne(Mongodb mongodb, {required Map<String, dynamic> map}) async {
    final WriteResult writeResult = await mongodb.otpCollection.insertOne(map);
    if (!writeResult.isSuccess || writeResult.nInserted != 1 || writeResult.id is! ObjectId) return null;
    return writeResult.id;
  }

  static Future<bool> removeOne(Mongodb mongodb, {required ObjectId id}) async {
    final WriteResult writeResult = await mongodb.otpCollection.deleteOne(where.id(id));
    if (!writeResult.isSuccess || writeResult.nRemoved != 1) return false;
    return true;
  }
}
