import 'package:flutter/material.dart';
import 'package:wememmory/constants.dart';
import 'package:wememmory/profile/usernamePage.dart'; 
import 'package:wememmory/profile/phoneInputPage.dart';

class PersonalSecurityPage extends StatefulWidget {
  const PersonalSecurityPage({super.key});

  @override
  State<PersonalSecurityPage> createState() => _PersonalSecurityPageState();
}

class _PersonalSecurityPageState extends State<PersonalSecurityPage> {
  bool touchIdEnabled = true;

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
        title: const Text('ข้อมูลส่วนบุคคลและความปลอดภัย', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800,)),
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            child: Column(
              children: [
                // รูปโปรไฟล์ + ปุ่มแก้ไข
                Column(
                  children: [
                    CircleAvatar(radius: 48, backgroundImage: const AssetImage('assets/images/userpic.png'), backgroundColor: Colors.grey.shade200),
                    const SizedBox(height: 10),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey.shade400, width: 1),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        backgroundColor: Colors.white,
                      ),
                      onPressed: () {},
                      child: const Text('แก้ไขรูปภาพ', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w700, fontSize: 13.5)),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // กลุ่มรายการข้อมูลทั่วไป
                _TitledListGroup(
                  children: [
                    _NavRow(title: 'ชื่อผู้ใช้งาน', onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const UserFormScreen()), // เปลี่ยน UsernamePage เป็นชื่อคลาสหน้าแก้ไขชื่อของคุณ
                        );}),
                    const Divider(height: 1, color: divider),
                    _NavRow(title: 'เบอร์โทรศัพท์', onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const PhoneInputScreen()), // เปลี่ยน PhoneInputPage เป็นชื่อคลาสหน้าแก้ไขเบอร์ของคุณ
                        );
                    }),
                    const Divider(height: 1, color: divider),
                    _SwitchRow(
                      title: 'เปิดใช้งาน  Touch ID',
                      value: touchIdEnabled,
                      onChanged: (v) => setState(() => touchIdEnabled = v),
                      activeColor: orange,
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // ส่วนหัว "โซเชียลมีเดีย"
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('โซเชียลมีเดีย', style: TextStyle(color: textGray, fontWeight: FontWeight.w800, fontSize: 14.5)),
                ),
                const SizedBox(height: 10),

                // กลุ่มรายการโซเชียล
                _TitledListGroup(
                  children: const [
                    _StatusRow(title: 'Facebook', statusText: 'เชื่อมต่อ', statusColor: Color(0xFFB7B7B7)),
                    Divider(height: 1, color: divider),
                    _StatusRow(title: 'Google', statusText: 'สำเร็จ', statusColor: Color(0xFF27AE60)),
                    Divider(height: 1, color: divider),
                    _StatusRow(title: 'Line', statusText: 'เชื่อมต่อ', statusColor: Color(0xFFB7B7B7)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// กล่องรายการพื้นขาว มุมโค้ง และเงาอ่อน ๆ (เหมือนในภาพ)
class _TitledListGroup extends StatelessWidget {
  const _TitledListGroup({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12.withOpacity(.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(children: children),
    );
  }
}

/// แถวแบบนำทาง (มีลูกศรขวา)
class _NavRow extends StatelessWidget {
  const _NavRow({required this.title, this.onTap});
  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 52,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontSize: 15, color: Colors.black87, fontWeight: FontWeight.w500)),
            const Icon(Icons.chevron_right, color: Color(0xFFB7B7B7)),
          ],
        ),
      ),
    );
  }
}

/// แถวสวิตช์ Touch ID
class _SwitchRow extends StatelessWidget {
  const _SwitchRow({required this.title, required this.value, required this.onChanged, required this.activeColor});

  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color activeColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 15, color: Colors.black87, fontWeight: FontWeight.w500)),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: activeColor,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: const Color(0xFFDADADA),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }
}

/// แถวโซเชียล + ชิปสถานะทางขวา
class _StatusRow extends StatelessWidget {
  const _StatusRow({required this.title, required this.statusText, required this.statusColor});

  final String title;
  final String statusText;
  final Color statusColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 15, color: Colors.black87, fontWeight: FontWeight.w500)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: statusColor.withOpacity(0.35)),
            ),
            child: Text(statusText, style: TextStyle(color: statusColor, fontSize: 12.5, fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
  }
}
