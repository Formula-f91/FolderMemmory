import 'package:flutter/material.dart';
import 'package:wememmory/constants.dart';

class CouponPage extends StatelessWidget {
  const CouponPage({super.key});

  @override
  Widget build(BuildContext context) {
    const orange = Color(0xFFEE743B);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: kBackgroundColor, // ส้มด้านบน
        appBar: AppBar(
          backgroundColor: kBackgroundColor,
          elevation: 0,
          centerTitle: false,
          titleSpacing: 0,
          leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
          title: const Text('โค้ดส่วนลดของฉัน', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
        ),
        body: Column(
          children: [
            // แผงโค้งมุมสีขาวด้านล่าง AppBar
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(18))),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Column(
                children: [
                  // แท็บหัวข้อ
                  TabBar(
                    isScrollable: true,
                    indicatorColor: orange,
                    indicatorWeight: 3,
                    labelPadding: const EdgeInsets.symmetric(horizontal: 8),
                    labelColor: orange,
                    unselectedLabelColor: Color(0xFF9E9E9E),
                    labelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14.5),
                    unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14.5),
                    tabs: const [Tab(text: 'โค้ดส่วนลดของฉัน'), Tab(text: 'โค้ดที่ใช้ไปแล้ว')],
                  ),
                ],
              ),
            ),

            // เนื้อหา 2 แท็บ
            Expanded(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: TabBarView(
                  children: [
                    // แท็บซ้าย: โค้ดใช้งานได้
                    ListView.separated(
                      itemCount: 6,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder:
                          (_, i) => const _CouponCard(
                            title: 'โค้ดส่วนลด',
                            desc: 'ส่วนลดเมื่อซื้ออัลบั้มรูปแรก\nเมื่อสั่งขั้นต่ำ 990฿',
                            dateText: '10 มกราคม 2569',
                            disabled: false,
                          ),
                    ),
                    // แท็บขวา: โค้ดที่ใช้แล้ว (สีจาง/เทา)
                    ListView.separated(
                      itemCount: 6,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder:
                          (_, i) => const _CouponCard(
                            title: 'โค้ดส่วนลด',
                            desc: 'ส่วนลดเมื่อซื้ออัลบั้มรูปแรก\nเมื่อสั่งขั้นต่ำ 990฿',
                            dateText: '10 มกราคม 2569',
                            disabled: true,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------------- Coupon Card -------------------------

class _CouponCard extends StatelessWidget {
  const _CouponCard({required this.title, required this.desc, required this.dateText, required this.disabled});

  final String title;
  final String desc;
  final String dateText;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    const orange = Color(0xFFF29C64);
    final borderColor = disabled ? const Color(0xFFE3E3E3) : orange;
    final titleColor = disabled ? const Color(0xFFB7B7B7) : Colors.black87;
    final descColor = disabled ? const Color(0xFFCECECE) : const Color(0xFF5F5F5F);
    final dateColor = disabled ? const Color(0xFFB7B7B7) : const Color(0xFF8B8B8B);
    final dashColor = disabled ? const Color(0xFFE1E1E1) : const Color(0xFFE8B794);

    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: borderColor, width: 1)),
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // หัว + วันที่
          Row(
            children: [
              Expanded(child: Text(title, style: TextStyle(color: titleColor, fontSize: 16, fontWeight: FontWeight.w800))),
              Text(dateText, style: TextStyle(color: dateColor, fontSize: 12.5, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 6),

          // เส้นประคั่นใต้หัวข้อ
          CustomPaint(painter: _DashedLinePainter(color: dashColor), child: const SizedBox(height: 1, width: double.infinity)),
          const SizedBox(height: 8),

          // รายละเอียด
          Text(desc, style: TextStyle(color: descColor, fontSize: 13.5, height: 1.35, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

// ------------------------- Dashed Line Painter -------------------------

class _DashedLinePainter extends CustomPainter {
  _DashedLinePainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    const dashWidth = 6.0;
    const dashSpace = 4.0;
    double startX = 0;
    final paint =
        Paint()
          ..color = color
          ..strokeWidth = 1
          ..style = PaintingStyle.stroke;

    while (startX < size.width) {
      final endX = (startX + dashWidth).clamp(0, size.width).toDouble(); // ✅ แปลงเป็น double
      canvas.drawLine(Offset(startX, 0), Offset(endX, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant _DashedLinePainter oldDelegate) => oldDelegate.color != color;
}
