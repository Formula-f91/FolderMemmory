import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'username_page.dart';

class OtpPage extends StatefulWidget {
  final String phoneNumber;

  const OtpPage({
    super.key,
    this.phoneNumber = "+66 94 031 8888",
  });

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  // ✅ เพิ่มตัวแปรเช็ค Error
  bool _hasError = false;

  static const Color _bgCream = Color(0xFFF4F6F8);
  static const Color _primaryOrange = Color(0xFFE18253);
  static const Color _textGrey = Color(0xFF7A7A7A);
  static const double _radius = 14;

  @override
  void dispose() {
    for (var controller in _controllers) controller.dispose();
    for (var node in _focusNodes) node.dispose();
    super.dispose();
  }

  void _onFieldChanged(String value, int index) {
    // เมื่อมีการพิมพ์ ให้เคลียร์ Error ออกก่อน
    if (_hasError) {
      setState(() {
        _hasError = false;
      });
    }

    if (value.length == 1 && index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final insetTop = MediaQuery.of(context).padding.top;
    const double bannerHeight = 380;
    final double cardSidePadding = size.width * 0.06;

    return Scaffold(
      backgroundColor: _bgCream,
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: bannerHeight,
                    width: double.infinity,
                    child: Image.asset(
                      'assets/images/Hobby.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                  Positioned(
                    left: size.width * 0.18,
                    top: insetTop + 12,
                    child: Image.asset(
                      'assets/images/image2.png',
                      height: 40,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
              Transform.translate(
                offset: const Offset(0, -58),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: cardSidePadding),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(18, 18, 18, 22),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(_radius),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x1F000000),
                          blurRadius: 16,
                          offset: Offset(0, 8),
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child:
                              const Icon(Icons.arrow_back, color: Colors.black),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'กรอกรหัส OTP ที่ส่งไปยังหมายเลขโทรศัพท์',
                          style: TextStyle(color: _textGrey, fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.phoneNumber,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 30),
                        
                        // --- OTP Fields ---
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(6, (index) {
                            return SizedBox(
                              width: 40,
                              child: TextField(
                                controller: _controllers[index],
                                focusNode: _focusNodes[index],
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(1),
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                onChanged: (value) =>
                                    _onFieldChanged(value, index),
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                                decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  enabledBorder: UnderlineInputBorder(
                                    // เปลี่ยนสีเส้นเมื่อมี Error
                                    borderSide: BorderSide(
                                        color: _hasError 
                                            ? Colors.red 
                                            : Colors.grey.shade300),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: _hasError 
                                            ? Colors.red 
                                            : _primaryOrange, 
                                        width: 2),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                        
                        // --- ✅ ส่วนแสดงข้อความ Error (เพิ่มใหม่ตรงนี้) ---
                        if (_hasError)
                          const Padding(
                            padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                            child: Text(
                              'รหัส OTP ไม่ถูกต้อง กรุณาส่งรหัสใหม่อีกครั้ง',
                              style: TextStyle(
                                color: Color(0xFFE57373), // สีแดงอ่อนๆ ตามรูป
                                fontSize: 14,
                              ),
                            ),
                          )
                        else
                          // ใส่ SizedBox เปล่าๆ ไว้จองพื้นที่หรือระยะห่าง (Optional)
                          const SizedBox(height: 24), // ถ้าไม่มี Error ให้เว้นระยะปกติ (32-8 = 24 โดยประมาณ)

                        // ถ้ามี Error แล้ว เราใส่ padding ใน if แล้ว ถ้าไม่มี Error เราใช้ SizedBox ด้านบนแทน
                        // ดังนั้นบรรทัดนี้ปรับเป็นระยะห่างที่เหลือ
                        const SizedBox(height: 8), 

                        SizedBox(
                          width: double.infinity,
                          height: 46,
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
                              String inputOtp =
                                  _controllers.map((c) => c.text).join();

                              if (inputOtp == "111111") {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const UsernamePage()),
                                );
                              } else {
                                // ✅ 1. แสดง Error Text
                                setState(() {
                                  _hasError = true;
                                });

                                // ✅ 2. ล้างข้อมูล และกลับไปช่องแรก
                                for (var controller in _controllers) {
                                  controller.clear();
                                }
                                _focusNodes[0].requestFocus();
                              }
                            },
                            child: const Text(
                              'ยืนยัน',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: TextButton(
                            onPressed: () {
                              // เมื่อกดส่งรหัสใหม่ ให้เคลียร์ Error ด้วยก็ได้
                              setState(() {
                                _hasError = false;
                              });
                              // Logic ส่งรหัสใหม่
                            },
                            child: const Text(
                              'ส่งรหัสใหม่',
                              style: TextStyle(
                                  color: _primaryOrange, fontSize: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}