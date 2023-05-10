import 'package:mongo_dart/mongo_dart.dart';
import 'package:share_dart/object/abstract/object_converter_abstract.dart';
import 'package:share_dart/object/key/otp_key.dart';
import 'dart:math';

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

  bool get isOtpRefCorrect {
    if (otpRef == null || otpRef!.length != 9) return false;
    final List<String> otpRefParts = otpRef!.split('-');
    if (otpRefParts.length != 2 || otpRefParts[0].length != 4 || otpRefParts[1].length != 4) return false;
    final RegExp upperCaseRegex = RegExp(r'^[A-Z]{4}$');
    final RegExp numberRegex = RegExp(r'^\d{4}$');
    return upperCaseRegex.hasMatch(otpRefParts[0]) && numberRegex.hasMatch(otpRefParts[1]);
  }

  bool get isOtpValueCorrect {
    final RegExp regex = RegExp(r'^\d{6}$');
    return regex.hasMatch(otpValue ?? '');
  }

  void generateOtpRef() {
    final random = Random();
    final upperCaseLetterList = List.generate(4, (index) => random.nextInt(26) + 65); // generates uppercase letter code points
    final numberCaseLetterList = List.generate(4, (index) => random.nextInt(10) + 48); // generates ASCII code points for digits 0-9
    otpRef = '${String.fromCharCodes(upperCaseLetterList)}-${String.fromCharCodes(numberCaseLetterList)}';
  }

  void generateOtpValue() {
    final random = Random();
    final numberCaseLetterList = List.generate(6, (index) => random.nextInt(10) + 48); // generates ASCII code points for digits 0-9
    otpValue = String.fromCharCodes(numberCaseLetterList);
  }

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
        OtpKey.id: id,
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
      id = map![OtpKey.id] is String ? ObjectId.parse(map![OtpKey.id]) : map![OtpKey.id];
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
