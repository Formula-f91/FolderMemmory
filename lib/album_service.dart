// import 'dart:typed_data';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:wememmory/models/media_item.dart';

// class AlbumService {
//   static final _auth = FirebaseAuth.instance;
//   static final _storage = FirebaseStorage.instance;
//   static final _firestore = FirebaseFirestore.instance;

//   static String get _uid => _auth.currentUser!.uid;

//   // ── อัพโหลดอัลบั้มทั้งหมด ──
//   // ✅ รับ onProgress callback เพื่อแสดงความคืบหน้าใน UI
//   static Future<void> saveAlbum({
//     required String monthName,
//     required List<MediaItem> items,
//     void Function(int current, int total)? onProgress,
//   }) async {
//     final folderKey = monthName.replaceAll(' ', '_'); // "มกราคม_2025"
//     final List<Map<String, dynamic>> photoMeta = [];
//     final total = items.length;

//     for (int i = 0; i < total; i++) {
//       // ✅ แจ้งความคืบหน้า เช่น "กำลังอัพโหลดรูป 1/11"
//       onProgress?.call(i + 1, total);

//       final item = items[i];

//       // ใช้ capturedImage (รูปที่แต่งแล้ว) ถ้ามี ไม่งั้นโหลด thumbnail
//       final Uint8List? imageBytes =
//           item.capturedImage ??
//           await item.asset.thumbnailDataWithSize(const ThumbnailSize(800, 800));

//       if (imageBytes == null) continue;

//       // อัพโหลดรูปไป Firebase Storage
//       final ref = _storage.ref('albums/$_uid/$folderKey/photo_$i.jpg');

//       await ref.putData(
//         imageBytes,
//         SettableMetadata(contentType: 'image/jpeg'),
//       );

//       final downloadUrl = await ref.getDownloadURL();

//       photoMeta.add({
//         'index': i,
//         'storageUrl': downloadUrl,
//         'caption': item.caption ?? '',
//         'tags': item.tags,
//       });
//     }

//     // บันทึก metadata ลง Firestore
//     await _firestore
//         .collection('users')
//         .doc(_uid)
//         .collection('albums')
//         .doc(folderKey)
//         .set({
//           'month': monthName,
//           'createdAt': FieldValue.serverTimestamp(),
//           'photos': photoMeta,
//         });
//   }

//   // ── ดึงรายชื่ออัลบั้มทั้งหมดของ user ──
//   static Future<List<String>> getAlbumMonths() async {
//     final snapshot =
//         await _firestore
//             .collection('users')
//             .doc(_uid)
//             .collection('albums')
//             .orderBy('createdAt', descending: true)
//             .get();

//     return snapshot.docs.map((doc) => doc['month'] as String).toList();
//   }

//   // ── เช็คว่าอัลบั้มเดือนนี้มีแล้วหรือยัง ──
//   static Future<bool> isAlbumExists(String monthName) async {
//     final folderKey = monthName.replaceAll(' ', '_');
//     final doc =
//         await _firestore
//             .collection('users')
//             .doc(_uid)
//             .collection('albums')
//             .doc(folderKey)
//             .get();
//     return doc.exists;
//   }

//   // ── ลบอัลบั้ม ──
//   static Future<void> deleteAlbum(String monthName) async {
//     final folderKey = monthName.replaceAll(' ', '_');

//     // ลบไฟล์ใน Storage ทั้งหมด
//     final storageRef = _storage.ref('albums/$_uid/$folderKey');
//     final listResult = await storageRef.listAll();
//     for (final item in listResult.items) {
//       await item.delete();
//     }

//     // ลบ document ใน Firestore
//     await _firestore
//         .collection('users')
//         .doc(_uid)
//         .collection('albums')
//         .doc(folderKey)
//         .delete();
//   }
// }
