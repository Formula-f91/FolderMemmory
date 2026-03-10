import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // ใช้สำหรับจัดรูปแบบ Input

// ---------------------------------------------------
// หน้าที่ 1: กรอกเบอร์โทรศัพท์ (รูปที่ 2)
// ---------------------------------------------------
class PhoneInputScreen extends StatefulWidget {
  const PhoneInputScreen({super.key});

  @override
  State<PhoneInputScreen> createState() => _PhoneInputScreenState();
}

class _PhoneInputScreenState extends State<PhoneInputScreen> {
  final TextEditingController _phoneController = TextEditingController();

  // สี Theme (ชุดเดิม)
  final Color bgTopColor = const Color(0xFFFAB88E);
  final Color buttonColor = const Color(0xFFF16B41);
  final Color borderColor = const Color(0xFFEEEEEE);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgTopColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {Navigator.pop(context);},
        ),
        title: const Text(
          'เบอร์โทรศัพท์',
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    // ช่องกรอกเบอร์โทร
                    TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: 'เบอร์โทรศัพท์',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: borderColor, width: 1.5),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: buttonColor, width: 1.5),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    
                    const SizedBox(height: 20),

                    // ปุ่มยืนยัน
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {
                          // กดแล้วไปหน้า OTP
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OtpInputScreen(
                                phoneNumber: _phoneController.text.isEmpty 
                                    ? "0940318888" // ค่าสมมติถ้าไม่ได้กรอก
                                    : _phoneController.text,
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          'ยืนยัน',
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),
                    // ข้อความเล็กๆ ด้านล่าง
                    Text(
                      'กรุณาใส่หมายเลขโทรศัพท์เพื่อรับ OTP',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------
// หน้าที่ 2: กรอก OTP (รูปที่ 1)
// ---------------------------------------------------
class OtpInputScreen extends StatefulWidget {
  final String phoneNumber; // รับเบอร์โทรมาจากหน้าแรก

  const OtpInputScreen({super.key, required this.phoneNumber});

  @override
  State<OtpInputScreen> createState() => _OtpInputScreenState();
}

class _OtpInputScreenState extends State<OtpInputScreen> {
  final Color bgTopColor = const Color(0xFFFAB88E);
  final Color buttonColor = const Color(0xFFF16B41);

  // สร้าง FocusNode และ Controller สำหรับ 6 ช่อง
  // เพื่อให้เวลากรอกเลขแล้วมันเด้งไปช่องถัดไปอัตโนมัติ
  late List<FocusNode> _focusNodes;
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _focusNodes = List.generate(6, (index) => FocusNode());
    _controllers = List.generate(6, (index) => TextEditingController());
  }

  @override
  void dispose() {
    for (var node in _focusNodes) node.dispose();
    for (var controller in _controllers) controller.dispose();
    super.dispose();
  }

  void _nextField(String value, int index) {
    if (value.length == 1) {
      if (index != 5) {
        FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
      } else {
        FocusScope.of(context).unfocus(); // ช่องสุดท้ายแล้ว ปิดคีย์บอร์ด
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgTopColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'เบอร์โทรศัพท์', // ตามรูปหัวข้อยังเป็นเบอร์โทรศัพท์อยู่
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    
                    // ส่วนช่องกรอก OTP 6 หลัก
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(6, (index) {
                        return SizedBox(
                          width: 45, // ความกว้างของแต่ละช่อง
                          child: TextField(
                            controller: _controllers[index],
                            focusNode: _focusNodes[index],
                            autofocus: index == 0, // ให้โฟกัสช่องแรกทันที
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            maxLength: 1, // กรอกได้ตัวเดียว
                            onChanged: (value) => _nextField(value, index),
                            style: TextStyle(
                              fontSize: 24, 
                              color: Colors.grey[600]
                            ),
                            decoration: InputDecoration(
                              counterText: "", // ซ่อนตัวนับจำนวนตัวอักษร
                              hintText: "0",
                              hintStyle: TextStyle(color: Colors.grey[300]),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey, width: 1),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: buttonColor, width: 2),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: 30),

                    // ปุ่มยืนยัน
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {
                          // รวมรหัสจาก 6 ช่อง
                          String otp = _controllers.map((e) => e.text).join();
                          print("OTP ที่กรอกคือ: $otp");
                        },
                        child: const Text(
                          'ยืนยัน',
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ข้อความแจ้งเตือนด้านล่าง
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'กรอกรหัส OTP ที่ส่งไปยังหมายเลขโทรศัพท์',
                          style: TextStyle(color: Colors.grey[600], fontSize: 14),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '+66 ${widget.phoneNumber}', // แสดงเบอร์ที่รับมา
                          style: const TextStyle(
                            color: Colors.black87, 
                            fontSize: 16, 
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}