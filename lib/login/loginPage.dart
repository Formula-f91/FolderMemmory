import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'otp_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isChecked = false;

  static const Color _bgCream = Color(0xFFF4F6F8);
  static const Color _primaryOrange = Color(0xFFE18253);
  static const Color _textGrey = Color(0xFF7A7A7A);
  static const double _radius = 14;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    // ปรับความสูงแบนเนอร์
    final double bannerHeight = size.height * 0.45;

    return Scaffold(
      backgroundColor: _bgCream,
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.topCenter,
              children: [
                // 1. รูปภาพพื้นหลัง
                SizedBox(
                  height: bannerHeight,
                  width: double.infinity,
                  child: Image.asset(
                    'assets/images/Hobby.png',
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  ),
                ),

                // 2. โลโก้
                Positioned(
                  top: padding.top + 20,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Image.asset(
                      'assets/images/image2.png',
                      height: 45,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                // 3. การ์ดฟอร์ม
                Container(
                  margin: EdgeInsets.only(
                    // ✅ แก้ไขตรงนี้: เพิ่มค่าลบเพื่อดึงกล่องขึ้นไปข้างบนมากขึ้น (จาก -60 เป็น -120)
                    top: bannerHeight - 120, 
                    left: 24,
                    right: 24,
                    bottom: 30,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(_radius),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x1A000000),
                        blurRadius: 20,
                        offset: Offset(0, 5),
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ช่องกรอกเบอร์โทรศัพท์
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFE0E0E0)),
                          color: Colors.white,
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Row(
                                children: [
                                  Image.asset('assets/icons/Flags.png', height: 20),
                                  const SizedBox(width: 8),
                                  const Text(
                                    '+66',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 24,
                              color: const Color(0xFFE0E0E0),
                            ),
                            Expanded(
                              child: TextField(
                                keyboardType: TextInputType.phone,
                                decoration: const InputDecoration(
                                  hintText: 'หมายเลขโทรศัพท์',
                                  hintStyle: TextStyle(
                                      color: Color(0xFF9E9E9E), fontSize: 16),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Checkbox และ ข้อความเงื่อนไข
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () => setState(() => _isChecked = !_isChecked),
                            child: Container(
                              margin: const EdgeInsets.only(top: 3, right: 12),
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _isChecked ? _primaryOrange : Colors.white,
                                border: Border.all(
                                  color: _isChecked ? _primaryOrange : const Color(0xFFC4C4C4),
                                  width: 1,
                                ),
                              ),
                              child: _isChecked
                                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                                  : null,
                            ),
                          ),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  color: Color(0xFF505050),
                                  fontSize: 13,
                                  height: 1.5,
                                  fontFamily: 'Kanit',
                                ),
                                children: [
                                  const TextSpan(text: 'การสร้างหรือใช้งานบัญชีของท่านถือว่าท่านยอมรับ\nและตกลงปฏิบัติตาม'),
                                  TextSpan(
                                    text: 'ข้อกำหนดการใช้งาน',
                                    style: const TextStyle(
                                      color: _primaryOrange,
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()..onTap = () {},
                                  ),
                                  const TextSpan(text: 'และ'),
                                  TextSpan(
                                    text: 'นโยบาย\nความเป็นส่วนตัว',
                                    style: const TextStyle(
                                      color: _primaryOrange,
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()..onTap = () {},
                                  ),
                                  const TextSpan(text: 'ของเรา'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // ปุ่มเข้าสู่ระบบ
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _primaryOrange,
                            foregroundColor: Colors.white,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                            elevation: 0,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const OtpPage()),
                            );
                          },
                          child: const Text(
                            'เข้าสู่ระบบ',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // เส้นคั่น "หรือ"
                      Row(
                        children: [
                          const Expanded(child: Divider(color: Color(0xFFE0E0E0))),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'หรือ',
                              style: TextStyle(color: _textGrey, fontSize: 14),
                            ),
                          ),
                          const Expanded(child: Divider(color: Color(0xFFE0E0E0))),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // ปุ่ม Social Media
                      _SocialButton(
                        iconPath: 'assets/icons/SocialIcons.png',
                        label: 'เข้าสู่ระบบด้วย Facebook',
                      ),
                      const SizedBox(height: 12),
                      _SocialButton(
                        iconPath: 'assets/icons/google.png',
                        label: 'เข้าสู่ระบบด้วย Google',
                      ),
                      const SizedBox(height: 12),
                      _SocialButton(
                        iconPath: 'assets/icons/Line.png',
                        label: 'เข้าสู่ระบบด้วย Line',
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    super.key,
    required this.iconPath,
    required this.label,
  });

  final String iconPath;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFFE0E0E0)),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        onPressed: () {},
        child: Row(
          children: [
            Image.asset(iconPath, height: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF333333),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}