import 'package:flutter/material.dart';

// 1. สร้าง Enum เพื่อระบุประเภทประวัติ
enum HistoryType {
  subscription, // ประวัติการสมัครสมาชิก (แสดงราคา ฿) -> รูป Screenshot แรก
  point,        // ประวัติแต้ม (แสดง +1) -> รูป Screenshot สอง
}

class MembershipHistoryPage extends StatefulWidget {
  // 2. รับค่า type เข้ามาเพื่อกำหนดรูปแบบหน้า
  final HistoryType type;

  const MembershipHistoryPage({
    super.key,
    this.type = HistoryType.subscription, // ค่าเริ่มต้นเป็นแบบสมัครสมาชิก
  });

  @override
  State<MembershipHistoryPage> createState() => _MembershipHistoryPageState();
}

class _MembershipHistoryPageState extends State<MembershipHistoryPage> {
  String _selectedFilter = 'วันที่ทั้งหมด';

  final List<String> _filterOptions = [
    'วันที่ทั้งหมด',
    '30 วันที่ผ่านมา',
    '90 วันที่ผ่านมา',
    '120 วันที่ผ่านมา',
    'ปี 2025',
    'ปี 2024',
  ];

  // --- ข้อมูลชุดที่ 1: ประวัติการสมัคร (แสดงราคา ฿) ---
  final List<Map<String, dynamic>> _subscriptionData = [
    {'name': 'แพ็กเกจเริ่มต้น', 'date': '01/07/2025', 'value': '฿899'},
    {'name': 'แพ็กเกจพรีเมียม', 'date': '01/10/2025', 'value': '฿1,599'},
    {'name': 'แพ็กเกจรายปี', 'date': '01/01/2024', 'value': '฿2,999'},
  ];

  // --- ข้อมูลชุดที่ 2: ประวัติแต้ม (แสดง +1) ---
  final List<Map<String, dynamic>> _pointData = [
    {'name': 'Early Bird', 'date': '01/07/2025', 'value': '+ 1'},
    {'name': 'Flow Master', 'date': '01/10/2025', 'value': '+ 1'},
    {'name': 'Monthly Curation', 'date': '01/01/2024', 'value': '+ 1'},
  ];

  @override
  Widget build(BuildContext context) {
    // 3. เลือกข้อมูลและสีตาม Type ที่ส่งมา
    final bool isSubscription = widget.type == HistoryType.subscription;
    final List<Map<String, dynamic>> currentItems = isSubscription ? _subscriptionData : _pointData;
    
    // กำหนดสีพื้นหลัง (ใช้สีส้มเหมือนกัน หรือจะแยกก็ได้)
    // จากรูปทั้งสองใช้สีส้มโทนเดียวกัน
    const Color themeColor = Color(0xFFF05A28); 

    return Scaffold(
      backgroundColor: themeColor, 
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // --- ส่วน Header ---
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
                    'ประวัติรายการ',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            // --- ส่วนเนื้อหา (Content Area) ---
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    
                    // ปุ่ม Dropdown
                    Align(
                      alignment: Alignment.centerRight,
                      child: PopupMenuButton<String>(
                        offset: const Offset(0, 50), 
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        color: Colors.white,
                        onSelected: (String value) => setState(() => _selectedFilter = value),
                        itemBuilder: (context) => _filterOptions.map((c) => PopupMenuItem(value: c, height: 45, child: Text(c))).toList(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          constraints: const BoxConstraints(minWidth: 140),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _selectedFilter,
                                style: const TextStyle(color: Colors.black54, fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.keyboard_arrow_down, color: Colors.grey, size: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 10),
                    const Divider(color: Color(0xFFEEEEEE)),

                    // รายการ (ListView)
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        itemCount: currentItems.length,
                        separatorBuilder: (context, index) => const Divider(color: Color(0xFFEEEEEE), height: 32, thickness: 1),
                        itemBuilder: (context, index) {
                          final item = currentItems[index];
                          
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // ด้านซ้าย: ชื่อและวันที่
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['name'],
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: isSubscription ? FontWeight.w600 : FontWeight.w500, // ปรับน้ำหนัก font ตามแบบ
                                        color: const Color(0xFF333333),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      item['date'],
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: isSubscription ? Colors.grey : Colors.black54, // ปรับสี font ตามแบบ
                                      ),
                                    ),
                                  ],
                                ),
                                // ด้านขวา: ราคาหรือแต้ม
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    item['value'],
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF333333),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
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