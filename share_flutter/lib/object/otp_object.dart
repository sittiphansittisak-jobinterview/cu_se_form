import 'package:mongo_dart/mongo_dart.dart';
import 'package:share_flutter/object/abstract/object_converter_abstract.dart';
import 'package:share_flutter/object/key/otp_key.dart';

class OtpObject extends ObjectConverterAbstract {
  ObjectId? id;
  DateTime? createAt;
  DateTime? expireAt;
  String? email;
  bool? isUsed;
  String? otpRef;
  String? otpValue;
  String? note;

  bool get isExpired => (expireAt?.compareTo(DateTime.now().toUtc()) ?? 0) <= 0;

  OtpObject({
    this.id,
    this.createAt,
    this.expireAt,
    this.email,
    this.isUsed,
    this.otpRef,
    this.otpValue,
    this.note,
  });

  @override
  bool toMap() {
    map = null;
    try {
      map = {
        OtpKey.id: id?.$oid,
        OtpKey.createAt: createAt,
        OtpKey.expireAt: expireAt,
        OtpKey.email: email,
        OtpKey.isUsed: isUsed,
        OtpKey.otpRef: otpRef,
        OtpKey.otpValue: otpValue,
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
      id = map![OtpKey.id] == null ? null : ObjectId.parse(map![OtpKey.id]);
      createAt = map![OtpKey.createAt] == null ? null : DateTime.tryParse(map![OtpKey.createAt]);
      expireAt = map![OtpKey.expireAt] == null ? null : DateTime.tryParse(map![OtpKey.expireAt]);
      email = map![OtpKey.email];
      isUsed = map![OtpKey.isUsed];
      otpRef = map![OtpKey.otpRef];
      otpValue = map![OtpKey.otpValue];
      return true;
    } catch (_) {
      return false;
    }
  }
}
