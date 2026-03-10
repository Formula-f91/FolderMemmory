import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wememmory/shop/address_model.dart'; // ตรวจสอบ path ให้ถูก

class AddressPickerPage extends StatefulWidget {
  const AddressPickerPage({super.key});

  @override
  State<AddressPickerPage> createState() => _AddressPickerPageState();
}

class _AddressPickerPageState extends State<AddressPickerPage> {
  // ข้อมูลดิบทั้งหมด
  List<Province> _allProvinces = [];
  List<District> _allDistricts = [];
  List<Subdistrict> _allSubdistricts = [];

  // ข้อมูลที่กรองมาแสดง
  List<District> _shownDistricts = [];
  List<Subdistrict> _shownSubdistricts = [];

  // ค่าที่ถูกเลือก
  Province? selectedProvince;
  District? selectedDistrict;
  Subdistrict? selectedSubdistrict;

  bool isLoading = true;
  String? errorMessage; // ตัวแปรเก็บข้อความ Error
  final TextEditingController _detailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadAllAddressData();
  }

  Future<void> _loadAllAddressData() async {
    try {
      // 1. อ่านไฟล์ (ต้องแน่ใจว่าไฟล์อยู่ใน assets จริงๆ)
      final pString = await rootBundle.loadString('assets/provice/provinces.json');
      final dString = await rootBundle.loadString('assets/provice/districts.json');
      final sString = await rootBundle.loadString('assets/provice/subdistricts.json');

      // 2. แปลง JSON
      final List<dynamic> pJson = json.decode(pString);
      final List<dynamic> dJson = json.decode(dString);
      final List<dynamic> sJson = json.decode(sString);

      if (mounted) {
        setState(() {
          _allProvinces = pJson.map((e) => Province.fromJson(e)).toList();
          _allDistricts = dJson.map((e) => District.fromJson(e)).toList();
          _allSubdistricts = sJson.map((e) => Subdistrict.fromJson(e)).toList();
          isLoading = false;
          errorMessage = null; // เคลียร์ Error
        });
      }
    } catch (e) {
      print("Error loading address data: $e");
      if (mounted) {
        setState(() {
          isLoading = false;
          errorMessage = "โหลดข้อมูลไม่สำเร็จ:\n$e"; // แสดง Error บนหน้าจอ
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('แก้ไขที่อยู่', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text(errorMessage!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.red)))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ปุ่มเลือกจากแผนที่
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.map, color: Color(0xFF2D9CDB)),
                          label: const Text('เลือกจากแผนที่', style: TextStyle(color: Color(0xFF2D9CDB), fontSize: 16)),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF2D9CDB)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 20),

                      // จังหวัด
                      _buildLabel('จังหวัด'),
                      _buildDropdown<Province>(
                        hint: 'เลือกจังหวัด',
                        value: selectedProvince,
                        items: _allProvinces,
                        labelKey: (item) => item.nameTh,
                        onChanged: (val) {
                          setState(() {
                            selectedProvince = val;
                            // กรองอำเภอ
                            _shownDistricts = _allDistricts
                                .where((d) => d.provinceCode == val!.provinceCode)
                                .toList();
                            
                            // รีเซ็ตค่าลูก
                            selectedDistrict = null;
                            selectedSubdistrict = null;
                            _shownSubdistricts = [];
                          });
                        },
                      ),

                      // อำเภอ
                      _buildLabel('อำเภอ/เขต'),
                      _buildDropdown<District>(
                        hint: 'เลือกอำเภอ/เขต',
                        value: selectedDistrict,
                        items: _shownDistricts,
                        enabled: selectedProvince != null,
                        labelKey: (item) => item.nameTh,
                        onChanged: (val) {
                          setState(() {
                            selectedDistrict = val;
                            // กรองตำบล
                            _shownSubdistricts = _allSubdistricts
                                .where((s) => s.districtCode == val!.districtCode)
                                .toList();
                            
                            // รีเซ็ตค่าลูก
                            selectedSubdistrict = null;
                          });
                        },
                      ),

                      // ตำบล
                      _buildLabel('ตำบล/แขวง'),
                      _buildDropdown<Subdistrict>(
                        hint: 'เลือกตำบล/แขวง',
                        value: selectedSubdistrict,
                        items: _shownSubdistricts,
                        enabled: selectedDistrict != null,
                        labelKey: (item) => item.nameTh,
                        onChanged: (val) {
                          setState(() {
                            selectedSubdistrict = val;
                          });
                        },
                      ),

                      // ที่อยู่
                      _buildLabel('บ้านเลขที่, ซอย, หมู่, ถนน'),
                      TextField(
                        controller: _detailController,
                        decoration: const InputDecoration(
                          hintText: 'กรุณากรอกข้อมูล',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFEEEEEE))),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFEEEEEE))),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      // รูปแผนที่
                       ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          'assets/images/map.png',
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            height: 150, color: Colors.grey[200],
                            child: const Center(child: Icon(Icons.map, color: Colors.grey)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context, {
                  'province': selectedProvince?.nameTh,
                  'amphure': selectedDistrict?.nameTh,
                  'tambon': selectedSubdistrict?.nameTh,
                  'postalCode': selectedSubdistrict?.postalCode.toString(),
                  'detail': _detailController.text,
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF36F45),
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              ),
              child: const Text('ยืนยัน', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 16.0),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
    );
  }

  Widget _buildDropdown<T>({
    required String hint,
    required T? value,
    required List<T> items,
    required String Function(T) labelKey,
    required Function(T?) onChanged,
    bool enabled = true,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: enabled ? Colors.white : Colors.grey[100],
        border: Border.all(color: const Color(0xFFEEEEEE)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          hint: Text(hint, style: const TextStyle(color: Colors.grey)),
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black),
          items: items.map((item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Text(labelKey(item), style: const TextStyle(fontSize: 16)),
            );
          }).toList(),
          onChanged: enabled ? onChanged : null,
        ),
      ),
    );
  }
}