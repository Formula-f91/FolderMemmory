import 'package:flutter/material.dart';
import 'package:wememmory/constants.dart';

class AddressPage extends StatelessWidget {
  const AddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    const divider = Color(0xFFEFEFEF);
    const grey = Color(0xFF9B9B9B);
    const orange = Color(0xFFF29C64);

    return Scaffold(
      backgroundColor: kBackgroundColor, // ส้มด้านบน
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
        title: const Text('ที่อยู่', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
      ),

      // พื้นขาวมุมโค้ง + รายการ
      body: SafeArea(
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(18))),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black12.withOpacity(.03), blurRadius: 8, offset: const Offset(0, 3))],
                ),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ชื่อ + เบอร์
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text('ชื่อ - นามสกุล', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                                  SizedBox(height: 4),
                                  Text('098 - 765 - 4321', style: TextStyle(color: grey, fontSize: 13.5)),
                                ],
                              ),
                            ),
                            // ปุ่มแก้ไข (ตัวหนังสือเทา)
                            TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(0, 0),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: const Text('แก้ไข', style: TextStyle(color: grey, fontWeight: FontWeight.w700)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(height: 1, color: divider),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      // ปุ่มเพิ่มที่อยู่ชิดล่าง
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: SizedBox(
          height: 44,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: orange,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ),
            child: const Text('เพิ่มที่อยู่', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          ),
        ),
      ),
    );
  }
}
