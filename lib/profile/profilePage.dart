import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wememmory/profile/albumDetailPage.dart';
import 'package:wememmory/profile/historyPayment.dart';
import 'package:wememmory/profile/membershipPackage.dart';
import 'package:wememmory/profile/couponPage.dart';
import 'package:wememmory/profile/personalSecurityPage.dart';
import 'package:wememmory/shop/addressSelectionPage.dart';
import 'package:wememmory/profile/bankInfoPage.dart';
import 'package:wememmory/profile/languagePage.dart';
import 'package:wememmory/shop/termsAndServicesPage.dart';
import 'package:wememmory/profile/benefitsPage.dart';
import 'package:wememmory/shop/faqPage.dart';
import 'widgets/index.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),
              const _HeaderSection(),
              const SizedBox(height: 24),
              const _TicketCard(),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFDF1E6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  '1 Ticket ต่อการพิมพ์รูป 1 ครั้ง (11 รูป)',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const _PointCard(),
              const SizedBox(height: 16),

              // =========================================================
              // ✅ ส่วน Header: Logo + Beginner
              // =========================================================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Image.asset(
                    'assets/images/wemorylogo.png',
                    height: 80,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const SizedBox(
                      width: 50,
                      height: 50,
                      child: Icon(Icons.image_not_supported, color: Colors.grey),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Text(
                      'Beginner',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFEE743B),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),
              
              // 1. กราฟ
              const _MetricBarChart(),

              const SizedBox(height: 24),

              // 2. การ์ดเรื่องราวที่น่าจดจำ (อยู่ใต้กราฟ)
              const _MemorableStoryCard(),

              const SizedBox(height: 24),

              // 3. ส่วนสถิติ (Grid สีฟ้า)
              const _UsageStatsSection(),

              const SizedBox(height: 24),
              
              // 4. สินค้าของฉัน
              const _ProductStatusCard(),

              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 10),

              // เมนู
              MenuSection(
                items: const [
                  'ส่วนลด',
                  'ข้อมูลส่วนบุคคลและความปลอดภัย',
                  'ที่อยู่ของฉัน',
                  'ข้อมูลบัญชีธนาคาร/บัตรเครดิต',
                  'ภาษา',
                  'ข้อตกลงและเงื่อนไขในการใช้บริการ',
                  'คำถามที่พบบ่อย',
                ],
                onItemTap: (item, index) {
                  switch (index) {
                    case 0:
                      Navigator.push(context, MaterialPageRoute(builder: (context) => CouponPage()));
                      break;
                    case 1:
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PersonalSecurityPage()));
                      break;
                    case 2:
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AddressSelectionPage()));
                      break;
                    case 3:
                      Navigator.push(context, MaterialPageRoute(builder: (context) => BankInfoPage()));
                      break;
                    case 4:
                      Navigator.push(context, MaterialPageRoute(builder: (context) => LanguageSelectionScreen()));
                      break;
                    case 5:
                      Navigator.push(context, MaterialPageRoute(builder: (context) => TermsAndServicesPage()));
                      break;
                    case 6:
                      Navigator.push(context, MaterialPageRoute(builder: (context) => FAQPage()));
                      break;
                  }
                },
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}

class _MemorableStoryCard extends StatelessWidget {
  const _MemorableStoryCard();

  Widget _buildStackedImages() {
    return SizedBox(
      width: 140,
      height: 160,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Transform.rotate(
            angle: -0.15,
            child: Container(
              width: 90,
              height: 110,
              margin: const EdgeInsets.only(right: 30, bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                boxShadow: [const BoxShadow(color: Colors.black12, blurRadius: 4)],
                border: Border.all(color: Colors.white, width: 3),
              ),
            ),
          ),
          Transform.rotate(
            angle: 0.1,
            child: Container(
              width: 90,
              height: 110,
              margin: const EdgeInsets.only(left: 30, bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                boxShadow: [const BoxShadow(color: Colors.black12, blurRadius: 4)],
                border: Border.all(color: Colors.white, width: 3),
              ),
            ),
          ),
          Container(
            width: 100,
            height: 130,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                const BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: Image.asset(
                      'assets/images/exProfile.png',
                      fit: BoxFit.cover,
                      errorBuilder: (c, o, s) => Container(color: Colors.grey[200]),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'อากาศดี วิวสวย',
                  style: GoogleFonts.chakraPetch(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '#ครอบครัว #ความรัก',
                  style: GoogleFonts.chakraPetch(
                    fontSize: 8,
                    color: const Color(0xFF58A3B6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5), // สีพื้นหลังเทาอ่อน
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          _buildStackedImages(),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'เรื่องราวที่น่าจดจำ',
                  style: GoogleFonts.chakraPetch(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF58A3B6),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '88',
                  style: GoogleFonts.chakraPetch(
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF58A3B6),
                    height: 1.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductStatusCard extends StatelessWidget {
  const _ProductStatusCard();
  @override
  Widget build(BuildContext context) {
    const int completed = 9;
    const int total = 10;
    const double progress = completed / total;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AlbumHistoryPage()),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFEE743B),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'สินค้าของฉัน',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 12,
                backgroundColor: const Color(0xFFD68F72),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'จัดส่งสำเร็จ $completed/$total รายการ',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: const AssetImage('assets/images/userpic.png'),
          backgroundColor: Colors.grey.shade200,
        ),
        const SizedBox(height: 12),
        const Text(
          'korakrit',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w800,
            fontSize: 22,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'รหัสผู้แนะนำ 1234',
          style: TextStyle(
            color: Color(0xFF5A5A5A),
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}

class _TicketCard extends StatelessWidget {
  const _TicketCard();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 160,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF9A675),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ticket',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w400,
                  color: const Color(0x404A4A4A),
                  height: 1.0,
                ),
              ),
              Text(
                '10',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  height: 1.0,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const MembershipPackagePage(),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE86A3E),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  icon: Image.asset(
                    'assets/icons/wallet-3.png',
                    width: 24,
                    height: 24,
                    color: Colors.white,
                  ),
                  label: Text(
                    'Buy Ticket',
                    style: GoogleFonts.prompt(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MembershipHistoryPage(
                          type: HistoryType.subscription,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  icon: const Icon(
                    Icons.history,
                    size: 20,
                    color: Colors.black87,
                  ),
                  label: Text(
                    'ดูประวัติทั้งหมด',
                    style: GoogleFonts.prompt(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PointCard extends StatelessWidget {
  const _PointCard();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 160,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF4A4A4A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Point',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w400,
                  color: Color(0x40FFFFFF),
                  height: 1.0,
                ),
              ),
              Text(
                '27',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.0,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BenefitsPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE86A3E),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  icon: Image.asset(
                    'assets/icons/wallet-3.png',
                    width: 25,
                    height: 25,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'แลกรางวัล',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MembershipHistoryPage(
                          type: HistoryType.point,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  icon: const Icon(
                    Icons.history,
                    size: 20,
                    color: Colors.black87,
                  ),
                  label: const Text(
                    'ดูประวัติทั้งหมด',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricBarChart extends StatelessWidget {
  const _MetricBarChart();
  @override
  Widget build(BuildContext context) {
    const Color barColor = Color(0xFFEE743B);
    const Color gridColor = Color(0xFFFFFFFF);
    return Container(
      height: 320,
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 100,
          barTouchData: BarTouchData(enabled: false),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            checkToShowHorizontalLine:
                (value) =>
                    value == 25 || value == 50 || value == 75 || value == 100,
            getDrawingHorizontalLine:
                (value) =>
                    FlLine(color: gridColor, strokeWidth: 1, dashArray: [5, 5]),
          ),
          titlesData: FlTitlesData(
            show: true,
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 25,
                getTitlesWidget: (value, meta) {
                  if (value == 0) return const SizedBox.shrink();
                  return Text(
                    value.toInt().toString(),
                    style: const TextStyle(color: Colors.grey, fontSize: 10),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) {
                  String text = '';
                  switch (value.toInt()) {
                    case 0:
                      text = 'ความสม่ำเสมอ';
                      break;
                    case 1:
                      text = 'ตรงตามเวลา';
                      break;
                    case 2:
                      text = 'อัพรูปครบ';
                      break;
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      text,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          barGroups: [
            _makeBarGroup(0, 50, barColor),
            _makeBarGroup(1, 25, barColor),
            _makeBarGroup(2, 25, barColor),
          ],
        ),
      ),
    );
  }

  BarChartGroupData _makeBarGroup(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 60,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
      ],
    );
  }
}

class _UsageStatsSection extends StatelessWidget {
  const _UsageStatsSection();

  TextStyle get _digitalTextStyle => GoogleFonts.orbitron(
    fontSize: 30,
    fontWeight: FontWeight.w900,
    color: Colors.white,
    letterSpacing: 1.5,
    height: 1.0,
  );

  TextStyle get _digitalDateStyle => GoogleFonts.orbitron(
    fontSize: 37,
    fontWeight: FontWeight.w900,
    color: const Color(0xFF4A4A4A),
    letterSpacing: 0.5,
    height: 1.0,
  );

  TextStyle get _headerThaiStyle => const TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    height: 1.0,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          decoration: const BoxDecoration(color: Color(0xFFF9A675)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('บันทึก', style: _headerThaiStyle),
                  const Text(
                    'ความทรงจำแรก',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('10 Jan', style: _digitalDateStyle),
                  Text('2025', style: _digitalDateStyle),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: _buildStatBlock(
                icon: Icons.calendar_month,
                title: 'เดือนที่ทำต่อเนื่อง',
                value: '7',
                isDigitalFont: true,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatBlock(
                icon: Icons.qr_code,
                title: 'จำนวนคนที่ใช้โค้ด',
                value: '10',
                isDigitalFont: true,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatBlock(
                icon: Icons.share,
                title: 'แชร์อัลบั้มทั้งหมด',
                value: '20',
                isDigitalFont: true,
                iconSize: 28,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatBlock(
                icon: Icons.speed,
                title: 'เวลาเลือกรูป(นาที)',
                value: '300.45',
                isDigitalFont: true,
                valueFontSize: 20,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          decoration: const BoxDecoration(color: Color(0xFFF9A675)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('บันทึก', style: _headerThaiStyle),
                  const Text(
                    'เรื่องราว',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Text(
                '80',
                style: GoogleFonts.orbitron(
                  fontSize: 60,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 2.0,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: _buildStatBlock(
                icon: Icons.calendar_today,
                title: 'เดือนที่ทำทั้งหมด',
                value: '8',
                isDigitalFont: true,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatBlock(
                icon: Icons.image,
                title: 'วันที่สร้างมากที่สุด',
                value: 'อาทิตย์',
                isDigitalFont: false,
                valueFontSize: 30,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatBlock({
    required IconData icon,
    required String title,
    required String value,
    bool isDigitalFont = false,
    double iconSize = 32,
    double valueFontSize = 40,
  }) {
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF58A3B6),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: iconSize),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                  textAlign: TextAlign.right,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style:
                      isDigitalFont
                          ? _digitalTextStyle.copyWith(fontSize: valueFontSize)
                          : GoogleFonts.prompt(
                            fontSize: valueFontSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}