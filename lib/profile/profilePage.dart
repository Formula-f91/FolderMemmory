import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wememmory/Service_system/auth_service.dart';
import 'package:wememmory/profile/edit_profile_page.dart';
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
import 'package:firebase_auth/firebase_auth.dart';
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
              // const _PointCard(),
              const SizedBox(height: 16),

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
                  'ออจกจากระบบ',
                ],
                onItemTap: (item, index) async {
                  switch (index) {
                    case 0:
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CouponPage()),
                      );
                      break;
                    case 1:
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PersonalSecurityPage(),
                        ),
                      );
                      break;
                    case 2:
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddressSelectionPage(),
                        ),
                      );
                      break;
                    case 3:
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BankInfoPage()),
                      );
                      break;
                    case 4:
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LanguageSelectionScreen(),
                        ),
                      );
                      break;
                    case 5:
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TermsAndServicesPage(),
                        ),
                      );
                      break;
                    case 6:
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FAQPage()),
                      );
                      break;
                    case 7: // ออกจากระบบ
                      _showLogoutDialog(context);
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

void _showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon วงกลมสีแดงจางๆ
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 0.5),
                ),
                child: const Icon(Icons.logout, color: Colors.red, size: 32),
              ),
              const SizedBox(height: 16),
              const Text(
                "Logout",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Are you sure you want to logout?",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          // 1. ปิด Dialog
                          Navigator.pop(context);

                          // 2. ทำการ Logout
                          await FirebaseAuth.instance.signOut();

                          // 3. ✨ เพิ่มโค้ดส่วนนี้: เคลียร์หน้าจอที่ซ้อนทับอยู่ทั้งหมดทิ้ง! ✨
                          if (context.mounted) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              // ถ้าไฟล์ main.dart ของคุณยังตั้งชื่อ route '/' ไว้ ให้ใช้วิธีนี้
                              MaterialPageRoute(
                                builder: (context) => const AuthGate(),
                              ),
                              (route) =>
                                  false, // false คือลบหน้าเก่าทิ้งทั้งหมด
                            );
                          }
                        } catch (e) {
                          print('Error: $e');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text("Logout"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _HeaderSection extends StatefulWidget {
  const _HeaderSection({super.key});

  @override
  State<_HeaderSection> createState() => _HeaderSectionState();
}

class _HeaderSectionState extends State<_HeaderSection> {
  // ฟังก์ชันสำหรับดึงข้อมูลใหม่เวลากลับมาจากหน้า Edit
  void _refreshProfile() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final userName = user?.displayName ?? 'User';
    // ดึงรูปโปรไฟล์จาก Firebase ถ้าไม่มีให้ใช้รูป Default
    final photoUrl = user?.photoURL;

    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.grey.shade200,
          backgroundImage:
              photoUrl != null
                  ? NetworkImage(photoUrl) as ImageProvider
                  : const AssetImage('assets/images/userpic.png'),
        ),
        const SizedBox(height: 12),
        Text(
          userName,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w800,
            fontSize: 22,
          ),
        ),
        const SizedBox(height: 4),
        // ✅ เปลี่ยนข้อความเป็นปุ่มกด
        GestureDetector(
          onTap: () {
            // ไปหน้า Edit Profile และรอการกลับมาเพื่อรีเฟรชหน้าจอ
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const EditProfilePage()),
            ).then((_) => _refreshProfile());
          },
          child: const Text(
            'แก้ไขโปรไฟล์',
            style: TextStyle(
              color: Color(0xFFE18253), // เปลี่ยนสีให้ดูเป็นปุ่มที่กดได้
              fontWeight: FontWeight.w600,
              fontSize: 16,
              decoration: TextDecoration.underline, // ขีดเส้นใต้เล็กน้อย
            ),
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
                'Album',
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
                  onPressed:
                      () => Navigator.of(context).push(
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
                        builder:
                            (context) => const MembershipHistoryPage(
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
                        builder:
                            (context) => const MembershipHistoryPage(
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
