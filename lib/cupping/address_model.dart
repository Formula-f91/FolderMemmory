// address_model.dart
// ไฟล์: address_data.dart หรือ address_model.dart

// --- ตัวแปรกลางสำหรับเก็บข้อมูล (จะไม่หายไปไหนตราบใดที่แอปยังเปิดอยู่) ---
List<AddressInfo> globalAddressList = [
  // ข้อมูลตัวอย่าง (ลบออกได้)
  AddressInfo(
    name: 'ชื่อ-นามสกุล',
    phone: '099-999-9999',
    province: 'กรุงเทพมหานคร',
    district: 'ปทุมวัน',
    subDistrict: 'ปทุมวัน',
    detail: '',
  ),
];


class AddressInfo {
  final String name;
  final String phone;
  final String province;
  final String district;
  final String subDistrict;
  final String detail;

  const AddressInfo({
    required this.name,
    required this.phone,
    this.province = '',
    this.district = '',
    this.subDistrict = '',
    this.detail = '',
  });
}

// ฟังก์ชันช่วยแปลงค่า (ไม่ว่า JSON จะมาเป็น String หรือ Int ก็รับได้หมด)
int _parseInt(dynamic value) {
  if (value is int) return value;
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

String _parseString(dynamic value) {
  return value?.toString() ?? '';
}

class Province {
  final int id;
  final int provinceCode;
  final String nameTh;
  final String nameEn;

  Province({required this.id, required this.provinceCode, required this.nameTh, required this.nameEn});

  factory Province.fromJson(Map<String, dynamic> json) {
    return Province(
      id: _parseInt(json['id']),
      provinceCode: _parseInt(json['provinceCode']),
      nameTh: _parseString(json['nameTH']),
      nameEn: _parseString(json['nameEn']),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Province && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class District {
  final int id;
  final int provinceCode;
  final int districtCode;
  final String nameTh;
  final String nameEn;

  District({required this.id, required this.provinceCode, required this.districtCode, required this.nameTh, required this.nameEn});

  factory District.fromJson(Map<String, dynamic> json) {
    return District(
      id: _parseInt(json['id']),
      provinceCode: _parseInt(json['provinceCode']),
      districtCode: _parseInt(json['districtCode']),
      nameTh: _parseString(json['nameTH']),
      nameEn: _parseString(json['nameEn']),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is District && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class Subdistrict {
  final int id;
  final int districtCode;
  final int? subdistrictCode;
  final String nameTh;
  final String nameEn;
  final int postalCode;

  Subdistrict({required this.id, required this.districtCode, this.subdistrictCode, required this.nameTh, required this.nameEn, required this.postalCode});

  factory Subdistrict.fromJson(Map<String, dynamic> json) {
    return Subdistrict(
      id: _parseInt(json['id']),
      districtCode: _parseInt(json['districtCode']),
      subdistrictCode: _parseInt(json['subdistrictCode']),
      nameTh: _parseString(json['nameTH']),
      nameEn: _parseString(json['nameEn']),
      postalCode: _parseInt(json['postalCode']),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Subdistrict && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}