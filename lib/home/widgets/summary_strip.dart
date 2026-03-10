import 'package:flutter/material.dart';

// --- Widget หลักสำหรับแสดงผล ---
class SummaryStrip extends StatelessWidget {
  const SummaryStrip({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 200, 
          child: PageView(
            controller: PageController(viewportFraction: 1.0),
            children: const [
              // การ์ดที่ 1 (แบบ InfoCard เดิม)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
                child: InfoCard(
                  title: 'เรื่องราวที่น่าจดจำ',
                  count: '88',
                  countColor: Color(0xFF5AB6D8),
                  imagePaths: [
                    'assets/images/Hobby1.png',
                  ],
                  topCaptionTitle: 'ช่วงเวลาดีดี',
                  topCaptionSub: '#ครอบครัว #ความรัก',
                ),
              ),
              
              // -------------------------------------------------------
              // การ์ดที่ 2 (แก้ไขใหม่ตามรูปภาพ 2month.jpg)
              // -------------------------------------------------------
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
                child: SubscriptionCard(
                  imagePaths: [
                    'assets/images/Hobby3.png',  
                  ],
                  
                ),
              ),
              // -------------------------------------------------------
              
              // การ์ดที่ 3 (แบบ Background Image)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
                child: BackgroundCard(
                  backgroundImagePath: 'assets/images/buyone.png',
                ),
              ),

              // การ์ดที่ 4 (แบบ Background Image)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
                child: BackgroundCard(
                  backgroundImagePath: 'assets/images/promotion.png', 
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}

// ---------------------------------------------------------
// (ใหม่) SubscriptionCard: การ์ดสำหรับ Layout card 2
// ---------------------------------------------------------
class SubscriptionCard extends StatelessWidget {
  final List<String>? imagePaths;
  final String topCaptionTitle;
  final String topCaptionSub;

  const SubscriptionCard({
    super.key,
    this.imagePaths,
    this.topCaptionTitle = '',
    this.topCaptionSub = '',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0x33C4C4C4),
        borderRadius: BorderRadius.circular(0),
        border: Border.all(
          color: const Color.fromARGB(255, 129, 129, 129).withOpacity(0.15),
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(25, 20, 30, 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ส่วนรูปภาพด้านซ้าย (ใช้ _PhotoStack เดิม)
            _PhotoStack(
              imagePaths: imagePaths,
              topCaptionTitle: topCaptionTitle,
              topCaptionSub: topCaptionSub,
            ),
            
            const Spacer(), 
            
            // ส่วนข้อความด้านขวา (จัด Layout ใหม่ตามภาพ)
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center, // จัดกึ่งกลางแนวตั้งของ Column
              children: [
                // ข้อความบน: สร้างอัลบั้มต่อเนื่อง
                Text(
                  'สร้างอัลบั้มต่อเนื่อง',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[400],
                  ),
                ),
                const SizedBox(height: 5),
                
                // แถวล่าง: เลข 4 และ คำว่าเดือน
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // เลข 4 สีฟ้าตัวใหญ่
                    const Text(
                      '4',
                      style: TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF5AB6D8), // สีฟ้า
                        height: 1.0, 
                      ),
                    ),
                    const SizedBox(width: 9), // ระยะห่าง
                    
                    // แคปซูลคำว่า "เดือน"
                    Container(
                      margin: const EdgeInsets.only(top: 18),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEBF8FC), // พื้นหลังสีฟ้าอ่อนมากๆ
                        borderRadius: BorderRadius.circular(20), // ความมนของแคปซูล
                      ),
                      child: const Text(
                        'เดือน',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF5AB6D8), // สีตัวหนังสือสีฟ้า
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------
// BackgroundCard (คงเดิมจากที่คุณมี)
// ---------------------------------------------------------
class BackgroundCard extends StatelessWidget {
  final String backgroundImagePath;
  final String? title;
  final String? count;
  final Color countColor; 

  const BackgroundCard({
    super.key,
    required this.backgroundImagePath,
    this.title,
    this.count,
    this.countColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0),
        border: Border.all(
          color: const Color.fromARGB(255, 129, 129, 129).withOpacity(0.15),
          width: 2,
        ),
        image: DecorationImage(
          image: AssetImage(backgroundImagePath),
          fit: BoxFit.cover, 
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(25, 20, 35, 20),
        child: Row(
          children: const [Spacer()], // เว้นว่างไว้โชว์รูป background
        ),
      ),
    );
  }
}

// ---------------------------------------------------------
// InfoCard (คงเดิม)
// ---------------------------------------------------------
class InfoCard extends StatelessWidget {
  final String title;
  final String count;
  final Color countColor;
  final List<String>? imagePaths; 
  final String topCaptionTitle;   
  final String topCaptionSub;

  const InfoCard({
    super.key,
    required this.title,
    required this.count,
    this.countColor = const Color(0xFF5AB6D8),
    this.imagePaths,
    this.topCaptionTitle = '',
    this.topCaptionSub = '',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0x33C4C4C4),
        borderRadius: BorderRadius.circular(0),
        border: Border.all(
          color: const Color.fromARGB(255, 129, 129, 129).withOpacity(0.15),
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(25, 20, 35, 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _PhotoStack(
              imagePaths: imagePaths,
              topCaptionTitle: topCaptionTitle,
              topCaptionSub: topCaptionSub,
            ),
            const Spacer(), 
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[400],
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  count,
                  style: TextStyle(
                    fontSize: 60,
                    fontWeight: FontWeight.w900,
                    color: countColor,
                    height: 1.0, 
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------
// _PhotoStack & _PhotoCard (คงเดิมตามโค้ดของคุณ)
// ---------------------------------------------------------
class _PhotoStack extends StatelessWidget {
  final List<String>? imagePaths;
  final String topCaptionTitle;
  final String topCaptionSub;

  const _PhotoStack({
    this.imagePaths,
    required this.topCaptionTitle,
    required this.topCaptionSub,
  });

  @override
  Widget build(BuildContext context) {
    const double w = 95; 
    const double h = 125; 
    
    String? img1 = (imagePaths != null && imagePaths!.isNotEmpty) ? imagePaths![0] : null;
    String? img2 = (imagePaths != null && imagePaths!.length > 1) ? imagePaths![1] : null;
    String? img3 = (imagePaths != null && imagePaths!.length > 2) ? imagePaths![2] : null;

    return SizedBox(
      width: w + 25, 
      height: h + 10,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 20, top: 0,
            child: Transform.rotate(
              angle: 0.22, 
              child: _PhotoCard(width: w, height: h, rotation: 0, imagePath: img3, isBackCard: true),
            ),
          ),
          Positioned(
            left: 0, top: 0,
            child: Transform.rotate(
              angle: -0.10, 
              child: _PhotoCard(width: w, height: h, rotation: 0, imagePath: img2, isBackCard: true),
            ),
          ),
          Positioned(
            left: 10, top: 0,
            child: _PhotoCard(width: w, height: h, rotation: 0.0, imagePath: img1, isBackCard: false, captionTitle: topCaptionTitle, captionSub: topCaptionSub),
          ),
        ],
      ),
    );
  }
}

class _PhotoCard extends StatelessWidget {
  final double width;
  final double height;
  final double rotation;
  final String? imagePath; 
  final bool isBackCard;   
  final String captionTitle;
  final String captionSub;

  const _PhotoCard({
    required this.width,
    required this.height,
    required this.rotation,
    this.imagePath,
    this.isBackCard = false,
    this.captionTitle = '',
    this.captionSub = '',
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: rotation,
      child: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.fromLTRB(6, 6, 6, 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(0),
          border: Border.all(color: Colors.grey.withOpacity(0.2), width: 0.5),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 8, offset: const Offset(0, 3)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 4, 
              child: Container(
                decoration: const BoxDecoration(color: Color.fromARGB(255, 255, 255, 255)),
                padding: const EdgeInsets.all(10), 
                clipBehavior: Clip.antiAlias,
                child: imagePath != null
                    ? Image.asset(imagePath!, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.broken_image, color: Colors.grey, size: 20)))
                    : const Center(child: Icon(Icons.photo, color: Colors.white, size: 30)),
              ),
            ),
            if (!isBackCard) ...[
              const SizedBox(height: 2), 
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(captionTitle, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: Colors.black87), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text(captionSub, style: const TextStyle(fontSize: 7, color: Color(0xFF5AB6D8), fontWeight: FontWeight.w500), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              )
            ] else ...[const Spacer(flex: 3)]
          ],
        ),
      ),
    );
  }
}

