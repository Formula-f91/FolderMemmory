import 'package:flutter/material.dart';
import 'package:wememmory/home/firstPage.dart';

class PaymentSuccessPage extends StatelessWidget {
  const PaymentSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ✅ แก้ไข: ใช้ Row เพื่อให้ไอคอนอยู่ข้างหน้าข้อความ
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center, // จัดให้อยู่กึ่งกลาง
                        children: [
                          // วงกลมไอคอน
                          Container(
                            width: 50, // ปรับขนาดให้เล็กลงหน่อยเพื่อให้เข้ากับบรรทัด
                            height: 50,
                            decoration: const BoxDecoration(
                              color: Color(0xFF66BB6A), // สีเขียว
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.check, size: 30, color: Colors.white),
                          ),
                          
                          const SizedBox(width: 16), // ระยะห่างระหว่างไอคอนกับข้อความ
                          
                          // หัวข้อ
                          const Flexible( // ใช้ Flexible ป้องกันข้อความยาวเกินจอ
                            child: Text(
                              'การชำระเงินของคุณเสร็จสมบูรณ์',
                              style: TextStyle(
                                fontSize: 18, 
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // รายละเอียด (ยังคงอยู่ด้านล่างเหมือนเดิม)
                      const Text(
                        'ทีมงานจะดูแลทุกขั้นตอนด้วยความใส่ใจ\nเพื่อให้สิ่งที่คุณได้รับ...อบอวลไปด้วยความรัก ความทรงจำ\nและรอยยิ้มของครอบครัว',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // ปุ่มด้านล่าง
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const FirstPage()),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF7043),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'ยืนยัน',
                    style: TextStyle(
                      color: Colors.white, 
                      fontWeight: FontWeight.bold, 
                      fontSize: 16
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}