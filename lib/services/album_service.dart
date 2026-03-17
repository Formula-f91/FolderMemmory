import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:wememmory/data/album_data.dart';
import 'package:wememmory/models/media_item.dart';

class AlbumService {
  static final _auth = FirebaseAuth.instance;
  static final _storage = FirebaseStorage.instance;
  static final _firestore = FirebaseFirestore.instance;

  static String get _uid => _auth.currentUser!.uid;

  // ── อัพโหลดอัลบั้มทั้งหมด (พร้อมกันทุกรูป) ──
  static Future<void> saveAlbum({
    required String monthName,
    required List<MediaItem> items,
    void Function(int current, int total)? onProgress,
  }) async {
    final folderKey = monthName.replaceAll(' ', '_');
    final total = items.length;

    // ✅ ใช้ thread-safe list สำหรับเก็บ metadata
    final photoMeta = List<Map<String, dynamic>?>.filled(total, null);

    // ✅ counter สำหรับ progress
    int uploadedCount = 0;

    // ✅ อัพโหลดทุกรูปพร้อมกัน (parallel) แทนทีละรูป (sequential)
    await Future.wait(
      List.generate(total, (i) async {
        final item = items[i];

        // ✅ ลดขนาดรูปลงเหลือ 600x600 เร็วขึ้นและประหยัด Storage
        final Uint8List? imageBytes =
            item.capturedImage ??
            await item.asset.thumbnailDataWithSize(
              const ThumbnailSize(600, 600),
            );

        if (imageBytes == null) return;

        final ref = _storage.ref('albums/$_uid/$folderKey/photo_$i.jpg');
        await ref.putData(
          imageBytes,
          SettableMetadata(contentType: 'image/jpeg'),
        );

        final downloadUrl = await ref.getDownloadURL();

        // เก็บ metadata ตาม index เพื่อให้ลำดับถูกต้อง
        photoMeta[i] = {
          'index': i,
          'storageUrl': downloadUrl,
          'caption': item.caption,
          'tags': item.tags,
        };

        // ✅ อัปเดต progress
        uploadedCount++;
        onProgress?.call(uploadedCount, total);
      }),
    );

    // กรอง null ออก (รูปที่โหลดไม่สำเร็จ)
    final validPhotoMeta = photoMeta.whereType<Map<String, dynamic>>().toList();

    // ✅ บันทึก metadata ลง Firestore
    try {
      await _firestore
          .collection('users')
          .doc(_uid)
          .collection('albums')
          .doc(folderKey)
          .set({
            'month': monthName,
            'createdAt': FieldValue.serverTimestamp(),
            'photos': validPhotoMeta,
          });
      debugPrint('=== Firestore บันทึกสำเร็จ ===');
    } catch (e) {
      debugPrint('=== Firestore error (Storage สำเร็จแล้ว): $e ===');
    }
  }

  // ── โหลดอัลบั้มทั้งหมดของ user พร้อม storagePhotos ──
  static Future<List<AlbumCollection>> loadAlbums() async {
    final snapshot =
        await _firestore
            .collection('users')
            .doc(_uid)
            .collection('albums')
            .orderBy('createdAt', descending: true)
            .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      final List photos = data['photos'] ?? [];

      final storagePhotos =
          photos
              .map(
                (p) => StoragePhoto(
                  index: p['index'] ?? 0,
                  url: p['storageUrl'] ?? '',
                  caption: p['caption'] ?? '',
                  tags: List<String>.from(p['tags'] ?? []),
                ),
              )
              .toList();

      return AlbumCollection(
        month: data['month'] as String,
        items: [],
        storagePhotos: storagePhotos,
      );
    }).toList();
  }

  // ── ดึงรายชื่อเดือนที่มีอัลบั้มแล้ว ──
  static Future<List<String>> getAlbumMonths() async {
    final snapshot =
        await _firestore
            .collection('users')
            .doc(_uid)
            .collection('albums')
            .orderBy('createdAt', descending: true)
            .get();

    return snapshot.docs.map((doc) => doc['month'] as String).toList();
  }

  // ── เช็คว่าอัลบั้มเดือนนี้มีแล้วหรือยัง ──
  static Future<bool> isAlbumExists(String monthName) async {
    final folderKey = monthName.replaceAll(' ', '_');
    final doc =
        await _firestore
            .collection('users')
            .doc(_uid)
            .collection('albums')
            .doc(folderKey)
            .get();
    return doc.exists;
  }

  // ── ลบอัลบั้ม (Storage + Firestore) ──
  static Future<void> deleteAlbum(String monthName) async {
    final folderKey = monthName.replaceAll(' ', '_');

    try {
      final storageRef = _storage.ref('albums/$_uid/$folderKey');
      final listResult = await storageRef.listAll();
      // ✅ ลบทุกไฟล์พร้อมกัน
      await Future.wait(listResult.items.map((item) => item.delete()));
    } catch (e) {
      debugPrint('Storage delete error: $e');
    }

    try {
      await _firestore
          .collection('users')
          .doc(_uid)
          .collection('albums')
          .doc(folderKey)
          .delete();
    } catch (e) {
      debugPrint('Firestore delete error: $e');
    }
  }
}
