import 'package:mongo_dart/mongo_dart.dart';
import 'package:server_dart/private/setting/mongodb.dart';
import 'package:share_dart/object/key/otp_key.dart';

class OtpModel {
  static Future<int> countBeforeBeforeCreate(Mongodb mongodb, {required String email, required DateTime createAt}) async {
    return await mongodb.otpCollection.count(where.eq(OtpKey.email, email).gt(OtpKey.createAt, createAt));
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

  static Future<bool> updateToUseOtp(Mongodb mongodb, {required String note, required String email, required String otpRef, required String otpValue, required DateTime expireAt}) async {
    final WriteResult writeResult = await mongodb.otpCollection.updateOne(where.eq(OtpKey.email, email).eq(OtpKey.otpRef, otpRef).eq(OtpKey.otpValue, otpValue).eq(OtpKey.isUsed, false).gt(OtpKey.expireAt, expireAt), modify.set(OtpKey.isUsed, true).set(OtpKey.note, note));
    return writeResult.isSuccess && writeResult.nModified == 1;
  }
}
