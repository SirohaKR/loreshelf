// 이미지 파일 고르기 (Windows·Android·웹 공통) — 고르지 않으면 null
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';

typedef PickedImage = ({Uint8List bytes, String name});

/// 테스트에서 진짜 파일 창 대신 바꿔 끼울 수 있게 변수로 둔다
Future<PickedImage?> Function() pickImage = () async {
  final files = await FilePicker.pickFiles(type: FileType.image);
  if (files.isEmpty) return null;
  return (bytes: await files.first.readAsBytes(), name: files.first.name);
};
