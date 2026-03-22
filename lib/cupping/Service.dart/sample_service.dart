// lib/cupping/service/sample_service.dart
//
// จัดการ Collection: samples/{sampleId}
//
// Dependencies:
//   cloud_firestore: ^5.x
//   firebase_auth: ^5.x

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wememmory/cupping/creatcupping/sample_coffee_model.dart';

class SampleService {
  static final _db = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  static CollectionReference get _samples => _db.collection('samples');

  static String get _uid => _auth.currentUser?.uid ?? '';

  // ═══════════════════════════════════════════════════════════════════════════
  // CREATE
  // ═══════════════════════════════════════════════════════════════════════════

  /// สร้าง sample ใหม่
  /// คืนค่า SampleCoffee ที่มี firestoreId แล้ว
  static Future<SampleCoffee> createSample(SampleCoffee sample) async {
    final data =
        sample.copyWith(ownerUid: _uid, createdAt: DateTime.now()).toMap();

    // auto-generate sample_id ถ้ายังไม่มี (เช่น "S0001")
    if (data['sample_id'] == null) {
      final count = await countMySamples();
      data['sample_id'] = 'S${(count + 1).toString().padLeft(4, '0')}';
    }

    final docRef = await _samples.add(data);
    return sample.copyWith(
      firestoreId: docRef.id,
      ownerUid: _uid,
      sample_id: data['sample_id']?.toString(),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // READ
  // ═══════════════════════════════════════════════════════════════════════════

  /// ดึง samples ทั้งหมดของ user ปัจจุบัน (ใช้ใน Existing Sample sheet)
  static Future<List<SampleCoffee>> getMySamples() async {
    final snap =
        await _samples
            .where('ownerUid', isEqualTo: _uid)
            .orderBy('createdAt', descending: true)
            .get();
    return snap.docs
        .map(
          (doc) => SampleCoffee.fromMap(
            doc.data() as Map<String, dynamic>,
            docId: doc.id,
          ),
        )
        .toList();
  }

  /// Stream samples ของ user (real-time)
  static Stream<List<SampleCoffee>> streamMySamples() {
    return _samples
        .where('ownerUid', isEqualTo: _uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snap) =>
              snap.docs
                  .map(
                    (doc) => SampleCoffee.fromMap(
                      doc.data() as Map<String, dynamic>,
                      docId: doc.id,
                    ),
                  )
                  .toList(),
        );
  }

  /// ค้นหา sample ตาม sample_id หรือ sample_name
  static Future<List<SampleCoffee>> searchMySamples(String query) async {
    if (query.isEmpty) return getMySamples();

    final all = await getMySamples();
    final q = query.toLowerCase();
    return all.where((s) {
      final idMatch = (s.sample_id ?? '').toLowerCase().contains(q);
      final nameMatch = (s.sample_name ?? '').toLowerCase().contains(q);
      return idMatch || nameMatch;
    }).toList();
  }

  /// ดึง sample เดียวโดย firestoreId
  static Future<SampleCoffee?> getSampleById(String firestoreId) async {
    final doc = await _samples.doc(firestoreId).get();
    if (!doc.exists) return null;
    return SampleCoffee.fromMap(
      doc.data() as Map<String, dynamic>,
      docId: doc.id,
    );
  }

  /// นับจำนวน samples ของ user (ใช้สร้าง sample_id)
  static Future<int> countMySamples() async {
    final snap =
        await _samples.where('ownerUid', isEqualTo: _uid).count().get();
    return snap.count ?? 0;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // UPDATE
  // ═══════════════════════════════════════════════════════════════════════════

  /// แก้ไข sample
  static Future<void> updateSample(SampleCoffee sample) async {
    if (sample.firestoreId == null) {
      throw Exception('firestoreId is required to update sample');
    }
    await _samples.doc(sample.firestoreId).update(sample.toMap());
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // DELETE
  // ═══════════════════════════════════════════════════════════════════════════

  /// ลบ sample
  static Future<void> deleteSample(String firestoreId) async {
    await _samples.doc(firestoreId).delete();
  }
}
