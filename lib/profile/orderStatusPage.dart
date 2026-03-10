// import 'package:flutter/material.dart';

// class TrackingTimelinePage extends StatelessWidget {
//   const TrackingTimelinePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black87),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text(
//           'สถานะสินค้า',
//           style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             // 1. ส่วนหัวแสดงสินค้า (รูป + ชื่อ + ราคา)
//             Container(
//               padding: const EdgeInsets.all(20),
//               decoration: const BoxDecoration(
//                 border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
//               ),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // รูปสินค้า
//                   Container(
//                     width: 60,
//                     height: 60,
//                     decoration: BoxDecoration(
//                       color: Colors.grey[200],
//                       borderRadius: BorderRadius.circular(4),
//                       image: const DecorationImage(
//                         image: AssetImage('assets/images/album_preview.png'), // เปลี่ยนรูปตรงนี้
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 15),
//                   // ชื่อและตัวเลือก
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text(
//                           'อัลบั้มสำหรับใส่รูปครอบครัว',
//                           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           'สีส้ม   X1',
//                           style: TextStyle(color: Colors.grey[400], fontSize: 14),
//                         ),
//                       ],
//                     ),
//                   ),
//                   // ราคา
//                   const Text(
//                     '฿ 599',
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                 ],
//               ),
//             ),

//             // 2. ส่วน Timeline
//             Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Column(
//                 children: [
//                   _buildTimelineItem(
//                     date: '9 มิ.ย.',
//                     time: '11:00',
//                     status: 'พัสดุอยู่ระหว่างการนำส่ง',
//                     isFirst: true,
//                     isLast: false,
//                     isActive: true, // สีเขียว
//                   ),
//                   _buildTimelineItem(
//                     date: '8 มิ.ย.',
//                     time: '11:00',
//                     status: 'สถานะ:', // ตามรูป
//                     isFirst: false,
//                     isLast: false,
//                   ),
//                   _buildTimelineItem(
//                     date: '7 มิ.ย.',
//                     time: '11:00',
//                     status: 'สถานะ:',
//                     isFirst: false,
//                     isLast: false,
//                   ),
//                   _buildTimelineItem(
//                     date: '6 มิ.ย.',
//                     time: '11:00',
//                     status: 'สถานะ:',
//                     isFirst: false,
//                     isLast: true,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Widget สร้างแต่ละแถวของ Timeline
//   Widget _buildTimelineItem({
//     required String date,
//     required String time,
//     required String status,
//     bool isFirst = false,
//     bool isLast = false,
//     bool isActive = false,
//   }) {
//     return IntrinsicHeight(
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // ส่วนวันที่และเวลา (ด้านซ้าย)
//           SizedBox(
//             width: 50,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 Text(date, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
//                 Text(time, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
//               ],
//             ),
//           ),
          
//           const SizedBox(width: 10),

//           // ส่วนเส้นและจุด (ตรงกลาง)
//           Column(
//             children: [
//               // เส้นบน (ซ่อนถ้าเป็นอันแรก)
//               Container(
//                 width: 2,
//                 height: 5, // ระยะห่างจากขอบบน
//                 color: isFirst ? Colors.transparent : Colors.grey[300],
//               ),
//               // จุดวงกลม
//               Container(
//                 width: 12,
//                 height: 12,
//                 decoration: BoxDecoration(
//                   color: isActive ? const Color(0xFF28C668) : Colors.grey[300],
//                   shape: BoxShape.circle,
//                 ),
//               ),
//               // เส้นล่าง (ยืดตามความสูงเนื้อหา)
//               Expanded(
//                 child: Container(
//                   width: 2,
//                   color: isLast ? Colors.transparent : Colors.grey[300],
//                 ),
//               ),
//             ],
//           ),

//           const SizedBox(width: 15),

//           // ส่วนข้อความสถานะ (ด้านขวา)
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.only(bottom: 30), // เว้นระยะห่างแต่ละ item
//               child: Text(
//                 status,
//                 style: TextStyle(
//                   color: isActive ? const Color(0xFF28C668) : Colors.grey[300],
//                   fontSize: 14,
//                   fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }