import 'package:flutter/material.dart';
import 'package:wememmory/home/firstPage.dart';
import 'package:wememmory/login/memeship_login.dart'; // import ปลายทางถัดไป (ถ้ามี) หรือหน้า Home

class UsernamePage extends StatefulWidget {
  const UsernamePage({super.key});

  @override
  State<UsernamePage> createState() => _UsernamePageState();
}

class _UsernamePageState extends State<UsernamePage> {
  final TextEditingController _usernameController = TextEditingController();

  // กำหนดสีและค่าคงที่
  static const Color _bgCream = Color(0xFFF4F6F8);
  static const Color _primaryOrange = Color(0xFFE18253);
  static const double _radius = 14;

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final insetTop = MediaQuery.of(context).padding.top;
    const double bannerHeight = 380;
    final double cardSidePadding = size.width * 0.06;

    return Scaffold(
      backgroundColor: _bgCream,
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // 🔹 ส่วนที่ 1: แบนเนอร์ด้านบน
              Stack(
                children: [
                  SizedBox(
                    height: bannerHeight,
                    width: double.infinity,
                    child: Image.asset(
                      'assets/images/Hobby.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                  // โลโก้ WEMORY
                  Positioned(
                    left: size.width * 0.18,
                    top: insetTop + 12,
                    child: Image.asset(
                      'assets/images/image2.png',
                      height: 40,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),

              // 🔹 ส่วนที่ 2: การ์ดกรอกชื่อผู้ใช้งาน
              Transform.translate(
                offset: const Offset(0, -58),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: cardSidePadding),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(18, 24, 18, 30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(_radius),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x1F000000),
                          blurRadius: 16,
                          offset: Offset(0, 8),
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // หัวข้อ "ชื่อผู้ใช้งาน"
                        const Text(
                          'ชื่อผู้ใช้งาน',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500, // ปรับน้ำหนักตัวอักษรให้ดูคล้ายภาพ
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // ช่องกรอกชื่อผู้ใช้งาน
                        TextField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            hintText: 'กรอกชื่อผู้ใช้งาน',
                            hintStyle: TextStyle(color: Colors.grey.shade400),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4), // ขอบมนเล็กน้อยตามภาพ
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: const BorderSide(color: _primaryOrange),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // ปุ่มยืนยัน
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _primaryOrange,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero), // ปุ่มเหลี่ยมมนเล็กน้อยตามภาพ
                              elevation: 0,
                            ),
                            onPressed: () {
                              // ไปหน้าถัดไป (เช่น หน้า Home / FirstPage)
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MembershipPage()),
                              );
                            },
                            child: const Text(
                              'ยืนยัน',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}