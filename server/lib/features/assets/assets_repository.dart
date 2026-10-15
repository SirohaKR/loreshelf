// 업로드한 파일 DB (assets). 실제 파일은 assets_service.dart 가 디스크에 저장한다.
import '../../core/db.dart';
import '../../core/http.dart';

class AssetsRepository {
  final Db db;
  AssetsRepository(this.db);

  Row get(int userId, int id) =>
      db.one('SELECT * FROM assets WHERE id = ? AND user_id = ? AND deleted_at IS NULL', [id, userId]) ??
      (throw ApiError('파일을 찾을 수 없어요', 404));

  /// 같은 내용의 파일을 이미 올렸으면 그 행.
  Row? findBySha(int userId, String sha256) =>
      db.one('SELECT * FROM assets WHERE user_id = ? AND sha256 = ? AND deleted_at IS NULL', [userId, sha256]);

  int create(int userId, {required String filePath, required String originalName, required String mimeType,
      required int byteSize, int? width, int? height, required String sha256}) =>
      db.insert('''INSERT INTO assets (user_id, file_path, original_name, mime_type, byte_size, width, height, sha256)
                   VALUES (?, ?, ?, ?, ?, ?, ?, ?)''', [userId, filePath, originalName, mimeType, byteSize, width, height, sha256]);

  /// 휴지통에서 같은 파일을 다시 올렸을 때 되살리기.
  Row? findDeletedBySha(int userId, String sha256) =>
      db.one('SELECT * FROM assets WHERE user_id = ? AND sha256 = ? AND deleted_at IS NOT NULL', [userId, sha256]);

  void restore(int id) => db.exec('UPDATE assets SET deleted_at = NULL, updated_at = ? WHERE id = ?', [nowAt(), id]);
}
