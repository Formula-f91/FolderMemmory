import 'package:flutter/material.dart';

class ShareSheet extends StatelessWidget {
  const ShareSheet({super.key});

  @override
  Widget build(BuildContext context) {
    // คำนวณความสูงให้ได้ประมาณ 75-80% ของหน้าจอ เพื่อให้ใกล้เคียง layout ในรูปภาพ
    final double sheetHeight = MediaQuery.of(context).size.height * 0.78;

    return Container(
      height: sheetHeight, // กำหนดความสูงคงที่
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // ---------------------------------------------------------
          // Slide Indicator (แถบขีดด้านบน)
          // ---------------------------------------------------------
          const SizedBox(height: 12),
          Container(
            width: 61,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2.5),
            ),
          ),

          // 1. Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 13, 20, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'แบ่งปันอัลบั้ม',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Image.asset(
                    'assets/icons/cross.png',
                    width: 25,
                    height: 25,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF5F5F5)), // เส้นคั่นบางๆ ใต้หัวข้อ

          // 2. ส่วนเนื้อหาที่เลื่อนได้ (เพื่อให้ความสูงยืดหยุ่น)
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "affiliate",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "ข้อมูล ข้อมูล ข้อมูล ข้อมูล ข้อมูล ข้อมูล ข้อมูล ข้อมูล ข้อมูล " * 12,
                    style: const TextStyle(
                      color: Colors.black87, 
                      fontSize: 14, 
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 3. ส่วน Icon สำหรับแชร์ (Fixed ไว้ด้านล่างเพื่อให้กดง่าย)
          Container(
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 50), // ดันขึ้นจากขอบล่าง 50
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildShareItem('Facebook', 'assets/icons/shareF.png'),
                _buildShareItem('Line', 'assets/icons/shareL.png'),
                _buildShareItem('Instagram', 'assets/icons/shareIg.png'),
                _buildShareItem('Copy link', 'assets/icons/sharecopy.png'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShareItem(String label, String iconPath) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          iconPath,
          width: 44, // เพิ่มขนาดเล็กน้อยเพื่อให้กดง่ายขึ้น
          height: 44,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: Colors.black87),
            ),
            const SizedBox(width: 2),
            const Icon(Icons.workspace_premium, size: 12, color: Colors.orange),
          ],
        ),
      ],
    );
  }
}