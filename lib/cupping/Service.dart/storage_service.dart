// lib/cupping/service/storage_service.dart
//
// อัปโหลด/ลบรูป cover สำหรับ cupping session
// Storage path: sessions/{sessionId}/cover.jpg
//
// Dependencies:
//   firebase_storage: ^12.x
//   firebase_auth: ^5.x
//   image_picker: ^1.x  (ใช้ใน UI layer ไม่ใช่ที่นี่)
//   dart:io

import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  static final _storage = FirebaseStorage.instance;
  static final _auth = FirebaseAuth.instance;

  static String get _uid => _auth.currentUser?.uid ?? 'anonymous';

  // ── Storage paths ─────────────────────────────────────────────────────────

  /// path ของรูป cover สำหรับ session
  static String _coverPath(String sessionId) =>
      'sessions/$sessionId/cover.jpg';

  /// path ของรูปชั่วคราวก่อนที่จะรู้ sessionId (ใช้ uid แทน)
  static String _tempCoverPath() =>
      'temp/$_uid/cover_${DateTime.now().millisecondsSinceEpoch}.jpg';

  // ═══════════════════════════════════════════════════════════════════════════
  // UPLOAD
  // ═══════════════════════════════════════════════════════════════════════════

  /// อัปโหลดรูป cover ของ session
  ///
  /// [file]      : File จาก image_picker
  /// [sessionId] : ID ของ session (ต้องสร้าง session ก่อนแล้ว)
  ///
  /// คืนค่า download URL
  static Future<String> uploadCoverImage({
    required File file,
    required String sessionId,
  }) async {
    final ref = _storage.ref(_coverPath(sessionId));
    final metadata = SettableMetadata(
      contentType: 'image/jpeg',
      customMetadata: {'uploadedBy': _uid},
    );

    final task = await ref.putFile(file, metadata);
    return await task.ref.getDownloadURL();
  }

  /// อัปโหลดรูปชั่วคราว (ใช้ก่อนที่ sessionId จะถูกสร้าง)
  /// คืน { url, storagePath } — เก็บ storagePath ไว้ย้ายทีหลัง
  static Future<({String url, String storagePath})> uploadTempCoverImage(
      File file) async {
    final path = _tempCoverPath();
    final ref = _storage.ref(path);
    final metadata = SettableMetadata(
      contentType: 'image/jpeg',
      customMetadata: {'uploadedBy': _uid, 'temp': 'true'},
    );
    final task = await ref.putFile(file, metadata);
    final url = await task.ref.getDownloadURL();
    return (url: url, storagePath: path);
  }

  /// ย้ายรูปจาก temp path ไปยัง session path
  /// (ใช้หลังจากสร้าง session แล้วได้ sessionId)
  ///
  /// Firebase Storage ไม่มี move API โดยตรง —
  /// วิธี: download bytes → upload ใหม่ → delete เก่า
  static Future<String> moveTempToSession({
    required String tempPath,
    required String sessionId,
  }) async {
    final tempRef = _storage.ref(tempPath);
    final data = await tempRef.getData();
    if (data == null) throw Exception('Temp file not found: $tempPath');

    final newRef = _storage.ref(_coverPath(sessionId));
    final metadata = SettableMetadata(
      contentType: 'image/jpeg',
      customMetadata: {'uploadedBy': _uid},
    );
    await newRef.putData(data, metadata);
    final url = await newRef.getDownloadURL();

    // ลบ temp
    await tempRef.delete();
    return url;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // DELETE
  // ═══════════════════════════════════════════════════════════════════════════

  /// ลบรูป cover ของ session
  static Future<void> deleteCoverImage(String sessionId) async {
    try {
      await _storage.ref(_coverPath(sessionId)).delete();
    } on FirebaseException catch (e) {
      // ไม่ throw ถ้าไม่มีไฟล์อยู่แล้ว
      if (e.code != 'object-not-found') rethrow;
    }
  }

  /// ลบรูป temp ทั้งหมดของ user (เรียกตอน cleanup)
  static Future<void> deleteTempImages() async {
    try {
      final ref = _storage.ref('temp/$_uid');
      final list = await ref.listAll();
      for (final item in list.items) {
        await item.delete();
      }
    } on FirebaseException catch (_) {
      // ไม่สนใจถ้าไม่มีไฟล์
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // UPLOAD PROGRESS (optional — ใช้ใน UI)
  // ═══════════════════════════════════════════════════════════════════════════

  /// อัปโหลดพร้อม progress callback
  ///
  /// ตัวอย่างการใช้งาน:
  /// ```dart
  /// final url = await StorageService.uploadWithProgress(
  ///   file: file,
  ///   sessionId: sessionId,
  ///   onProgress: (progress) => setState(() => _progress = progress),
  /// );
  /// ```
  static Future<String> uploadWithProgress({
    required File file,
    required String sessionId,
    void Function(double progress)? onProgress,
  }) async {
    final ref = _storage.ref(_coverPath(sessionId));
    final metadata = SettableMetadata(
      contentType: 'image/jpeg',
      customMetadata: {'uploadedBy': _uid},
    );

    final task = ref.putFile(file, metadata);

    if (onProgress != null) {
      task.snapshotEvents.listen((snapshot) {
        final progress =
            snapshot.bytesTransferred / snapshot.totalBytes;
        onProgress(progress);
      });
    }

    final snapshot = await task;
    return await snapshot.ref.getDownloadURL();
  }
}