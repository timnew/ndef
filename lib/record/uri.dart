import 'dart:convert';
import 'dart:typed_data';

import 'wellknown.dart';

class UriRecord extends WellKnownRecord {
  static List<String> prefixMap = [
    "",
    "http://www.",
    "https://www.",
    "http://",
    "https://",
    "tel:",
    "mailto:",
    "ftp://anonymous:anonymous@",
    "ftp://ftp.",
    "ftps://",
    "sftp://",
    "smb://",
    "nfs://",
    "ftp://",
    "dav://",
    "news:",
    "telnet://",
    "imap:",
    "rtsp://",
    "urn:",
    "pop:",
    "sip:",
    "sips:",
    "tftp:",
    "btspp://",
    "btl2cap://",
    "btgoep://",
    "tcpobex://",
    "irdaobex://",
    "file://",
    "urn:epc:id:",
    "urn:epc:tag:",
    "urn:epc:pat:",
    "urn:epc:raw:",
    "urn:epc:",
    "urn:nfc:",
  ];

  static const String classType = "U";

  @override
  String get decodedType {
    return UriRecord.classType;
  }

  static const int classMinPayloadLength = 1;

  int get minPayloadLength {
    return classMinPayloadLength;
  }

  @override
  String toString() {
    var str = "UriRecord: ";
    str += basicInfoString;
    str += "uri=$uriString";
    return str;
  }

  String _prefix, content;

  UriRecord({String prefix, String content}) {
    if (prefix != null) {
      this.prefix = prefix;
    }
    this.content = content;
  }

  UriRecord.fromUriString(String uriString) {
    this.uriString = uriString;
  }

  UriRecord.fromUri(Uri uri) {
    this.uriString = uri.toString();
  }

  String get prefix {
    return _prefix;
  }

  set prefix(String prefix) {
    if (!prefixMap.contains(prefix)) {
      throw "URI Prefix $prefix is not supported";
    }
    _prefix = prefix;
  }

  String get iriString {
    return this.prefix + this.content;
  }

  set iriString(String uriString) {
    for (int i = 1; i < prefixMap.length; i++) {
      if (uriString.startsWith(prefixMap[i])) {
        this._prefix = prefixMap[i];
        this.content = uriString.substring(prefix.length);
        return;
      }
    }
    this._prefix = "";
    this.content = uriString;
  }

  String get uriString {
    return Uri.parse(this.prefix + this.content).toString();
  }

  set uriString(String uriString) {
    this.iriString = uriString;
  }

  Uri get uri {
    return Uri.parse(iriString);
  }

  set uri(Uri uri) {
    this.iriString = uri.toString();
  }

  Uint8List get payload {
    for (int i = 0; i < prefixMap.length; i++) {
      if (prefixMap[i] == prefix) {
        return new Uint8List.fromList([i] + utf8.encode(content));
      }
    }
    throw "Uri prefix not recognized";
  }

  set payload(Uint8List payload) {
    int prefixIndex = payload[0];
    if (prefixIndex < prefixMap.length) {
      prefix = prefixMap[prefixIndex];
    } else {
      //More identifier codes are reserved for future use
      prefix = "";
    }
    content = utf8.decode(payload.sublist(1));
  }
}
