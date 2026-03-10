import 'package:flutter/material.dart';

class BenefitsPage extends StatelessWidget {
  const BenefitsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // ข้อมูลจำลองสำหรับของขวัญ
    final List<Map<String, dynamic>> gifts = [
      {
        'image': 'assets/images/album.png', // เปลี่ยนเป็น path รูปของคุณ
        'title': 'สินค้า',
        'subtitle': 'เก็บช่วงเวลาที่รักติดตัวไป ทุกที่',
        'amount': '1',
      },
      {
        'image': 'assets/images/order1.png', 
        'title': 'สินค้า',
        'subtitle': 'ให้ภาพของคุณเล่าเรื่องอีกครั้ง',
        'amount': '1',
      },
      {
        'image': 'assets/images/order2.png',
        'title': 'สินค้า',
        'subtitle': 'ให้ภาพของคุณเล่าเรื่องอีกครั้ง',
        'amount': '1',
      },
      {
        'image': 'assets/images/album.png',
        'title': 'สินค้า',
        'subtitle': 'ให้ภาพของคุณเล่าเรื่องอีกครั้ง',
        'amount': '1',
      },
      {
        'image': 'assets/images/order1.png',
        'title': 'สินค้า',
        'subtitle': 'ให้ภาพของคุณเล่าเรื่องอีกครั้ง',
        'amount': '1',
      },
    ];

    // ข้อมูลจำลองสำหรับกิจกรรม
    final List<Map<String, dynamic>> activities = [
      {
        'title': 'Monthly Curation',
        'desc': 'สั่งพิมพ์อัลบั้มประจำเดือนสำเร็จ (Base Reward)',
        'points': '+ 1',
      },
      {
        'title': 'Early Bird',
        'desc': 'สั่งพิมพ์ภายในวันที่ 1-7 ของเดือน',
        'points': '+ 1',
      },
      {
        'title': 'Flow Master',
        'desc': 'ทำเวลาได้ดีที่สุด (New Personal Record) หรือ ต่ำกว่า 10 นาที (ในครั้งแรก)',
        'points': '+ 1',
      },
      {
        'title': 'Storyteller',
        'desc': 'เขียน Caption อย่างน้อย 3 รูป หรือใส่ Tag ครบ 11 รูป (เงื่อนไขใดเงื่อนไขหนึ่ง)',
        'points': '+ 1',
      },
      {
        'title': 'Social',
        'desc': 'แชร์รูปอัลบั้มลง Social Media (FB/IG/TikTok)',
        'points': '+ 2',
      },
      {
        'title': 'Full Loop',
        'desc': 'สแกน QR Code / กดยืนยันรับของ (Receipt Confirmation)',
        'points': '+ 1',
      },
      {
        'title': 'Streak Milestone',
        'desc': 'ทำต่อเนื่องครบทุก 3 เดือน',
        'points': '+ 3',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFEE743B), // สีส้มพื้นหลัง
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // --- 1. Header ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'สิทธิประโยชน์',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            // --- 2. White Content Area ---
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                ),
                child: Stack(
                  children: [
                    // List เนื้อหา
                    SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 100), // เว้นล่างเผื่อปุ่ม
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // หัวข้อของขวัญ
                          const Text(
                            'ของขวัญที่สามารถแลกเปลี่ยนได้',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
                          ),
                          const SizedBox(height: 16),

                          // รายการของขวัญ
                          ...gifts.map((item) => _buildGiftItem(item)).toList(),

                          const SizedBox(height: 24),

                          // หัวข้อเงื่อนไข
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'เงื่อนไขการสะสม Point',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
                              ),
                              Icon(Icons.keyboard_arrow_up, color: Colors.grey), // ไอคอนลูกศร
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'รายละเอียดรายละเอียดรายละเอียดรายละเอียดรายละเอียดรายละเอียดรายละเอียดรายละเอียดรายละเอียดรายละเอียดรายละเอียดรายละเอียดรายละเอียดรายละเอียดรายละเอียดรายละเอียด',
                            style: TextStyle(fontSize: 16, color: Color(0xFF555555), height: 1.5),
                          ),

                          const SizedBox(height: 24),

                          // หัวข้อกิจกรรม
                          const Text(
                            'กิจกรรม (Activity)',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
                          ),
                          const SizedBox(height: 16),

                          // รายการกิจกรรม
                          ...activities.map((item) => _buildActivityItem(item)).toList(),
                        ],
                      ),
                    ),

                    // --- 3. ปุ่มด้านล่าง ---
                    Positioned(
                      left: 20,
                      right: 20,
                      bottom: 30, // ระยะห่างจากขอบล่างจอ (SafeArea จะจัดการให้ในระดับหนึ่ง แต่เผื่อไว้สวยงาม)
                      child: SafeArea(
                        top: false,
                        child: SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              // Action แลกเปลี่ยนของรางวัล
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFEE743B), // สีส้มปุ่ม
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              elevation: 0,
                            ),
                            child: const Text(
                              'แลกเปลี่ยนของรางวัล',
                              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
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

  // Widget สร้างรายการของขวัญ
  Widget _buildGiftItem(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // รูปภาพสินค้า
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 60,
              height: 60,
              color: Colors.grey[200],
              child: Image.asset(
                item['image'],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.image, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // ข้อความ
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title'],
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87),
                ),
                const SizedBox(height: 4),
                Text(
                  item['subtitle'],
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // จำนวน
          Padding(
            padding: const EdgeInsets.only(left: 8, top: 4),
            child: Text(
              item['amount'],
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  // Widget สร้างรายการกิจกรรม
  Widget _buildActivityItem(Map<String, dynamic> item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.star, color: Color(0xFFFFC107), size: 20), // ไอคอนดาวสีเหลือง
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title'],
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
                ),
                const SizedBox(height: 4),
                Text(
                  item['desc'],
                  style: const TextStyle(fontSize: 14, color: Colors.grey, height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            item['points'],
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
          ),
        ],
      ),
    );
  }
}