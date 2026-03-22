// lib/cupping/service/cupping_service.dart
//
// CRUD สำหรับ:
//   cupping_sessions/{sessionId}
//   session_samples/{id}
//   session_participants/{id}
//
// Dependencies:
//   cloud_firestore: ^5.x
//   firebase_auth: ^5.x

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wememmory/cupping/cuppingsessionAll.dart/cupping_session_model.dart';

class CuppingService {
  // ── Firestore references ──────────────────────────────────────────────────
  static final _db = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  static CollectionReference get _sessions =>
      _db.collection('cupping_sessions');

  static CollectionReference get _sessionSamples =>
      _db.collection('session_samples');

  static CollectionReference get _participants =>
      _db.collection('session_participants');

  // ── helper: uid ปัจจุบัน ──────────────────────────────────────────────────
  static String get _uid => _auth.currentUser?.uid ?? '';

  // ═══════════════════════════════════════════════════════════════════════════
  // CUPPING SESSIONS
  // ═══════════════════════════════════════════════════════════════════════════

  /// สร้าง session ใหม่
  /// คืนค่า sessionId ที่ Firestore สร้างให้
  static Future<String> createSession({
    required CuppingSession session,
    required List<SessionSample> samples,
  }) async {
    // 1. เพิ่ม hostUid และ createdAt
    final data = session.copyWith(
      hostUid: _uid,
      createdAt: DateTime.now(),
      isActive: 'Y',
    ).toMap();

    // 2. สร้าง document ใน cupping_sessions
    final docRef = await _sessions.add(data);
    final sessionId = docRef.id;

    // 3. สร้าง session_samples ทีละรายการ (batch write)
    if (samples.isNotEmpty) {
      final batch = _db.batch();
      for (final sample in samples) {
        final sampleRef = _sessionSamples.doc();
        batch.set(sampleRef, {
          ...sample.copyWith(sessionId: sessionId).toMap(),
          'sessionId': sessionId,
        });
      }
      await batch.commit();
    }

    return sessionId;
  }

  /// แก้ไข session (host เท่านั้น)
  static Future<void> updateSession({
    required String sessionId,
    required CuppingSession session,
    List<SessionSample>? samples,
  }) async {
    // อัปเดต session document
    await _sessions.doc(sessionId).update(session.toMap());

    // ถ้าส่ง samples มาด้วย — ลบเก่าแล้วเพิ่มใหม่
    if (samples != null) {
      // ลบ session_samples เดิม
      final oldSamples = await _sessionSamples
          .where('sessionId', isEqualTo: sessionId)
          .get();
      final batch = _db.batch();
      for (final doc in oldSamples.docs) {
        batch.delete(doc.reference);
      }
      // เพิ่มใหม่
      for (final sample in samples) {
        final sampleRef = _sessionSamples.doc();
        batch.set(sampleRef, {
          ...sample.copyWith(sessionId: sessionId).toMap(),
          'sessionId': sessionId,
        });
      }
      await batch.commit();
    }
  }

  /// ลบ session (host เท่านั้น)
  static Future<void> deleteSession(String sessionId) async {
    final batch = _db.batch();

    // ลบ session_samples ที่เกี่ยวข้อง
    final samples = await _sessionSamples
        .where('sessionId', isEqualTo: sessionId)
        .get();
    for (final doc in samples.docs) {
      batch.delete(doc.reference);
    }

    // ลบ participants ที่เกี่ยวข้อง
    final participants = await _participants
        .where('sessionId', isEqualTo: sessionId)
        .get();
    for (final doc in participants.docs) {
      batch.delete(doc.reference);
    }

    // ลบ session หลัก
    batch.delete(_sessions.doc(sessionId));
    await batch.commit();
  }

  /// เปิด/ปิด session (toggle isActive)
  static Future<void> setSessionActive({
    required String sessionId,
    required bool isActive,
  }) async {
    await _sessions.doc(sessionId).update({
      'isActive': isActive ? 'Y' : 'N',
    });
  }

  // ── Queries ───────────────────────────────────────────────────────────────

  /// ดึง session ทั้งหมดที่ isActive == 'Y' และไม่ใช่ของตัวเอง (tab All)
  static Stream<List<CuppingSession>> streamAllSessions() {
    return _sessions
        .where('isActive', isEqualTo: 'Y')
        .where('hostUid', isNotEqualTo: _uid)
        .orderBy('hostUid')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => CuppingSession.fromMap(
                  doc.data() as Map<String, dynamic>,
                  docId: doc.id,
                ).copyWith(isCreatedByMe: false))
            .toList());
  }

  /// ดึง session ที่ตัวเองสร้าง (tab Create)
  static Stream<List<CuppingSession>> streamMySessions() {
    return _sessions
        .where('hostUid', isEqualTo: _uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => CuppingSession.fromMap(
                  doc.data() as Map<String, dynamic>,
                  docId: doc.id,
                ).copyWith(isCreatedByMe: true))
            .toList());
  }

  /// ดึง session เดียวโดย ID
  static Future<CuppingSession?> getSessionById(String sessionId) async {
    final doc = await _sessions.doc(sessionId).get();
    if (!doc.exists) return null;
    return CuppingSession.fromMap(
      doc.data() as Map<String, dynamic>,
      docId: doc.id,
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SESSION SAMPLES
  // ═══════════════════════════════════════════════════════════════════════════

  /// ดึง samples ทั้งหมดของ session
  static Future<List<SessionSample>> getSessionSamples(
      String sessionId) async {
    final snap = await _sessionSamples
        .where('sessionId', isEqualTo: sessionId)
        .orderBy('sortOrder')
        .get();
    return snap.docs
        .map((doc) => SessionSample.fromMap(
              doc.data() as Map<String, dynamic>,
              docId: doc.id,
            ))
        .toList();
  }

  /// Stream session samples (ใช้ใน real-time)
  static Stream<List<SessionSample>> streamSessionSamples(
      String sessionId) {
    return _sessionSamples
        .where('sessionId', isEqualTo: sessionId)
        .orderBy('sortOrder')
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => SessionSample.fromMap(
                  doc.data() as Map<String, dynamic>,
                  docId: doc.id,
                ))
            .toList());
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SESSION PARTICIPANTS
  // ═══════════════════════════════════════════════════════════════════════════

  /// เข้าร่วม session
  /// คืนค่า participantDocId
  static Future<String> joinSession(String sessionId) async {
    // เช็คว่า join แล้วหรือยัง
    final existing = await _participants
        .where('sessionId', isEqualTo: sessionId)
        .where('uid', isEqualTo: _uid)
        .limit(1)
        .get();

    if (existing.docs.isNotEmpty) {
      return existing.docs.first.id; // join ซ้ำ return id เดิม
    }

    final join = JoinCupping(
      uid: _uid,
      cupping_session: CuppingSession(sessionId: sessionId),
      cupping_status: false,
      joinedAt: DateTime.now(),
    );

    final docRef = await _participants.add(join.toMap());
    return docRef.id;
  }

  /// ดึงรายการ session ที่ user join แล้ว (tab Join)
  static Stream<List<JoinCupping>> streamJoinedSessions() {
    return _participants
        .where('uid', isEqualTo: _uid)
        .orderBy('joinedAt', descending: true)
        .snapshots()
        .asyncMap((snap) async {
      final List<JoinCupping> result = [];
      for (final doc in snap.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final sessionId = data['sessionId']?.toString();
        if (sessionId == null) continue;

        // ดึง session detail มาแนบ
        final session = await getSessionById(sessionId);
        result.add(JoinCupping.fromMap(data, docId: doc.id, session: session));
      }
      return result;
    });
  }

  /// เช็คว่า user join session นี้แล้วหรือยัง
  static Future<bool> hasJoined(String sessionId) async {
    final snap = await _participants
        .where('sessionId', isEqualTo: sessionId)
        .where('uid', isEqualTo: _uid)
        .limit(1)
        .get();
    return snap.docs.isNotEmpty;
  }

  /// อัปเดตสถานะ isDone ของ participant
  static Future<void> markDone({
    required String participantDocId,
    required bool isDone,
  }) async {
    await _participants.doc(participantDocId).update({'isDone': isDone});
  }

  /// นับจำนวน participant ของ session
  static Future<int> countParticipants(String sessionId) async {
    final snap = await _participants
        .where('sessionId', isEqualTo: sessionId)
        .count()
        .get();
    return snap.count ?? 0;
  }
}

// ── Extension สำหรับ copyWith ใน SessionSample ──────────────────────────────
extension SessionSampleCopyWith on SessionSample {
  SessionSample copyWith({
    String? id,
    String? sessionId,
    String? sampleId,
    String? sessionSampleCode,
    int? sortOrder,
  }) {
    return SessionSample(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      sampleId: sampleId ?? this.sampleId,
      sessionSampleCode: sessionSampleCode ?? this.sessionSampleCode,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}