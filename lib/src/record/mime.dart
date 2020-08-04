import 'dart:typed_data';

import '../record.dart';
import '../byteStream.dart';

class MimeRecord extends Record {
  static const TypeNameFormat classTnf = TypeNameFormat.media;

  TypeNameFormat get tnf {
    return classTnf;
  }

  MimeRecord({String decodedType, Uint8List payload, Uint8List id})
      : super(id: id, payload: payload) {
    if (decodedType != null) {
      this.decodedType = decodedType;
    }
  }

  @override
  String toString() {
    var str = "MimeRecord: ";
    str += basicInfoString;
    str += "type=$decodedType ";
    str += "payload=${ByteStream.list2hexString(payload)}";
    return str;
  }
}
