// 이미지 파일 저장 — 형식 확인(파일 앞부분으로), 크기 읽기, 썸네일 만들기, 같은 파일 중복 방지.
// 저장 위치: <ASSETS_DIR>/u<사용자>/<sha256 앞 2글자>/<sha256>.<확장자>, 썸네일은 같은 곳에 <sha256>.thumb.jpg
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;

import '../../core/context.dart';
import '../../core/db.dart';
import '../../core/http.dart';
import 'assets_repository.dart';

const maxUploadBytes = 20 * 1024 * 1024;
const thumbWidth = 480;

/// 파일 앞부분(매직 넘버)으로 이미지 형식 판단. 이미지가 아니면 null.
(String mime, String ext)? detectImage(Uint8List b) {
  bool at(int i, List<int> sig) => b.length >= i + sig.length && List.generate(sig.length, (k) => b[i + k] == sig[k]).every((x) => x);
  if (at(0, [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A])) return ('image/png', 'png');
  if (at(0, [0xFF, 0xD8, 0xFF])) return ('image/jpeg', 'jpg');
  if (at(0, [0x47, 0x49, 0x46, 0x38])) return ('image/gif', 'gif');
  if (at(0, [0x52, 0x49, 0x46, 0x46]) && at(8, [0x57, 0x45, 0x42, 0x50])) return ('image/webp', 'webp');
  return null;
}

/// 썸네일 JPEG (가로 최대 480px, 투명한 곳은 흰색). 읽을 수 없는 이미지면 null.
Uint8List? makeThumbnail(Uint8List bytes) {
  final decoder = img.findDecoderForData(bytes);
  final image = decoder?.decode(bytes, frame: 0);
  if (image == null) return null;
  final resized = image.width > thumbWidth ? img.copyResize(image, width: thumbWidth, interpolation: img.Interpolation.average) : image;
  final bg = img.Image(width: resized.width, height: resized.height);
  img.fill(bg, color: img.ColorRgb8(255, 255, 255));
  img.compositeImage(bg, resized);
  return img.encodeJpg(bg, quality: 85);
}

class AssetsService {
  final Db db;
  final String dir;
  final AssetsRepository assets;

  AssetsService(AppContext app)
      : db = app.db,
        dir = app.config.assetsDir,
        assets = AssetsRepository(app.db);

  String absolute(String filePath) => p.join(dir, filePath);

  String thumbPath(String filePath) => p.join(dir, '${p.withoutExtension(filePath)}.thumb.jpg');

  /// 이미지 저장 → assets 행. 같은 파일을 또 올리면 기존 행을 돌려준다.
  Future<Row> saveImage(int userId, Uint8List bytes, String originalName) async {
    if (bytes.isEmpty) throw ApiError('빈 파일이에요');
    if (bytes.length > maxUploadBytes) throw ApiError('파일은 20MB까지 올릴 수 있어요', 413);
    final type = detectImage(bytes) ?? (throw ApiError('PNG, JPG, GIF, WEBP 이미지만 올릴 수 있어요', 415));
    final sha = sha256.convert(bytes).toString();

    final existing = assets.findBySha(userId, sha);
    if (existing != null) return existing;
    final deleted = assets.findDeletedBySha(userId, sha);
    if (deleted != null) {
      assets.restore(deleted['id'] as int);
      return assets.get(userId, deleted['id'] as int);
    }

    final filePath = p.posix.join('u$userId', sha.substring(0, 2), '$sha.${type.$2}');
    // 크기 읽기·썸네일은 시간이 걸려서 따로 돌린다
    final (width, height, thumb) = await Isolate.run(() {
      final info = img.findDecoderForData(bytes)?.startDecode(bytes);
      return (info?.width, info?.height, makeThumbnail(bytes));
    });
    final file = File(absolute(filePath));
    await file.parent.create(recursive: true);
    await file.writeAsBytes(bytes, flush: true);
    if (thumb != null) await File(thumbPath(filePath)).writeAsBytes(thumb, flush: true);

    final name = originalName.trim().isEmpty ? 'image.${type.$2}' : originalName.trim();
    final id = assets.create(userId,
        filePath: filePath, originalName: name.length > 200 ? name.substring(0, 200) : name,
        mimeType: type.$1, byteSize: bytes.length, width: width, height: height, sha256: sha);
    return assets.get(userId, id);
  }
}
