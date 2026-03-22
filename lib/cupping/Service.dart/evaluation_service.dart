// lib/cupping/service/evaluation_service.dart
//
// จัดการ Collection: evaluations/{evalId}
//
// โครงสร้าง scores map ตาม cuppingModeId:
//   1 Descriptive : { fragrance, aroma, flavor, aftertaste, acidity, body, balance, overall }
//   2 Affective   : { overallLiking, appearanceLiking, aromaLiking, flavorLiking }
//   3 Combined    : { fragrance, aroma, flavor, aftertaste, acidity, body, overall, overallLiking }
//   4 Quick Mode  : { score, notes }
//   5 Quick Mode 2: { score, notes }
//
// Dependencies:
//   cloud_firestore: ^5.x
//   firebase_auth: ^5.x

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wememmory/cupping/creatcupping/sample_coffee_model.dart';

class EvaluationService {
  static final _db = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  static CollectionReference get _evals =>
      _db.collection('evaluations');

  static CollectionReference get _participants =>
      _db.collection('session_participants');

  static String get _uid => _auth.currentUser?.uid ?? '';

  // ═══════════════════════════════════════════════════════════════════════════
  // SUBMIT EVALUATION
  // ═══════════════════════════════════════════════════════════════════════════

  /// บันทึกผลการประเมิน 1 sample
  /// ถ้าเคยบันทึกแล้ว (evalId ไม่ null) จะ update แทน
  static Future<String> submitEvaluation(Evaluation eval) async {
    final data = eval.copyWith(
      participantUid: _uid,
      submittedAt: DateTime.now(),
    ).toMap();

    if (eval.evalId != null) {
      // update
      await _evals.doc(eval.evalId).set(data, SetOptions(merge: true));
      return eval.evalId!;
    } else {
      // create
      final docRef = await _evals.add(data);
      return docRef.id;
    }
  }

  /// บันทึกพร้อมกันหลาย sample (batch)
  /// เรียกเมื่อ user กด Submit ทั้งหมด
  /// คืนค่า list of evalId
  static Future<List<String>> submitAllEvaluations({
    required String sessionId,
    required String participantDocId,
    required List<Evaluation> evaluations,
  }) async {
    final batch = _db.batch();
    final ids = <String>[];

    for (final eval in evaluations) {
      final ref = _evals.doc();
      ids.add(ref.id);
      batch.set(ref, {
        ...eval.copyWith(
          participantUid: _uid,
          sessionId: sessionId,
          submittedAt: DateTime.now(),
        ).toMap(),
      });
    }

    // อัปเดต isDone ใน session_participants
    batch.update(_participants.doc(participantDocId), {'isDone': true});

    await batch.commit();
    return ids;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // READ
  // ═══════════════════════════════════════════════════════════════════════════

  /// ดึง evaluations ทั้งหมดของ session (ใช้สรุปผล)
  static Future<List<Evaluation>> getSessionEvaluations(
      String sessionId) async {
    final snap = await _evals
        .where('sessionId', isEqualTo: sessionId)
        .orderBy('submittedAt')
        .get();
    return snap.docs
        .map((doc) => Evaluation.fromMap(
              doc.data() as Map<String, dynamic>,
              docId: doc.id,
            ))
        .toList();
  }

  /// ดึง evaluations ของ user ใน session นี้
  static Future<List<Evaluation>> getMyEvaluations(
      String sessionId) async {
    final snap = await _evals
        .where('sessionId', isEqualTo: sessionId)
        .where('participantUid', isEqualTo: _uid)
        .orderBy('submittedAt')
        .get();
    return snap.docs
        .map((doc) => Evaluation.fromMap(
              doc.data() as Map<String, dynamic>,
              docId: doc.id,
            ))
        .toList();
  }

  /// ดึง evaluation ของ user สำหรับ sample เดียว
  static Future<Evaluation?> getMyEvaluationForSample({
    required String sessionId,
    required String sessionSampleId,
  }) async {
    final snap = await _evals
        .where('sessionId', isEqualTo: sessionId)
        .where('participantUid', isEqualTo: _uid)
        .where('sessionSampleId', isEqualTo: sessionSampleId)
        .limit(1)
        .get();
    if (snap.docs.isEmpty) return null;
    return Evaluation.fromMap(
      snap.docs.first.data() as Map<String, dynamic>,
      docId: snap.docs.first.id,
    );
  }

  /// Stream evaluations ของ session (real-time สำหรับ host ดูผล)
  static Stream<List<Evaluation>> streamSessionEvaluations(
      String sessionId) {
    return _evals
        .where('sessionId', isEqualTo: sessionId)
        .orderBy('submittedAt')
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => Evaluation.fromMap(
                  doc.data() as Map<String, dynamic>,
                  docId: doc.id,
                ))
            .toList());
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // AGGREGATE — คำนวณคะแนนสรุป
  // ═══════════════════════════════════════════════════════════════════════════

  /// คำนวณคะแนนเฉลี่ยของแต่ละ field ต่อ sessionSampleId
  ///
  /// คืนค่า Map<sessionSampleId, Map<field, avgScore>>
  /// ตัวอย่าง: { 'ssId1': { 'aroma': 8.2, 'flavor': 7.5 }, ... }
  static Map<String, Map<String, double>> aggregateScores(
      List<Evaluation> evaluations) {
    // groupBy sessionSampleId
    final grouped = <String, List<Map<String, dynamic>>>{};
    for (final eval in evaluations) {
      final key = eval.sessionSampleId ?? 'unknown';
      grouped.putIfAbsent(key, () => []);
      if (eval.scores != null) grouped[key]!.add(eval.scores!);
    }

    // คำนวณ avg ของแต่ละ field
    final result = <String, Map<String, double>>{};
    grouped.forEach((sampleId, scoresList) {
      if (scoresList.isEmpty) return;

      final allFields = <String>{};
      for (final scores in scoresList) {
        allFields.addAll(scores.keys
            .where((k) => scores[k] is num)
            .map((k) => k));
      }

      final avg = <String, double>{};
      for (final field in allFields) {
        final values = scoresList
            .where((s) => s[field] is num)
            .map((s) => (s[field] as num).toDouble())
            .toList();
        if (values.isEmpty) continue;
        avg[field] = values.reduce((a, b) => a + b) / values.length;
      }
      result[sampleId] = avg;
    });

    return result;
  }

  /// นับจำนวน participant ที่ส่งผลแล้ว (isDone == true)
  static Future<int> countDoneParticipants(String sessionId) async {
    final snap = await _participants
        .where('sessionId', isEqualTo: sessionId)
        .where('isDone', isEqualTo: true)
        .count()
        .get();
    return snap.count ?? 0;
  }
}

// ── Extension: copyWith สำหรับ Evaluation ────────────────────────────────────
extension EvaluationCopyWith on Evaluation {
  Evaluation copyWith({
    String? evalId,
    String? sessionId,
    String? participantUid,
    String? sessionSampleId,
    int? cuppingModeId,
    Map<String, dynamic>? scores,
    String? notes,
    DateTime? submittedAt,
  }) {
    return Evaluation(
      evalId: evalId ?? this.evalId,
      sessionId: sessionId ?? this.sessionId,
      participantUid: participantUid ?? this.participantUid,
      sessionSampleId: sessionSampleId ?? this.sessionSampleId,
      cuppingModeId: cuppingModeId ?? this.cuppingModeId,
      scores: scores ?? this.scores,
      notes: notes ?? this.notes,
      submittedAt: submittedAt ?? this.submittedAt,
    );
  }
}