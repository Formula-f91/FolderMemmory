import 'package:flutter/material.dart';
import 'package:wememmory/collection/collectionPage.dart';
import 'package:wememmory/home/firstPage.dart';
import 'package:wememmory/models/media_item.dart';

// หน้า สำเร็จการสั่ง print
class OrderSuccessPage extends StatelessWidget {
  final List<MediaItem> items; //รับภาพจาก order_success_page.dart
  final String monthName; //รับชื่อเดือนมาจาก print_sheet.dart

  const OrderSuccessPage({
    super.key,
    required this.items,
    required this.monthName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 1), // ดันเนื้อหาลงมาตรงกลาง

            Image.asset(
              'assets/icons/Success.png',
              width: 180, 
              height: 180,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.check_circle, size: 100, color: Colors.green);
              },
            ),

            const SizedBox(height: 10),

            
            const Text(
              '100 คะแนน',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 24),

            // Achievement List (รายการข้อความ)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  _buildAchievementItem('ความสม่ำเสมอของการสร้างอัลบั้มในแต่ละปี'),
                  const SizedBox(height: 8),
                  _buildAchievementItem('สร้างอัลบั้มรูปครบ 18 รูป'),
                  const SizedBox(height: 8),
                  _buildAchievementItem('สร้างอัลบั้มรูปตรงตามเวลาที่กำหนด'),
                ],
              ),
            ),

            const SizedBox(height: 30),
            
            // เส้นขีดคั่น
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Divider(thickness: 1, color: Color(0xFFEEEEEE)),
            ),
            
            const SizedBox(height: 30),

            // Badges (วงกลมเช็คชื่อ)
            // แถวที่ 1
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildBadge(status: _BadgeStatus.success), // สีส้ม (ถูก)
                const SizedBox(width: 12),
                _buildBadge(status: _BadgeStatus.fail),    // สีฟ้า (ผิด)
                const SizedBox(width: 12),
                _buildBadge(status: _BadgeStatus.empty),   // สีเทา
                const SizedBox(width: 12),
                _buildBadge(status: _BadgeStatus.empty),
                const SizedBox(width: 12),
                _buildBadge(status: _BadgeStatus.empty),
              ],
            ),
            const SizedBox(height: 16),
            // แถวที่ 2
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildBadge(status: _BadgeStatus.empty),
                const SizedBox(width: 12),
                _buildBadge(status: _BadgeStatus.empty),
                const SizedBox(width: 12),
                _buildBadge(status: _BadgeStatus.empty),
                const SizedBox(width: 12),
                _buildBadge(status: _BadgeStatus.empty),
                const SizedBox(width: 12),
                _buildBadge(status: _BadgeStatus.empty),
              ],
            ),

            // ✅ ปรับระยะห่างตรงนี้ให้น้อยลง เพื่อขยับปุ่มขึ้นข้างบน
            const Spacer(flex: 1), // ลดจาก flex: 2 เหลือ flex: 1

            // ปุ่มยืนยัน
            Padding(
              // ปรับ Padding bottom เล็กน้อย
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 30), 
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FirstPage(
                          initialIndex: 1, 
                          newAlbumItems: items,
                          newAlbumMonth: monthName,
                        ),
                      ),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFED7D31), // สีส้มตาม Theme
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0), 
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'ยืนยัน',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget สร้างรายการข้อความ +
  Widget _buildAchievementItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('+ ', style: TextStyle(color: Colors.grey, fontSize: 14)),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
        ),
      ],
    );
  }

  // Widget สร้างวงกลม Badge
  Widget _buildBadge({required _BadgeStatus status}) {
    Color bgColor;
    Widget? icon;
    switch (status) {
      case _BadgeStatus.success:
        bgColor = const Color(0xFFED7D31); // สีส้ม
        // ✅ ใช้ Text เพื่อทำให้สัญลักษณ์หนาขึ้น
        icon = const Text(
          '✓', 
          style: TextStyle(
            color: Colors.white, 
            fontSize: 28, 
            fontWeight: FontWeight.w900 // หนาพิเศษ
          )
        );
        break;
      case _BadgeStatus.fail:
        bgColor = const Color(0xFF67A5BA); // สีฟ้า
        // ✅ ใช้ Text เพื่อทำให้สัญลักษณ์หนาขึ้น
        icon = const Text(
          '✕', 
          style: TextStyle(
            color: Colors.white, 
            fontSize: 24, 
            fontWeight: FontWeight.w900 // หนาพิเศษ
          )
        );
        break;
      case _BadgeStatus.empty:
        bgColor = const Color(0xFFEEEEEE); // สีเทา
        icon = null;
        break;
    }
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
      ),
      child: icon != null ? Center(child: icon) : null,
    );
  }
}

enum _BadgeStatus { success, fail, empty }