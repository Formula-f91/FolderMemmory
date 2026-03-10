import 'package:flutter/material.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  // สีส้มตามตัวอย่าง (ประมาณค่า)
  final Color _themeColor = const Color(0xFFFAB488);
  
  // ตัวแปรเก็บค่าภาษาที่เลือก (default เป็น Thailand ตามรูป)
  String _selectedLanguage = 'Thailand';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _themeColor, // สีพื้นหลังของ Scaffold เป็นสีส้ม
      appBar: AppBar(
        backgroundColor: _themeColor,
        elevation: 0, // ลบเงาใต้ Appbar
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // ใช้สำหรับย้อนกลับ
          },
        ),
        title: const Text(
          'เปลี่ยนภาษา',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: false, // จัด Title ชิดซ้ายตาม Android style
      ),
      body: Column(
        children: [
          const SizedBox(height: 10), // เว้นระยะห่างนิดหน่อยจาก Appbar
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
                child: Column(
                  children: [
                    // ตัวเลือกที่ 1: English
                    _buildLanguageItem(
                      label: 'English',
                      isSelected: _selectedLanguage == 'English',
                      onTap: () {
                        setState(() {
                          _selectedLanguage = 'English';
                        });
                      },
                    ),
                    
                    const SizedBox(height: 8), // ระยะห่างระหว่างปุ่ม

                    // ตัวเลือกที่ 2: Thailand
                    _buildLanguageItem(
                      label: 'Thailand',
                      isSelected: _selectedLanguage == 'Thailand',
                      onTap: () {
                        setState(() {
                          _selectedLanguage = 'Thailand';
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget สร้างรายการภาษาแต่ละบรรทัด
  Widget _buildLanguageItem({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: isSelected ? _themeColor : Colors.transparent, // ถ้าเลือกให้พื้นหลังส้ม
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87, // รูปต้นฉบับตัวหนังสือสีดำทั้งคู่
              ),
            ),
            // ส่วนแสดง Icon
            isSelected
                ? Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.check_circle,
                      color: Colors.white,
                      size: 28,
                    ),
                  )
                : Icon(
                    Icons.circle,
                    color: Colors.grey[400], // สีเทาสำหรับตัวที่ไม่ได้เลือก
                    size: 28,
                  ),
          ],
        ),
      ),
    );
  }
}