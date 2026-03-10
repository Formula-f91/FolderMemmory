import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // จำเป็นสำหรับ TextInputFormatter
import 'package:wememmory/shop/address_model.dart'; // ตรวจสอบ path ให้ถูกต้อง
import 'package:wememmory/shop/addressDetailPage.dart'; // ตรวจสอบ path ให้ถูกต้อง

class EditAddressPage extends StatefulWidget {
  final int? index;
  const EditAddressPage({super.key, this.index});

  @override
  State<EditAddressPage> createState() => _EditAddressPageState();
}

class _EditAddressPageState extends State<EditAddressPage> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _detailController;

  String province = '';
  String district = '';
  String subDistrict = '';
  String postalCode = '';

  @override
  void initState() {
    super.initState();
    if (widget.index != null) {
      final data = globalAddressList[widget.index!];
      _nameController = TextEditingController(text: data.name);
      
      // ✅ จัดรูปแบบเบอร์โทรเดิม (0812345678 -> 081-234-5678) เพื่อแสดงผลตอนแก้ไข
      String formattedPhone = data.phone;
      if (data.phone.length == 10) {
        formattedPhone = '${data.phone.substring(0, 3)}-${data.phone.substring(3, 6)}-${data.phone.substring(6)}';
      }
      _phoneController = TextEditingController(text: formattedPhone);
      
      _detailController = TextEditingController(text: data.detail);
      province = data.province;
      district = data.district;
      subDistrict = data.subDistrict;
    } else {
      _nameController = TextEditingController();
      _phoneController = TextEditingController();
      _detailController = TextEditingController();
    }
  }

  void _onSave() {
    // ✅ ลบขีด (-) ออกจากเบอร์โทรศัพท์ก่อนบันทึกลงตัวแปร
    final cleanPhone = _phoneController.text.replaceAll('-', '');

    final newData = AddressInfo(
      name: _nameController.text,
      phone: cleanPhone, // บันทึกเฉพาะตัวเลข
      province: province,
      district: district,
      subDistrict: subDistrict,
      detail: _detailController.text,
    );

    setState(() {
      if (widget.index != null) {
        globalAddressList[widget.index!] = newData;
      } else {
        globalAddressList.add(newData);
      }
    });
    Navigator.pop(context);
  }

  void _onDelete() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
                child: Text(
                  'ต้องการลบที่อยู่ใช่หรือไม่',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: Color(0xFFE0E0E0))),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            globalAddressList.removeAt(widget.index!);
                          });
                          Navigator.pop(context); // ปิด Dialog
                          Navigator.pop(context); // กลับหน้าเดิม
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: const BoxDecoration(
                            border: Border(
                              right: BorderSide(color: Color(0xFFE0E0E0)),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: const Text('ยืนยัน',
                              style: TextStyle(color: Colors.black)),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          color: const Color(0xFFF36F45),
                          alignment: Alignment.center,
                          child: const Text('ยกเลิก',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.index != null;
    final borderStyle = OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: const BorderSide(color: Color(0xFFEEEEEE)),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(isEditing ? 'แก้ไขที่อยู่' : 'เพิ่มที่อยู่',
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('ชื่อ - นามสกุล',
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              keyboardType: TextInputType.name,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                hintText: 'ชื่อ - นามสกุล',
                hintStyle: const TextStyle(color: Colors.grey),
                filled: false,
                border: borderStyle,
                enabledBorder: borderStyle,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              style: const TextStyle(
                fontFamily: 'Kanit',
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            const Text('หมายเลขโทรศัพท์',
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),

            // ✅ TextField เบอร์โทรศัพท์ พร้อม Formatter
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                // เรียกใช้ Class Formatter ที่เราสร้างด้านล่างสุด
                ThaiPhoneNumberFormatter(),
              ],
              decoration: InputDecoration(
                hintText: '098-765-4321', // Hint แสดงตัวอย่างแบบมีขีด
                hintStyle: const TextStyle(color: Colors.grey),
                filled: false,
                border: borderStyle,
                enabledBorder: borderStyle,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),

            const SizedBox(height: 20),

            const Text('จังหวัด, เขต/อำเภอ, แขวง/ตำบล',
                style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            InkWell(
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddressPickerPage()),
                );

                if (result != null && result is Map) {
                  setState(() {
                    province = result['province'] ?? '';
                    district = result['district'] ?? result['amphure'] ?? '';
                    subDistrict = result['subDistrict'] ??
                        result['subdistrict'] ??
                        result['tambon'] ??
                        '';
                    postalCode = result['postalCode'] ?? '';
                  });
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (province.isEmpty)
                        const Text('เลือกจังหวัด',
                            style: TextStyle(color: Colors.grey)),
                      if (province.isNotEmpty) ...[
                        Text('จังหวัด $province',
                            style: const TextStyle(fontSize: 15)),
                        const SizedBox(height: 4),
                        Text('เขต/อำเภอ $district',
                            style: const TextStyle(fontSize: 15)),
                        const SizedBox(height: 4),
                        Text('แขวง/ตำบล $subDistrict $postalCode',
                            style: const TextStyle(fontSize: 15)),
                      ]
                    ],
                  ),
                  const Icon(Icons.arrow_forward_ios,
                      size: 16, color: Colors.grey),
                ],
              ),
            ),
            const SizedBox(height: 16),

            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/images/map.png',
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (c, o, s) => Container(
                  height: 180,
                  color: Colors.grey[200],
                  child:
                      const Center(child: Icon(Icons.map, color: Colors.grey)),
                ),
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Row(
            children: [
              if (isEditing) ...[
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: OutlinedButton(
                      onPressed: _onDelete,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.black26),
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero),
                      ),
                      child: const Text('ลบ',
                          style: TextStyle(color: Colors.black, fontSize: 16)),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
              ],
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _onSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF36F45),
                      elevation: 0,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero),
                    ),
                    child: const Text('ยืนยัน',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ThaiPhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // 1. กรองเอาเฉพาะตัวเลข
    final text = newValue.text.replaceAll(RegExp(r'\D'), '');

    // 2. จำกัดความยาวสูงสุด 10 หลัก
    if (text.length > 10) return oldValue;

    // 3. เริ่มจัดรูปแบบ
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      // เติมขีดที่ตำแหน่งหลังตัวที่ 3 และหลังตัวที่ 6 (0xx-xxx-xxxx)
      if (i == 3 || i == 6) {
        buffer.write('-');
      }
      buffer.write(text[i]);
    }

    final String formattedText = buffer.toString();

    // 4. คืนค่ากลับไปที่ TextField พร้อมขยับ Cursor ไปท้ายสุด
    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}