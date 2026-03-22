// lib/cupping/cupping_session_model.dart
//
// Model กลางสำหรับทุกไฟล์ที่เกี่ยวกับ Cupping Session
// import 'package:wememmory/cupping/cupping_session_model.dart';
//
// ⚠️  ลบ class CuppingSession และ JoinCupping ออกจากทุกไฟล์ที่มีซ้ำ
//     แล้ว import จากที่นี่ที่เดียวเท่านั้น

// ─────────────────────────────────────────────────────────────────────────────
// CuppingSession
// Collection: cupping_sessions/{sessionId}
// ─────────────────────────────────────────────────────────────────────────────

class CuppingSession {
  final String? sessionId;      // Firestore document ID
  final String? hostUid;        // UID ของคนสร้าง
  final String? cuppingName;
  final String? description;
  final String? location;
  final double? lat;
  final double? lng;
  final String? imageUrl;       // URL จาก Firebase Storage
  final int? cuppingModeId;     // 1=Descriptive 2=Affective 3=Combined 4=QuickMode 5=QuickMode2
  final String? sampleIdStructure; // "number" | "three_digit" | "letter"
  final int? participantLimit;
  final int? participationFee;
  final String? isActive;       // "Y" | "N"
  final DateTime? startAt;
  final DateTime? endAt;
  final DateTime? createdAt;

  // ── ใช้สำหรับ UI เท่านั้น ไม่ได้เก็บใน Firestore ──
  final bool isCreatedByMe;
  final int? numberOfSamples;   // คำนวณจาก session_samples subcollection

  // ── legacy int? id สำหรับ mock data เดิม ──
  final int? id;

  const CuppingSession({
    this.sessionId,
    this.hostUid,
    this.cuppingName,
    this.description,
    this.location,
    this.lat,
    this.lng,
    this.imageUrl,
    this.cuppingModeId,
    this.sampleIdStructure,
    this.participantLimit,
    this.participationFee,
    this.isActive,
    this.startAt,
    this.endAt,
    this.createdAt,
    this.isCreatedByMe = false,
    this.numberOfSamples,
    this.id,
  });

  // ── Firestore → Model ────────────────────────────────────────────────────

  factory CuppingSession.fromMap(Map<String, dynamic> map, {String? docId}) {
    return CuppingSession(
      sessionId:          docId ?? map['sessionId']?.toString(),
      hostUid:            map['hostUid']?.toString(),
      cuppingName:        map['cuppingName']?.toString(),
      description:        map['description']?.toString(),
      location:           map['location']?.toString(),
      lat:                (map['lat'] as num?)?.toDouble(),
      lng:                (map['lng'] as num?)?.toDouble(),
      imageUrl:           map['imageUrl']?.toString(),
      cuppingModeId:      (map['cuppingModeId'] as num?)?.toInt(),
      sampleIdStructure:  map['sampleIdStructure']?.toString(),
      participantLimit:   (map['participantLimit'] as num?)?.toInt(),
      participationFee:   (map['participationFee'] as num?)?.toInt(),
      isActive:           map['isActive']?.toString() ?? 'Y',
      startAt:            _toDateTime(map['startAt']),
      endAt:              _toDateTime(map['endAt']),
      createdAt:          _toDateTime(map['createdAt']),
      numberOfSamples:    (map['numberOfSamples'] as num?)?.toInt(),
    );
  }

  // ── Model → Firestore ────────────────────────────────────────────────────

  Map<String, dynamic> toMap() {
    return {
      'hostUid':           hostUid,
      'cuppingName':       cuppingName,
      'description':       description,
      'location':          location,
      'lat':               lat,
      'lng':               lng,
      'imageUrl':          imageUrl,
      'cuppingModeId':     cuppingModeId,
      'sampleIdStructure': sampleIdStructure,
      'participantLimit':  participantLimit,
      'participationFee':  participationFee,
      'isActive':          isActive ?? 'Y',
      'startAt':           startAt?.toIso8601String(),
      'endAt':             endAt?.toIso8601String(),
      'createdAt':         createdAt?.toIso8601String()
                             ?? DateTime.now().toIso8601String(),
    };
  }

  // ── copyWith ─────────────────────────────────────────────────────────────

  CuppingSession copyWith({
    String?   sessionId,
    String?   hostUid,
    String?   cuppingName,
    String?   description,
    String?   location,
    double?   lat,
    double?   lng,
    String?   imageUrl,
    int?      cuppingModeId,
    String?   sampleIdStructure,
    int?      participantLimit,
    int?      participationFee,
    String?   isActive,
    DateTime? startAt,
    DateTime? endAt,
    DateTime? createdAt,
    bool?     isCreatedByMe,
    int?      numberOfSamples,
    int?      id,
  }) {
    return CuppingSession(
      sessionId:          sessionId          ?? this.sessionId,
      hostUid:            hostUid            ?? this.hostUid,
      cuppingName:        cuppingName        ?? this.cuppingName,
      description:        description        ?? this.description,
      location:           location           ?? this.location,
      lat:                lat                ?? this.lat,
      lng:                lng                ?? this.lng,
      imageUrl:           imageUrl           ?? this.imageUrl,
      cuppingModeId:      cuppingModeId      ?? this.cuppingModeId,
      sampleIdStructure:  sampleIdStructure  ?? this.sampleIdStructure,
      participantLimit:   participantLimit   ?? this.participantLimit,
      participationFee:   participationFee   ?? this.participationFee,
      isActive:           isActive           ?? this.isActive,
      startAt:            startAt            ?? this.startAt,
      endAt:              endAt              ?? this.endAt,
      createdAt:          createdAt          ?? this.createdAt,
      isCreatedByMe:      isCreatedByMe      ?? this.isCreatedByMe,
      numberOfSamples:    numberOfSamples    ?? this.numberOfSamples,
      id:                 id                 ?? this.id,
    );
  }

  // ── Helper: แปลง Firestore Timestamp / String → DateTime ─────────────────

  static DateTime? _toDateTime(dynamic value) {
    if (value == null) return null;
    // Firestore Timestamp (cloud_firestore package)
    if (value.runtimeType.toString().contains('Timestamp')) {
      return (value as dynamic).toDate() as DateTime;
    }
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  // ── Getters สะดวกใช้ใน UI ────────────────────────────────────────────────

  /// startAt ในรูปแบบ ISO string (compat กับโค้ดเดิม)
  String? get startAtString => startAt?.toIso8601String();

  /// endAt ในรูปแบบ ISO string (compat กับโค้ดเดิม)
  String? get endAtString => endAt?.toIso8601String();

  String get cuppingModeName {
    switch (cuppingModeId) {
      case 1: return 'Descriptive';
      case 2: return 'Affective';
      case 3: return 'Combined';
      case 4: return 'Quick Mode';
      case 5: return 'Quick Mode 2';
      default: return 'N/A';
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// JoinCupping  (UI-only model — ไม่ได้เก็บใน Firestore ตรงๆ)
// ข้อมูลจริงอยู่ใน session_participants/{id}
// ─────────────────────────────────────────────────────────────────────────────

class JoinCupping {
  final CuppingSession? cupping_session;
  final bool? cupping_status; // false = ยังไม่ได้ทำ, true = ทำเสร็จแล้ว

  // Firestore participant fields
  final String? participantDocId;
  final String? uid;
  final DateTime? joinedAt;

  const JoinCupping({
    this.cupping_session,
    this.cupping_status,
    this.participantDocId,
    this.uid,
    this.joinedAt,
  });

  factory JoinCupping.fromMap(
    Map<String, dynamic> map, {
    String? docId,
    CuppingSession? session,
  }) {
    return JoinCupping(
      participantDocId: docId ?? map['id']?.toString(),
      uid:              map['uid']?.toString(),
      cupping_status:   map['isDone'] as bool? ?? false,
      joinedAt:         CuppingSession._toDateTime(map['joinedAt']),
      cupping_session:  session,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid':      uid,
      'sessionId': cupping_session?.sessionId,
      'isDone':   cupping_status ?? false,
      'joinedAt': joinedAt?.toIso8601String()
                    ?? DateTime.now().toIso8601String(),
    };
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SessionSample
// Collection: session_samples/{id}  (subcollection หรือ top-level ก็ได้)
// ─────────────────────────────────────────────────────────────────────────────

class SessionSample {
  final String? id;
  final String? sessionId;
  final String? sampleId;         // อ้างถึง samples/{sampleId}
  final String? sessionSampleCode; // รหัสที่แสดงในแก้ว "A", "257", "1"
  final int? sortOrder;

  const SessionSample({
    this.id,
    this.sessionId,
    this.sampleId,
    this.sessionSampleCode,
    this.sortOrder,
  });

  factory SessionSample.fromMap(Map<String, dynamic> map, {String? docId}) {
    return SessionSample(
      id:                docId ?? map['id']?.toString(),
      sessionId:         map['sessionId']?.toString(),
      sampleId:          map['sampleId']?.toString(),
      sessionSampleCode: map['sessionSampleCode']?.toString(),
      sortOrder:         (map['sortOrder'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sessionId':         sessionId,
      'sampleId':          sampleId,
      'sessionSampleCode': sessionSampleCode,
      'sortOrder':         sortOrder,
    };
  }
}