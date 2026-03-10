import 'dart:typed_data';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:wememmory/collection/FanStackDetailPage.dart';
import 'package:wememmory/collection/MemorySlidePage.dart';
import 'package:wememmory/collection/share_sheet.dart';
import 'package:wememmory/models/media_item.dart';

// หน้า รายละเอียดแฟ้มภาพแต่ละเดือน
class MonthDetailPage extends StatelessWidget {
  final String monthName;
  final List<MediaItem> items;

  const MonthDetailPage({
    super.key,
    required this.monthName,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    MediaItem? bgItem;
    if (items.isNotEmpty) {
      bgItem = items[Random().nextInt(items.length)];
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------------------------------------------------------
            // 1. Header Stack (คงเดิม)
            // ---------------------------------------------------------
            Stack(
              children: [
                Container(
                  height: 250,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF8E8E8E), Color(0xFF4A4A4A)],
                    ),
                  ),
                  child: bgItem != null
                      ? FutureBuilder<Uint8List?>(
                          future: bgItem.capturedImage != null
                              ? Future.value(bgItem.capturedImage)
                              : bgItem.asset.thumbnailDataWithSize(
                                  const ThumbnailSize(800, 800),
                                ),
                          builder: (context, snapshot) {
                            if (snapshot.hasData && snapshot.data != null) {
                              return Image.memory(
                                snapshot.data!,
                                fit: BoxFit.cover,
                                color: Colors.black.withOpacity(0.3),
                                colorBlendMode: BlendMode.darken,
                              );
                            }
                            return Container();
                          },
                        )
                      : Container(),
                ),
                Positioned(
                  top: 50,
                  left: 16,
                  right: 16,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 28,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 28,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 60,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      Text(
                        monthName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              blurRadius: 4,
                              color: Colors.black45,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "เก็บเรื่องราวกับครอบครัว",
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // 2. Action Buttons & Status (ส่วนนี้เพิ่มเข้ามาเพื่อให้ Layout สมบูรณ์ตามภาพเดิม)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "พิมพ์แล้ว 2 ครั้ง",
                    style: TextStyle(color: Color(0xFF67A5BA), fontSize: 14),
                  ),
                  Row(
                    children: [
                      _buildIconButton('assets/icons/print.png'),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true, // เพื่อให้ความสูงเป็นไปตามที่เรากำหนดใน ShareSheet
                            backgroundColor: Colors.transparent,
                            builder: (context) => const ShareSheet(),
                          );
                        },
                        child: _buildIconButton('assets/icons/share.png'),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ---------------------------------------------------------
            // 3. Album Layout (คงเดิม)
            // ---------------------------------------------------------
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _buildFullAlbumPreview(),
              ),
            ),

            const SizedBox(height: 40),

            // ---------------------------------------------------------
            // 4. Bottom Cards (คงเดิม)
            // ---------------------------------------------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                children: [
                  // --- Row 1: Cards ---
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ✅ Card 1: Polaroid Stack
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MemorySlidePage(
                                  monthName: monthName,
                                  items: items,
                                ),
                              ),
                            );
                          },
                          child: _buildPolaroidStack(),
                        ),
                      ),
                      
                      const SizedBox(width: 20),
                      
                      // ✅ Card 2: Fan Image Stack
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FanStackDetailPage(
                                  monthName: monthName,
                                  items: items,
                                ),
                              ),
                            );
                          },
                          child: _buildFanImageStack(),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // --- Row 2: Headers ---
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left: แท็กทั้งหมด
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                             Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MemorySlidePage(
                                  monthName: monthName,
                                  items: items,
                                ),
                              ),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "แท็กทั้งหมด",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                "#ครอบครัว #ความรัก #ความรัก ...",
                                style: TextStyle(
                                  color: Color(0xFFED7D31),
                                  fontSize: 12,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      // Right: การแชร์ของเดือนนี้
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "การแชร์ของเดือนนี้",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              "ผู้ที่เข้าชม 23+",
                              style: TextStyle(
                                color: Colors.grey, 
                                fontSize: 12
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 60),

            // ---------------------------------------------------------
            // 5. ✅ NEW SECTION: Stats & Charts (จากภาพ ส่วนด้านล่าง.jpg)
            // ---------------------------------------------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: _buildBottomStatsSection(),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Helper Methods: Bottom Stats Section
  // ---------------------------------------------------------------------------
  Widget _buildBottomStatsSection() {
    return Column(
      children: [
        // 1. Card: ต่อเนื่อง 4 เดือน
        Container(
          // padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Row(
            children: [
              // ใช้รูป Icon ไฟจาก Assets
              Image.asset(
                'assets/icons/MainFlame.png',
                width: 128,
                height: 128,
                fit: BoxFit.contain,
              ),
              // const SizedBox(width: 2),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("ต่อเนื่อง 4 เดือน", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 36)),
                  Text("สร้างอัลบั้มต่อเนื่องมาแล้ว 4 เดือนติด", style: TextStyle(color: Colors.grey, fontSize: 14)),
                ],
              )
            ],
          ),
        ),
        const SizedBox(height: 14),

        // 2. Card: ทุกภาพมีเรื่องเล่า
        Container(
          width: 373,
          height: 113,
          padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2)),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("ทุกภาพมีเรื่องเล่าของตัวเอง", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  Text("คุณได้อธิบายภาพในเดือนนี้", style: TextStyle(color: Colors.grey, fontSize: 16)),
                ],
              ),
              // Circular Progress (76%)
              Stack(
                alignment: Alignment.center,
                children: [
                  const SizedBox(
                    width: 68, height: 68,
                    child: CircularProgressIndicator(
                      value: 0.76,
                      backgroundColor: Color(0xFFE0E0E0),
                      color: Color(0xFF67A5BA),
                      strokeWidth: 6,
                    ),
                  ),
                  const Text("76%", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),

        // 3. Card: Bar Chart (ความสม่ำเสมอ)
        Container(
          width: 362,
          height: 318,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(color: Colors.grey.shade100),
          ),
          child: Stack(
            children: [
              // --- Background Grid Lines (เส้นประ) ---
              Column(
                // กระจายเส้นให้เต็มความสูงพื้นที่กราฟ
                children: [
                  // เว้นที่ด้านบนเล็กน้อย
                  const SizedBox(height: 2), 
                  _buildDashedGridLine(label: "100"),
                  const Spacer(),
                  _buildDashedGridLine(label: "50"),
                  const Spacer(),
                  _buildDashedGridLine(label: "25"),
                  const Spacer(),
                  _buildDashedGridLine(label: "0"),
                  // เว้นที่ด้านล่างสำหรับ Label แกน X
                  const SizedBox(height: 20), 
                ],
              ),
              
              // --- Bars ---
              Padding(
                padding: const EdgeInsets.only(bottom: 0, left: 25), // เว้นซ้ายให้แกน Y
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // แท่งที่ 1: ความสม่ำเสมอ (สูง 160)
                    _buildFixedBar(height: 160, label: "ความสม่ำเสมอ", color: const Color(0xFFED7D31)),
                    // แท่งที่ 2: ตรงตามเวลา (สูง 86)
                    _buildFixedBar(height: 86, label: "ตรงตามเวลา", color: const Color(0xFFED7D31)),
                    // แท่งที่ 3: อัพรูปครบ (สูง 86)
                    _buildFixedBar(height: 86, label: "อัพรูปครบ", color: const Color(0xFFED7D31)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // 4. Card: เวลาในการสร้างอัลบั้ม (Gauge)
        Container(
          width: 373,
          height: 211,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            // เพิ่มเงาให้เหมือนการ์ดอื่น
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
            // border: Border.all(color: Colors.grey.shade100), // ใส่หรือไม่ใส่ก็ได้ตามชอบ
          ),
          child: Column(
            children: [
              // ส่วนบน: ข้อมูลเวลา และ Gauge Chart
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // --- ฝั่งซ้าย: Text ข้อมูล ---
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "เวลาในการสร้างอัลบั้ม",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "15.00 นาที",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24, // เพิ่มขนาดตัวเลขให้ใหญ่ชัดเจน
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.only(top: 8), // เส้นขีดคั่น
                        decoration: const BoxDecoration(
                          border: Border(top: BorderSide(color: Color(0xFFEEEEEE), width: 1)),
                        ),
                        child: const Text(
                          "สูงสุด 30.00 นาที",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  // --- ฝั่งขวา: Gauge Chart ---
                  SizedBox(
                    width: 120, // ปรับขนาดให้เหมาะสม
                    height: 60, // ครึ่งวงกลม สูงครึ่งหนึ่งของกว้าง
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        // 1. Background Arc (สีครีม - เต็มวง)
                        Container(
                          width: 120,
                          height: 60,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFFF0E0), // สีครีมอ่อนๆ
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(60),
                              topRight: Radius.circular(60),
                            ),
                          ),
                        ),
                        // 2. Active Arc (สีส้ม - ครึ่งซ้าย)
                        Positioned(
                          left: 0,
                          child: Container(
                            width: 60, // ครึ่งหนึ่งของ width รวม
                            height: 60,
                            decoration: const BoxDecoration(
                              color: Color(0xFFED7D31), // สีส้มเข้ม
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(60),
                                topRight: Radius.circular(0),
                              ),
                            ),
                          ),
                        ),
                        // 3. Inner White Circle (เพื่อทำเป็นโดนัท)
                        Container(
                          width: 80, // เล็กกว่าวงนอก (120-80 = ขอบหนา 20px)
                          height: 40,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40),
                            ),
                          ),
                        ),
                        // 4. Text ตรงกลาง Gauge
                        const Positioned(
                          bottom: 0,
                          child: Text(
                            "15.00 นาที",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // ส่วนล่าง: ข้อความสรุป
              const Text(
                "เร็วกว่าค่าเฉลี่ย 15.00 นาที",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 20),

        // 5. Card: Donut Chart (สร้างอัลบั้มวันที่ 1)
        Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // ใช้รูปภาพแทน Stack ของ CircularProgressIndicator
              SizedBox(
                width: 235, 
                height: 235,
                child: Image.asset(
                  'assets/icons/Frame 25.png', // path รูปภาพ
                  fit: BoxFit.contain, // ปรับขนาดให้พอดี
                ),
              ),
              
              const SizedBox(height: 20),
              const Text(
                "สร้างอัลบั้มวันที่ 1", 
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40)
              ),
              const SizedBox(height: 20),
              const Text(
                "คุณสร้างอัลบั้มวันที่ 1 มากถึง 54%", 
                style: TextStyle(color: Colors.grey, fontSize: 20, fontWeight: FontWeight.w800)
              ),
              const SizedBox(height: 50),
              
              // Legend (คงเดิม)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLegendItem("วันที่ 10", const Color(0xFFF4B400)),
                  const SizedBox(width: 60),
                  _buildLegendItem("วันที่ 1", Colors.black87),
                  const SizedBox(width: 60),
                  _buildLegendItem("วันที่ 5", const Color(0xFF67A5BA)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  // เส้นประกราฟ
  Widget _buildDashedGridLine({required String label}) {
    return Row(
      children: [
        SizedBox(
          width: 25,
          child: Text(
            label,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
            textAlign: TextAlign.right,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              const dashWidth = 4.0;
              const dashSpace = 4.0;
              final dashCount = (constraints.constrainWidth() / (dashWidth + dashSpace)).floor();
              return Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(dashCount, (_) {
                  return SizedBox(
                    width: dashWidth,
                    height: 1,
                    child: DecoratedBox(
                      decoration: BoxDecoration(color: Colors.grey.shade300),
                    ),
                  );
                }),
              );
            },
          ),
        ),
      ],
    );
  }

  

  // สร้างแท่งกราฟแบบกำหนดความสูง (Fixed Height)
  Widget _buildFixedBar({required double height, required String label, required Color color}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 59, // ความกว้าง 59 ตามสเปค
          height: height, // ความสูงตามที่กำหนด (160, 86)
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(height: 12), // ระยะห่างแท่งกับตัวหนังสือ
        Text(
          label,
          style: const TextStyle(
            fontSize: 12, // เพิ่มขนาดตัวอักษรเล็กน้อยให้อ่านง่าย
            fontWeight: FontWeight.bold,
            color: Colors.black87
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(width: 16, height: 16, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 10),
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Helper Methods เดิม (คงไว้)
  // ---------------------------------------------------------------------------

  Widget _buildPolaroidStack() {
    final mainItem = items.isNotEmpty ? items[0] : null;
    const double cardWidth = 120; 
    const double cardHeight = 154; 

    return SizedBox(
      height: 200, 
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 7,
            top: 22,
            child: Transform.rotate(
              angle: -0.13,
              child: _buildPolaroidCard(width: cardWidth, height: cardHeight),
            ),
          ),
          Positioned(
            right: 12,
            top: 20,
            child: Transform.rotate(
              angle: 0.2,
              child: _buildPolaroidCard(width: cardWidth, height: cardHeight),
            ),
          ),
          Container(
            width: cardWidth,
            height: cardHeight,
            padding: const EdgeInsets.fromLTRB(17, 17, 17, 6),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 10, offset: const Offset(0, 4)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 1.0, 
                  child: mainItem != null
                      ? _buildImage(mainItem)
                      : Container(color: Colors.grey[200]),
                ),
                const Spacer(),
                const Text(
                  "อากาศดี วิวสวย",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Colors.black87),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                const Text(
                  "#ครอบครัว #ความรัก",
                  style: TextStyle(fontSize: 10, color: Color(0xFF67A5BA)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4), 
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPolaroidCard({required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
        border: Border.all(color: Colors.grey.shade200),
      ),
    );
  }

  Widget _buildFanImageStack() {
    final displayItems = items.take(4).toList();
    return SizedBox(
      height: 150,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          for (int i = 0; i < displayItems.length; i++)
            _buildFanItem(displayItems[i], index: i),
        ],
      ),
    );
  }

  Widget _buildFanItem(MediaItem item, {required int index}) {
    const double cardWidth = 92.0;
    const double cardHeight = 80.0;
    List<double> rotations = [0.08, -0.1, 0.08, -0.1];
    double angle = (index < rotations.length) ? rotations[index] : 0.0;
    double leftOffset = index * 20.0; 

    return Positioned(
      left: leftOffset + 8,
      top: 60,
      child: Transform.rotate(
        angle: angle,
        child: Container(
          width: cardWidth,
          height: cardHeight,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white, width: 1),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: _buildImage(item),
          ),
        ),
      ),
    );
  }

  Widget _buildFullAlbumPreview() {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(color: Color(0xFF555555)),
        child: IntrinsicWidth(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPageContainer(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 3,
                  mainAxisSpacing: 3,
                  childAspectRatio: 1.0,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  children: [
                    Container(
                      decoration: const BoxDecoration(color: Colors.white),
                      child: Center(
                        child: Text(
                          monthName.split(' ')[0],
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    for (int i = 0; i < 5; i++)
                      if (i < items.length)
                        _StaticPhotoSlot(item: items[i])
                      else
                        const SizedBox(),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              _buildPageContainer(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 3,
                  mainAxisSpacing: 3,
                  childAspectRatio: 1.0,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  children: [
                    for (int i = 0; i < 6; i++)
                      if ((i + 5) < items.length)
                        _StaticPhotoSlot(item: items[i + 5])
                      else
                        const SizedBox(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPageContainer({required Widget child}) {
    return SizedBox(width: 160, height: 245, child: child);
  }

  Widget _buildIconButton(String iconPath) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(10),
      child: Image.asset(
        iconPath,
        width: 20,
        height: 20,
        color: const Color(0xFF6BB0C5),
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildImage(MediaItem item) {
    if (item.capturedImage != null) {
      return Image.memory(item.capturedImage!, fit: BoxFit.cover);
    } else {
      return FutureBuilder<Uint8List?>(
        future: item.asset.thumbnailDataWithSize(const ThumbnailSize(300, 300)),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return Image.memory(snapshot.data!, fit: BoxFit.cover);
          }
          return Container(color: Colors.grey[200]);
        },
      );
    }
  }
}

class _StaticPhotoSlot extends StatelessWidget {
  final MediaItem item;
  const _StaticPhotoSlot({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      padding: const EdgeInsets.all(4.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6.0),
        child: Container(
          color: Colors.grey[200],
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (item.capturedImage != null)
                Image.memory(item.capturedImage!, fit: BoxFit.cover)
              else
                FutureBuilder<Uint8List?>(
                  future: item.asset.thumbnailDataWithSize(
                    const ThumbnailSize(300, 300),
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      return Image.memory(snapshot.data!, fit: BoxFit.cover);
                    }
                    return Container(color: Colors.grey[200]);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}