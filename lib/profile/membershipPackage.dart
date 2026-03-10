import 'package:flutter/material.dart';
import 'package:wememmory/profile/membershipPayment.dart';            // หน้าชำระเงิน
import 'package:wememmory/profile/historyPayment.dart';  // หน้าประวัติ

class MembershipPackagePage extends StatefulWidget {
  const MembershipPackagePage({super.key});

  @override
  State<MembershipPackagePage> createState() => _MembershipPackagePageState();
}

class _MembershipPackagePageState extends State<MembershipPackagePage> {
  // ตัวแปรเก็บ index ของแพ็กเกจที่ถูกเลือก (เริ่มต้นเลือกอันแรก = 0)
  int _selectedPackageIndex = 0;

  // ข้อมูลแพ็กเกจทั้ง 3 อัน
  final List<Map<String, dynamic>> packages = [
    {
      'price': '899',
      'name': 'เริ่มต้น',
      'originalPrice': '฿299/เดือน',
      'discountText': '',
      'duration': '3 เดือนแห่งเรื่องราวสุดพิเศษ',
    },
    {
      'price': '1,599',
      'name': 'พรีเมียม',
      'originalPrice': '฿1,794',
      'discountText': 'ประหยัด ฿195',
      'duration': '6 เดือนแห่งช่วงเวลาไม่ลืม',
    },
    {
      'price': '2,999', // ราคาแพ็กเกจที่ 3
      'name': 'รายปี', // ชื่อสมมติ
      'originalPrice': '฿3,588',
      'discountText': 'ประหยัด ฿589',
      'duration': '12 เดือนคุ้มค่าที่สุด',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // -------------------------------------------------------
          // 1. ภาพพื้นหลัง (Background Image)
          // -------------------------------------------------------
            Image.asset(
                    'assets/images/membershipBackground.png',
                    height: double.infinity,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
          

          // -------------------------------------------------------
          // 2. Gradient Overlay (เงาดำเพื่อให้ตัวหนังสือชัด)
          // -------------------------------------------------------
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3), // ด้านบนจางๆ
                    Colors.black.withOpacity(0.6),
                    Colors.black.withOpacity(0.95), // ด้านล่างดำสนิท
                    Colors.black,
                  ],
                  stops: const [0.0, 0.4, 0.7, 1.0],
                ),
              ),
            ),
          ),

          // -------------------------------------------------------
          // 3. เนื้อหาหลัก (Content)
          // -------------------------------------------------------
          SafeArea(
            child: Column(
              children: [
                // --- Top Bar (ปุ่มปิด & ปุ่มประวัติ) ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // ปุ่มปิด X (ย้อนกลับ)
                      CircleAvatar(
                        backgroundColor: Colors.white.withOpacity(0.2),
                        radius: 20,
                        child: IconButton(
                          icon: const Icon(Icons.close, color: Colors.white, size: 20),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      
                      // ปุ่มประวัติ (กดไปหน้า MembershipHistoryPage)
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MembershipHistoryPage(),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF08336), // สีส้ม
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'ประวัติ',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // --- Title & Subtitle ---
                const Text(
                  'แพ็กเกจสมาชิก',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    'เลือกแพ็กเกจที่ใช่เพื่อเก็บช่วงเวลาให้มีความหมายยิ่งขึ้น',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ),

                const Spacer(), // ดันเนื้อหาด้านล่างลงไป

                // --- Feature List (รายการสิทธิประโยชน์) ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      _buildFeatureItem('สิทธิที่ได้รับ'),
                      _buildFeatureItem('สิทธิที่ได้รับ'),
                      _buildFeatureItem('สิทธิที่ได้รับ'),
                      _buildFeatureItem('สิทธิที่ได้รับ'),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // --- Horizontal Package Selector (ส่วนเลือกแพ็กเกจ) ---
                SizedBox(
                  height: 140, 
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    scrollDirection: Axis.horizontal, // ✅ เลื่อนแนวนอน
                    itemCount: packages.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final item = packages[index];
                      final isSelected = _selectedPackageIndex == index;
                      
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedPackageIndex = index;
                          });
                        },
                        child: Container(
                          width: 260, // ความกว้างการ์ด
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E1E1E), // สีพื้นหลังการ์ด (เทาเข้ม)
                            borderRadius: BorderRadius.circular(12),
                            border: isSelected
                                ? Border.all(color: const Color(0xFFF08336), width: 2) // สีส้มถ้าเลือก
                                : Border.all(color: Colors.white12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // แถวบน: ราคา และ ชื่อแพ็กเกจ
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '฿${item['price']}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    item['name'],
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              
                              // แถวกลาง: ราคาเดิม และ ส่วนลด
                              Row(
                                children: [
                                  Text(
                                    item['originalPrice'],
                                    style: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontSize: 12,
                                      decoration: TextDecoration.lineThrough,
                                      decorationColor: Colors.grey.shade500,
                                    ),
                                  ),
                                  if (item['discountText'] != '') ...[
                                    const SizedBox(width: 8),
                                    Text(
                                      item['discountText'],
                                      style: TextStyle(
                                        color: Colors.grey.shade400,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ]
                                ],
                              ),

                              // แถวล่าง: ระยะเวลา
                              Text(
                                item['duration'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 24),

                // --- Confirm Button (ปุ่มยืนยัน) ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  child: SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        // 1. ดึงข้อมูลแพ็กเกจที่เลือกอยู่ปัจจุบัน
                        final selectedPackage = packages[_selectedPackageIndex];

                        // 2. ส่งข้อมูลไปหน้าชำระเงิน (PaymentPage)
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PaymentPage(
                              // ส่งชื่อแพ็กเกจ เช่น "แพ็กเกจพรีเมียม"
                              packageName: 'แพ็กเกจ${selectedPackage['name']}', 
                              // ส่งราคา เช่น "1,599"
                              price: selectedPackage['price'],
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF08336), // สีส้ม
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'ยืนยัน',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget ย่อยสำหรับรายการสิทธิประโยชน์
  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const Icon(Icons.check, color: Color(0xFFF08336), size: 20), // ติ๊กถูกสีส้ม
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}