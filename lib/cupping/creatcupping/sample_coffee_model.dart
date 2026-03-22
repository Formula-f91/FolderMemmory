// lib/cupping/sample_coffee_model.dart
//
// Model กลางสำหรับ Sample ทุกหน้า
// import 'package:wememmory/cupping/sample_coffee_model.dart';
//
// ⚠️  ลบ class SampleCoffee, SampleType, SampleSpecies ออกจากทุกไฟล์ที่มีซ้ำ
//     แล้ว import จากที่นี่ที่เดียวเท่านั้น

// ─────────────────────────────────────────────────────────────────────────────
// SampleType
// ─────────────────────────────────────────────────────────────────────────────

class SampleType {
  final int? id;
  final String? name;

  const SampleType({this.id, this.name});

  factory SampleType.fromMap(Map<String, dynamic> map) {
    return SampleType(
      id:   (map['id'] as num?)?.toInt(),
      name: map['name']?.toString(),
    );
  }

  Map<String, dynamic> toMap() => {'id': id, 'name': name};
}

// ─────────────────────────────────────────────────────────────────────────────
// SampleSpecies
// ─────────────────────────────────────────────────────────────────────────────

class SampleSpecies {
  final int? id;
  final String? name;

  const SampleSpecies({this.id, this.name});

  factory SampleSpecies.fromMap(Map<String, dynamic> map) {
    return SampleSpecies(
      id:   (map['id'] as num?)?.toInt(),
      name: map['name']?.toString(),
    );
  }

  Map<String, dynamic> toMap() => {'id': id, 'name': name};
}

// ─────────────────────────────────────────────────────────────────────────────
// SampleCoffee
// Collection: samples/{sampleId}
// ─────────────────────────────────────────────────────────────────────────────

class SampleCoffee {
  final String? firestoreId;    // Firestore document ID
  final String? ownerUid;       // UID ของเจ้าของ sample

  // ── ฟิลด์หลัก ────────────────────────────────────────────────────────────
  final String? sample_id;      // รหัส sample เช่น "S0001"
  final String? sample_name;
  final String? species;        // ชื่อ species แบบ string (legacy)
  final String? harvest;
  final double? moisture;
  final double? water_activity;
  final double? density;
  final String? coffee_processing;
  final int?    crop_year;
  final String? country;
  final String? color_intensity; // Agtron number
  final String? roast_level;     // "Light" | "Medium" | "Dark"
  final String? created_at;      // ISO string (legacy compat)
  final DateTime? createdAt;     // DateTime สำหรับ Firestore

  // ── Nested objects ────────────────────────────────────────────────────────
  final SampleType?    sample_type;
  final SampleSpecies? sample_species;

  // ── Legacy int id สำหรับ mock data เดิม ──────────────────────────────────
  final int? id;

  const SampleCoffee({
    this.firestoreId,
    this.ownerUid,
    this.sample_id,
    this.sample_name,
    this.species,
    this.harvest,
    this.moisture,
    this.water_activity,
    this.density,
    this.coffee_processing,
    this.crop_year,
    this.country,
    this.color_intensity,
    this.roast_level,
    this.created_at,
    this.createdAt,
    this.sample_type,
    this.sample_species,
    this.id,
  });

  factory SampleCoffee.empty() => const SampleCoffee();

  // ── Firestore → Model ────────────────────────────────────────────────────

  factory SampleCoffee.fromMap(Map<String, dynamic> map, {String? docId}) {
    final createdAtDt = _toDateTime(map['createdAt']);
    return SampleCoffee(
      firestoreId:        docId ?? map['firestoreId']?.toString(),
      ownerUid:           map['ownerUid']?.toString(),
      sample_id:          map['sample_id']?.toString(),
      sample_name:        map['sample_name']?.toString(),
      species:            map['species']?.toString(),
      harvest:            map['harvest']?.toString(),
      moisture:           (map['moisture'] as num?)?.toDouble(),
      water_activity:     (map['water_activity'] as num?)?.toDouble(),
      density:            (map['density'] as num?)?.toDouble(),
      coffee_processing:  map['coffee_processing']?.toString(),
      crop_year:          (map['crop_year'] as num?)?.toInt(),
      country:            map['country']?.toString(),
      color_intensity:    map['color_intensity']?.toString(),
      roast_level:        map['roast_level']?.toString(),
      createdAt:          createdAtDt,
      created_at:         createdAtDt?.toIso8601String(),
      sample_type:        map['sample_type'] != null
                            ? SampleType.fromMap(
                                map['sample_type'] as Map<String, dynamic>)
                            : null,
      sample_species:     map['sample_species'] != null
                            ? SampleSpecies.fromMap(
                                map['sample_species'] as Map<String, dynamic>)
                            : null,
    );
  }

  // ── Model → Firestore ────────────────────────────────────────────────────

  Map<String, dynamic> toMap() {
    return {
      'ownerUid':          ownerUid,
      'sample_id':         sample_id,
      'sample_name':       sample_name,
      'species':           sample_species?.name ?? species,
      'harvest':           harvest,
      'moisture':          moisture,
      'water_activity':    water_activity,
      'density':           density,
      'coffee_processing': coffee_processing,
      'crop_year':         crop_year,
      'country':           country,
      'color_intensity':   color_intensity,
      'roast_level':       roast_level,
      'createdAt':         createdAt?.toIso8601String()
                             ?? created_at
                             ?? DateTime.now().toIso8601String(),
      'sample_type':       sample_type?.toMap(),
      'sample_species':    sample_species?.toMap(),
    };
  }

  // ── copyWith ─────────────────────────────────────────────────────────────

  SampleCoffee copyWith({
    String?       firestoreId,
    String?       ownerUid,
    String?       sample_id,
    String?       sample_name,
    String?       species,
    String?       harvest,
    double?       moisture,
    double?       water_activity,
    double?       density,
    String?       coffee_processing,
    int?          crop_year,
    String?       country,
    String?       color_intensity,
    String?       roast_level,
    String?       created_at,
    DateTime?     createdAt,
    SampleType?   sample_type,
    SampleSpecies? sample_species,
    int?          id,
  }) {
    return SampleCoffee(
      firestoreId:        firestoreId       ?? this.firestoreId,
      ownerUid:           ownerUid          ?? this.ownerUid,
      sample_id:          sample_id         ?? this.sample_id,
      sample_name:        sample_name       ?? this.sample_name,
      species:            species           ?? this.species,
      harvest:            harvest           ?? this.harvest,
      moisture:           moisture          ?? this.moisture,
      water_activity:     water_activity    ?? this.water_activity,
      density:            density           ?? this.density,
      coffee_processing:  coffee_processing ?? this.coffee_processing,
      crop_year:          crop_year         ?? this.crop_year,
      country:            country           ?? this.country,
      color_intensity:    color_intensity   ?? this.color_intensity,
      roast_level:        roast_level       ?? this.roast_level,
      created_at:         created_at        ?? this.created_at,
      createdAt:          createdAt         ?? this.createdAt,
      sample_type:        sample_type       ?? this.sample_type,
      sample_species:     sample_species    ?? this.sample_species,
      id:                 id                ?? this.id,
    );
  }

  // ── Helper ────────────────────────────────────────────────────────────────

  static DateTime? _toDateTime(dynamic value) {
    if (value == null) return null;
    if (value.runtimeType.toString().contains('Timestamp')) {
      return (value as dynamic).toDate() as DateTime;
    }
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Evaluation
// Collection: evaluations/{evalId}
// ─────────────────────────────────────────────────────────────────────────────

class Evaluation {
  final String? evalId;
  final String? sessionId;
  final String? participantUid;
  final String? sessionSampleId;   // อ้างถึง session_samples/{id}
  final int?    cuppingModeId;

  /// scores เป็น map ที่โครงสร้างต่างกันตาม cuppingModeId
  /// Descriptive: { aroma: 8.5, flavor: 7.0, aftertaste: 8.0, ... }
  /// Affective:   { overallLiking: 9 }
  /// Combined:    { aroma: 8.5, overallLiking: 9, ... }
  final Map<String, dynamic>? scores;
  final String? notes;
  final DateTime? submittedAt;

  const Evaluation({
    this.evalId,
    this.sessionId,
    this.participantUid,
    this.sessionSampleId,
    this.cuppingModeId,
    this.scores,
    this.notes,
    this.submittedAt,
  });

  factory Evaluation.fromMap(Map<String, dynamic> map, {String? docId}) {
    return Evaluation(
      evalId:           docId ?? map['evalId']?.toString(),
      sessionId:        map['sessionId']?.toString(),
      participantUid:   map['participantUid']?.toString(),
      sessionSampleId:  map['sessionSampleId']?.toString(),
      cuppingModeId:    (map['cuppingModeId'] as num?)?.toInt(),
      scores:           map['scores'] != null
                          ? Map<String, dynamic>.from(map['scores'] as Map)
                          : null,
      notes:            map['notes']?.toString(),
      submittedAt:      SampleCoffee._toDateTime(map['submittedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sessionId':       sessionId,
      'participantUid':  participantUid,
      'sessionSampleId': sessionSampleId,
      'cuppingModeId':   cuppingModeId,
      'scores':          scores,
      'notes':           notes,
      'submittedAt':     submittedAt?.toIso8601String()
                           ?? DateTime.now().toIso8601String(),
    };
  }
}