import 'package:flutter/material.dart';
import 'package:wememmory/constants.dart';

class MobileBankingPage extends StatefulWidget {
  const MobileBankingPage({super.key});

  @override
  State<MobileBankingPage> createState() => _MobileBankingPageState();
}

class _MobileBankingPageState extends State<MobileBankingPage> {
  int? selectedIndex = 0; // ธนาคารที่เลือก (ค่าเริ่มต้น Krungthai)

  final List<Map<String, dynamic>> banks = [
    {'icon': 'assets/icons/kungthai.png', 'name': 'Krungthai NEXT', 'status': 'ยืนยันสำเร็จ', 'statusColor': const Color(0xFF27AE60)},
    {'icon': 'assets/icons/kung.png', 'name': 'Krungsri Mobile App', 'status': '', 'statusColor': Colors.transparent},
    {'icon': 'assets/icons/kbank.png', 'name': 'K PLUS', 'status': '', 'statusColor': Colors.transparent},
    {'icon': 'assets/icons/theb.png', 'name': 'SCB Easy', 'status': '', 'statusColor': Colors.transparent},
    {'icon': 'assets/icons/bangkkok.png', 'name': 'Bankkok Bank Mobile Banking', 'status': '', 'statusColor': Colors.transparent},
  ];

  @override
  Widget build(BuildContext context) {
    const orange = Color(0xFFF29C64);
    const divider = Color(0xFFEFEFEF);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black87), onPressed: () => Navigator.pop(context)),
        title: const Text('Mobile Banking', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w800)),
      ),

      body: SafeArea(
        child: ListView.separated(
          itemCount: banks.length,
          separatorBuilder: (_, __) => const Divider(height: 1, color: divider),
          itemBuilder: (context, i) {
            final item = banks[i];
            return InkWell(
              onTap: () => setState(() => selectedIndex = i),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    Image.asset(item['icon'], width: 32, height: 32),
                    const SizedBox(width: 12),
                    Expanded(child: Text(item['name'], style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.black87))),
                    // ถ้ามีสถานะ (เช่น "ยืนยันสำเร็จ")
                    if (item['status'] != '')
                      Text(item['status'], style: TextStyle(color: item['statusColor'], fontSize: 13, fontWeight: FontWeight.w700)),
                    const SizedBox(width: 10),
                    Radio<int>(value: i, groupValue: selectedIndex, onChanged: (v) => setState(() => selectedIndex = v), activeColor: orange),
                  ],
                ),
              ),
            );
          },
        ),
      ),

      // ปุ่ม "ยืนยัน" ด้านล่าง
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: SizedBox(
          height: 46,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: orange,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ),
            child: const Text('ยืนยัน', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15)),
          ),
        ),
      ),
    );
  }
}
