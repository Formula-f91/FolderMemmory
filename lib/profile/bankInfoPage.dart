import 'package:flutter/material.dart';
import 'package:wememmory/constants.dart';
import 'package:wememmory/profile/mobileBankingPage.dart';

class BankInfoPage extends StatelessWidget {
  const BankInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    const orange = Color(0xFFF29C64);
    const divider = Color(0xFFEFEFEF);
    const textGray = Color(0xFF5F5F5F);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255), // พื้นหลังส้มด้านบน
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8B887),
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
        title: const Text('ข้อมูลบัญชีธนาคาร/บัตรเครดิต', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
      ),

      // ตัวเนื้อหาพื้นขาว
      body: SafeArea(
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(18))),
          child: Column(
            children: [
              const SizedBox(height: 10),
              _ListTile(
                icon: 'assets/icons/iconb123.png',
                title: 'Mobile Banking',
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MobileBankingPage()));
                },
              ),
              const Divider(height: 1, color: divider),
              _ListTile(icon: 'assets/icons/si_credit-card-fill.png', title: 'บัตรเครดิต/บัตรเดบิต', onTap: () {}),
              const Divider(height: 1, color: divider),
            ],
          ),
        ),
      ),

      // ปุ่มยืนยันล่าง
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

/// แถวรายการ (ไอคอน + ชื่อ + ลูกศร)
class _ListTile extends StatelessWidget {
  const _ListTile({required this.icon, required this.title, this.onTap});
  final String icon;
  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    const textGray = Color(0xFF5F5F5F);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Row(
          children: [
            Image.asset(icon, width: 28, height: 28),
            const SizedBox(width: 14),
            Expanded(child: Text(title, style: const TextStyle(fontSize: 15, color: textGray, fontWeight: FontWeight.w700))),
            const Icon(Icons.chevron_right, color: Color(0xFFB7B7B7)),
          ],
        ),
      ),
    );
  }
}
