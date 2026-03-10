import 'package:flutter/material.dart';

// --- Palette สี ---
const Color _sidebarOrange = Color(0xFFF8B887); 
const Color _bgWhite = Colors.white; 
const Color _cardTeal = Color(0xFF6DA5B8); 
const Color _cardOrange = Color(0xFFEE743B);
const Color _cardLightOrange = Color(0xFFF8B887);
const Color _cardpurple = Color(0xFF8898F0);

class AchievementLayout extends StatelessWidget {
  const AchievementLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _sidebarOrange,
      child: Stack(
        children: [
          // 1. Layer พื้นหลังสีขาว
          Positioned.fill(
            child: Container(
              margin: const EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 0.0),
              decoration: const BoxDecoration(
                color: _bgWhite,
                borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
              ),
            ),
          ),

          // 2. Layer เนื้อหา
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(34.0, 3.0, 0.0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 50.0, right: 24.0),
                    child: _HeaderSection(),
                  ),
                  const SizedBox(height: 30),

                  // ส่วน Cards
                  const Column(
                    children: [
                      // เดือนเมษายน (สี Teal เดิม)
                      TimelineItem(
                        monthTitle: 'Apr', // ชื่อเดือนภาษาอังกฤษ
                        mainText: 'แชร์รูปภาพ 20 ครั้ง',
                        subText: 'แชร์รูปภาพมากที่สุดในปีนี้',
                        imagePath: 'assets/icons/shareLogo.png',
                        imgWidth: 67,
                        imgHeight: 57,
                        cardColor: _cardTeal, // กำหนดสีการ์ด
                      ),
                      // เดือนมีนาคม (สีส้ม)
                      TimelineItem(
                        monthTitle: 'Mar',
                        mainText: 'ใช้เวลา 5.47นาที',
                        subText: 'ในการสร้างอัลบั้มเดือนนี้เร็วที่สุด',
                        imagePath: 'assets/icons/limiter.png',
                        imgWidth: 82,
                        imgHeight: 76,
                        cardColor: _cardOrange, // เปลี่ยนเป็นสีส้ม
                      ),
                      // เดือนกุมภาพันธ์
                      TimelineItem(
                        monthTitle: 'Feb',
                        mainText: 'อธิบายภาพในเดือนนี้',
                        subText: 'บันทึกเรื่องราวของเดือนนี้มากที่สุด',
                        imagePath: 'assets/icons/76p.png',
                        imgWidth: 92,
                        imgHeight: 92,
                        isFill: true,
                        cardColor: _cardLightOrange,
                      ),
                      // เดือนมกราคม
                      TimelineItem(
                        monthTitle: 'Jan',
                        mainText: 'ความทรงจำครั้งแรก',
                        subText: 'สร้างความทรงจำครั้งแรก',
                        imagePath: 'assets/icons/bookp.png',
                        imgWidth: 76,
                        imgHeight: 98,
                        cardColor: _cardpurple,
                      ),
                    ],
                  ),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ... _HeaderSection (คงเดิม) ...
class _HeaderSection extends StatelessWidget {
  const _HeaderSection();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icons/wemoryv2.png',
              height: 103,
              width: 154,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 70.0), // ปรับค่าตรงนี้เพื่อเลื่อน Text ลงมา
              child: Text(
                "Beginner",
                style: const TextStyle(
                  color: Color(0xFFEE743B),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------
// 📌 2. Timeline Item Structure (Updated)
// -----------------------------------------------------------------
class TimelineItem extends StatelessWidget {
  final String monthTitle; // ชื่อเดือนตัวใหญ่ (Ex: Mar)
  final String mainText;
  final String subText;
  final String imagePath;
  final double imgWidth;
  final double imgHeight;
  final bool isFill;
  final Color cardColor; // สีพื้นหลังการ์ด

  const TimelineItem({
    super.key,
    required this.monthTitle,
    required this.mainText,
    required this.subText,
    required this.imagePath,
    required this.imgWidth,
    required this.imgHeight,
    this.isFill = false,
    this.cardColor = _cardTeal, // Default color
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: _DetailCard(
        monthTitle: monthTitle,
        mainText: mainText,
        subText: subText,
        imagePath: imagePath,
        imgWidth: imgWidth,
        imgHeight: imgHeight,
        isFill: isFill,
        cardColor: cardColor,
      ),
    );
  }
}

// -----------------------------------------------------------------
// 📌 3. Detail Card UI (Updated Layout)
// -----------------------------------------------------------------
class _DetailCard extends StatelessWidget {
  final String monthTitle;
  final String mainText;
  final String subText;
  final String imagePath;
  final double imgWidth;
  final double imgHeight;
  final bool isFill;
  final Color cardColor;

  const _DetailCard({
    required this.monthTitle,
    required this.mainText,
    required this.subText,
    required this.imagePath,
    required this.imgWidth,
    required this.imgHeight,
    required this.isFill,
    required this.cardColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 143,
      decoration: BoxDecoration(
        color: cardColor, // ใช้สีที่ส่งมา
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(0),
          bottomLeft: Radius.circular(0),
          topRight: Radius.circular(0),
          bottomRight: Radius.circular(0),
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // 1. Month Title (ตัวหนังสือจางๆ ด้านหลัง)
          Positioned(
            top: 8,
            left: 20,
            child: Text(
              monthTitle,
              style: TextStyle(
                color: Colors.white.withOpacity(0.3), // สีจางๆ
                fontSize: 60,
                fontWeight: FontWeight.bold,
                height: 1.0,
              ),
            ),
          ),
          
          // 2. Main Content (ข้อความหลัก)
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 80,top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 30), // เว้นที่ให้ Title ด้านบนนิดนึง
                Text(
                  mainText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  subText,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                    fontWeight: FontWeight.w300, // ปรับน้ำหนักให้บางลงนิดหน่อยตามภาพ
                  ),
                ),
              ],
            ),
          ),

          // 3. Icon ด้านขวา
          Positioned(
            right: 18,
            top: 0,
            bottom: 0,
            child: Center(
              child: Image.asset(
                imagePath,
                width: imgWidth,
                height: imgHeight,
                fit: isFill ? BoxFit.fill : BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.broken_image, color: Colors.white, size: 50);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}