// import 'package:flutter/material.dart';


// // Enum เก็บสถานะทั้งหมด
// enum OrderStatus {
//   waitingPayment,
//   printing,
//   preparing,
//   shipping,
//   completed,
//   returned, // สถานะคืนสินค้า
//   cancelled
// }

// // ==============================================================================
// // 1. PAGE: หน้ารายละเอียดออเดอร์ (OrderDetailPage)
// // ==============================================================================
// class OrderDetailPage extends StatelessWidget {
//   final OrderStatus status;

//   const OrderDetailPage({super.key, required this.status});

//   @override
//   Widget build(BuildContext context) {
//     final info = _getStatusInfo(status);

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         centerTitle: false,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black87),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text(
//           'ประวัติอัลบั้ม',
//           style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w700),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//         child: Column(
//           children: [
//             // --- ส่วนหัว: ชื่อสินค้า และ จำนวน ---
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: const [
//                 Text(
//                   'อัลบั้มสำหรับใส่รูปครอบครัว',
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//                 Text(
//                   'จำนวน 1 ชิ้น',
//                   style: TextStyle(fontSize: 14, color: Colors.grey),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 15),

//             // --- สถานะ ---
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text('สั่งซื้อ',
//                     style:
//                         TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                 Text(
//                   info.label,
//                   style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       // ถ้าสถานะยกเลิกให้สีดำ ถ้าคืนสินค้าให้สีส้ม/พีชตาม config
//                       color: status == OrderStatus.cancelled
//                           ? Colors.black
//                           : info.color),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 8),

//             // --- วันที่และ Progress Bar ---
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text('วันที่ xx มิถุนายน 2568',
//                     style: TextStyle(color: Colors.grey, fontSize: 13)),
//                 SizedBox(
//                   width: 140,
//                   child: _buildDetailProgressBar(info),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 20),

//             // --- รูปภาพสินค้า ---
//             Container(
//               height: 220,
//               width: double.infinity,
//               decoration: BoxDecoration(
//                   color: Colors.grey[100],
//                   borderRadius: BorderRadius.circular(8)),
//               child: Image.asset(
//                 'assets/images/album.png', // ** เปลี่ยนเป็น path รูปของคุณ **
//                 fit: BoxFit.contain,
//                 errorBuilder: (context, error, stackTrace) {
//                   return const Center(
//                       child: Icon(Icons.photo, size: 50, color: Colors.grey));
//                 },
//               ),
//             ),

//             const SizedBox(height: 20),

//             // --- ที่อยู่ ---
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: const Color(0xFF333333),
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text('ที่อยู่',
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 10),
//                   const Text(
//                     'หมู่บ้าน สุวรรณภูมิทาวน์ซอย ลาดกระบัง 54/3 ถนนลาดกระบัง แขวงลาดกระบัง เขตลาดกระบัง กรุงเทพมหานคร',
//                     style: TextStyle(
//                         color: Colors.white70, fontSize: 13, height: 1.4),
//                   ),
//                   const SizedBox(height: 25),
//                   _buildInfoRow('ช่องทางชำระเงิน', 'QR พร้อมเพย์'),
//                   const SizedBox(height: 8),
//                   _buildInfoRow('ชำระเงิน', '10 ม.ค. 2025'),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 20),

//             // ==========================================================
//             // CASE 1: สถานะ "กำลังส่ง" (Shipping)
//             // ==========================================================
//             if (status == OrderStatus.shipping) ...[
//               _buildStatusBlueBox(
//                 context, 
//                 title: 'พัสดุอยู่ระหว่างการนำส่ง', 
//                 time: '9 มิ.ย. 11:00'
//               ),
//               const SizedBox(height: 20),
//               // ปุ่มยืนยัน
//               SizedBox(
//                 width: double.infinity,
//                 height: 50,
//                 child: ElevatedButton(
//                   onPressed: () => _showConfirmDialog(context),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFFF05A28),
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8)),
//                     elevation: 0,
//                   ),
//                   child: const Text('ยืนยันการจัดส่ง',
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16)),
//                 ),
//               ),
//               const SizedBox(height: 20),
//             ],

//             // ==========================================================
//             // CASE 2: สถานะ "คืนสินค้า" (Returned) - เพิ่มส่วนนี้
//             // ==========================================================
//             if (status == OrderStatus.returned) ...[
//               _buildStatusBlueBox(
//                 context, 
//                 title: 'คืนสินค้า',  // ข้อความตามรูป
//                 time: '9 มิ.ย. 11:00'
//               ),
//               const SizedBox(height: 40), // เว้นระยะด้านล่างเฉยๆ ไม่มีปุ่ม
//             ]
//           ],
//         ),
//       ),
//     );
//   }

//   // Widget สร้างกล่องสีฟ้า (ใช้ร่วมกันทั้ง Shipping และ Returned)
//   Widget _buildStatusBlueBox(BuildContext context, {required String title, required String time}) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (context) => const TrackingTimelinePage()),
//         );
//       },
//       child: Container(
//         width: double.infinity,
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//         decoration: BoxDecoration(
//           color: const Color(0xFF59A5B3), // สีฟ้าอมเขียว
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: const Color(0xFF59A5B3).withOpacity(0.3),
//               blurRadius: 8,
//               offset: const Offset(0, 4),
//             )
//           ],
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                       fontWeight: FontWeight.w500),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   time,
//                   style: const TextStyle(color: Colors.white70, fontSize: 13),
//                 ),
//               ],
//             ),
//             const Icon(Icons.arrow_forward_ios,
//                 color: Colors.white, size: 16),
//           ],
//         ),
//       ),
//     );
//   }

//   // Helper Widgets
//   Widget _buildInfoRow(String label, String value) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(label,
//             style: const TextStyle(color: Colors.white70, fontSize: 14)),
//         Text(value,
//             style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500)),
//       ],
//     );
//   }

//   void _showConfirmDialog(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true, 
//       backgroundColor: Colors.transparent,
//       builder: (context) {
//         return Container(
//           decoration: const BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//           ),
//           padding: EdgeInsets.only(
//             bottom: MediaQuery.of(context).viewInsets.bottom,
//             left: 20,
//             right: 20,
//             top: 10,
//           ),
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Center(
//                   child: Container(
//                     width: 40, height: 4,
//                     margin: const EdgeInsets.only(bottom: 20),
//                     decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
//                   ),
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text('ยืนยันการจัดส่ง', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                     IconButton(icon: const Icon(Icons.close, color: Colors.grey), onPressed: () => Navigator.pop(context)),
//                   ],
//                 ),
//                 const SizedBox(height: 10),
//                 RichText(
//                   text: const TextSpan(
//                     text: 'แนบไฟล์หลักฐาน ',
//                     style: TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.w600),
//                     children: [TextSpan(text: '*', style: TextStyle(color: Colors.red))],
//                   ),
//                 ),
//                 const Text('อัปโหลดรูปภาพ (.png, .jpg)', style: TextStyle(color: Colors.grey, fontSize: 12)),
//                 const SizedBox(height: 10),
//                 GestureDetector(
//                   onTap: () {},
//                   child: CustomPaint(
//                     painter: _DashedRectPainter(color: Colors.grey, strokeWidth: 1.0, gap: 5.0),
//                     child: Container(
//                       height: 100, width: double.infinity, alignment: Alignment.center,
//                       child: RichText(
//                         textAlign: TextAlign.center,
//                         text: TextSpan(
//                           text: 'เปิดกล้องหรือ ',
//                           style: TextStyle(color: Colors.grey[600], fontSize: 14),
//                           children: const [TextSpan(text: 'เลือกจากไฟล์ที่มี', style: TextStyle(color: Colors.blue))],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 TextField(
//                   maxLines: 4,
//                   decoration: InputDecoration(
//                     hintText: 'คำติชมเพิ่มเติม',
//                     hintStyle: TextStyle(color: Colors.grey[400]),
//                     contentPadding: const EdgeInsets.all(12),
//                     border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[300]!)),
//                     enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[300]!)),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 SizedBox(
//                   width: double.infinity, height: 50,
//                   child: ElevatedButton(
//                     onPressed: () { Navigator.pop(context); },
//                     style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF05A28), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)), elevation: 0),
//                     child: const Text('ยืนยัน', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
//                   ),
//                 ),
//                 const SizedBox(height: 30),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   // Config Logic
//   _StatusConfig _getStatusInfo(OrderStatus status) {
//     const kOrange = Color(0xFFF05A28);
//     const kGreen = Color(0xFF28C668);
//     const kRed = Color(0xFFFF3B30);
//     const kPeach = Color(0xFFFDCB9E); // สีส้มอ่อน/พีช สำหรับคืนสินค้า
//     Widget icon(IconData data) => Icon(data, color: Colors.white, size: 18);
//     Widget truckIcon() => const Icon(Icons.local_shipping, color: Colors.white, size: 18);
//     // ใช้รูปรถเป็น Placeholder ถ้าคุณมีรูปกล่อง (assets/icons/cube.png) ให้ใช้ Image.asset แทน
//     Widget returnIcon() => const Icon(Icons.inventory_2, color: Colors.white, size: 18); 

//     switch (status) {
//       case OrderStatus.waitingPayment:
//         return _StatusConfig('รอชำระ', 1, kOrange, const Icon(Icons.bookmark, color: Colors.white, size: 18));
//       case OrderStatus.printing:
//         return _StatusConfig('สั่งพิมพ์', 2, kOrange, icon(Icons.print));
//       case OrderStatus.preparing:
//         return _StatusConfig('เตรียมจัดส่ง', 2, kOrange, truckIcon());
//       case OrderStatus.shipping:
//         return _StatusConfig('ที่ต้องได้รับ', 3, kOrange, truckIcon());
//       case OrderStatus.completed:
//         return _StatusConfig('สำเร็จ', 4, kGreen, icon(Icons.check), isFull: true);
//       // ** แก้ไขส่วนคืนสินค้า **
//       case OrderStatus.returned:
//         // ใช้สี Peach (ส้มอ่อน) และ 4 Bars (เต็มหลอด หรือปรับตามต้องการ)
//         return _StatusConfig('คืนสินค้า', 4, kPeach, returnIcon());
//       case OrderStatus.cancelled:
//         return _StatusConfig('ยกเลิก', 4, kRed, icon(Icons.lock_outline), isFull: true);
//     }
//   }

//   Widget _buildDetailProgressBar(_StatusConfig config) {
//     return SizedBox(
//       height: 32,
//       child: LayoutBuilder(
//         builder: (context, constraints) {
//           double width = constraints.maxWidth;
//           double iconSize = 30.0;
//           double segmentWidth = (width - iconSize) / 3;
//           double iconLeftPos = (config.barCount - 1) * segmentWidth;
//           if (iconLeftPos < 0) iconLeftPos = 0;
//           if (iconLeftPos > width - iconSize) iconLeftPos = width - iconSize;

//           return Stack(
//             alignment: Alignment.centerLeft,
//             children: [
//               Container(
//                 margin: EdgeInsets.only(left: 2, right: iconSize / 2),
//                 height: 6, width: double.infinity,
//                 decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(3)),
//               ),
//               Container(
//                 margin: const EdgeInsets.only(left: 2),
//                 height: 6, width: iconLeftPos + (iconSize / 2),
//                 decoration: BoxDecoration(color: config.color, borderRadius: BorderRadius.circular(3)),
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: List.generate(4, (index) {
//                   if (index == 3) return const SizedBox.shrink();
//                   return Container(margin: EdgeInsets.only(left: segmentWidth), width: 2, height: 6, color: Colors.white);
//                 }),
//               ),
//               Positioned(
//                 left: iconLeftPos,
//                 child: Container(
//                   width: iconSize, height: iconSize,
//                   decoration: BoxDecoration(
//                     color: config.color, shape: BoxShape.circle,
//                     border: Border.all(color: Colors.white, width: 2),
//                     boxShadow: [BoxShadow(color: config.color.withOpacity(0.4), blurRadius: 4, offset: const Offset(0, 2))],
//                   ),
//                   child: Center(child: config.iconWidget),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }

// class _StatusConfig {
//   final String label;
//   final int barCount;
//   final Color color;
//   final Widget iconWidget;
//   final bool isFull;
//   _StatusConfig(this.label, this.barCount, this.color, this.iconWidget, {this.isFull = false});
// }

// // ==============================================================================
// // 2. PAGE: หน้า Timeline สถานะสินค้า (TrackingTimelinePage)
// // ==============================================================================
// class TrackingTimelinePage extends StatelessWidget {
//   const TrackingTimelinePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black87), onPressed: () => Navigator.pop(context)),
//         title: const Text('สถานะสินค้า', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(20),
//               decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE)))),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     width: 60, height: 60,
//                     decoration: BoxDecoration(
//                       color: Colors.grey[200], borderRadius: BorderRadius.circular(4),
//                       image: const DecorationImage(image: AssetImage('assets/images/album.png'), fit: BoxFit.cover),
//                     ),
//                   ),
//                   const SizedBox(width: 15),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text('อัลบั้มสำหรับใส่รูปครอบครัว', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
//                         const SizedBox(height: 4),
//                         Text('สีส้ม   X1', style: TextStyle(color: Colors.grey[400], fontSize: 14)),
//                       ],
//                     ),
//                   ),
//                   const Text('฿ 599', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                 ],
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Column(
//                 children: [
//                   _buildTimelineItem(date: '9 มิ.ย.', time: '11:00', status: 'คืนสินค้าสำเร็จ', isFirst: true, isActive: true),
//                   _buildTimelineItem(date: '8 มิ.ย.', time: '11:00', status: 'ร้านค้าได้รับสินค้าคืน', isFirst: false),
//                   _buildTimelineItem(date: '7 มิ.ย.', time: '11:00', status: 'ส่งคืนสินค้า', isFirst: false),
//                   _buildTimelineItem(date: '6 มิ.ย.', time: '11:00', status: 'คำขอคืนเงินได้รับการอนุมัติ', isFirst: false, isLast: true),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTimelineItem({required String date, required String time, required String status, bool isFirst = false, bool isLast = false, bool isActive = false}) {
//     return IntrinsicHeight(
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
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
//           Column(
//             children: [
//               Container(width: 2, height: 5, color: isFirst ? Colors.transparent : Colors.grey[300]),
//               Container(width: 12, height: 12, decoration: BoxDecoration(color: isActive ? const Color(0xFF28C668) : Colors.grey[300], shape: BoxShape.circle)),
//               Expanded(child: Container(width: 2, color: isLast ? Colors.transparent : Colors.grey[300])),
//             ],
//           ),
//           const SizedBox(width: 15),
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.only(bottom: 30),
//               child: Text(
//                 status,
//                 style: TextStyle(color: isActive ? const Color(0xFF28C668) : Colors.grey[500], fontSize: 14, fontWeight: isActive ? FontWeight.w500 : FontWeight.normal),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // Helper Class
// class _DashedRectPainter extends CustomPainter {
//   final double strokeWidth;
//   final Color color;
//   final double gap;
//   _DashedRectPainter({this.strokeWidth = 1.0, this.color = Colors.grey, this.gap = 5.0});
//   @override
//   void paint(Canvas canvas, Size size) {
//     Paint dashedPaint = Paint()..color = color..strokeWidth = strokeWidth..style = PaintingStyle.stroke;
//     double x = size.width; double y = size.height;
//     canvas.drawPath(getDashedPath(a: const Offset(0, 0), b: Offset(x, 0), gap: gap), dashedPaint);
//     canvas.drawPath(getDashedPath(a: Offset(x, 0), b: Offset(x, y), gap: gap), dashedPaint);
//     canvas.drawPath(getDashedPath(a: Offset(0, y), b: Offset(x, y), gap: gap), dashedPaint);
//     canvas.drawPath(getDashedPath(a: const Offset(0, 0), b: Offset(0, y), gap: gap), dashedPaint);
//   }
//   Path getDashedPath({required Offset a, required Offset b, required double gap}) {
//     Size size = Size(b.dx - a.dx, b.dy - a.dy); Path path = Path(); path.moveTo(a.dx, a.dy); bool shouldDraw = true; Offset currentPoint = Offset(a.dx, a.dy); double radians = (size.width == 0) ? 1.5708 : 0.0; double distance = (size.width == 0) ? size.height.abs() : size.width.abs();
//     for (double i = 0; i < distance; i += gap) {
//       if (shouldDraw) {
//         if (radians == 0.0) { path.lineTo(currentPoint.dx + gap, currentPoint.dy); currentPoint = Offset(currentPoint.dx + gap, currentPoint.dy); } else { path.lineTo(currentPoint.dx, currentPoint.dy + gap); currentPoint = Offset(currentPoint.dx, currentPoint.dy + gap); }
//       } else {
//         if (radians == 0.0) { path.moveTo(currentPoint.dx + gap, currentPoint.dy); currentPoint = Offset(currentPoint.dx + gap, currentPoint.dy); } else { path.moveTo(currentPoint.dx, currentPoint.dy + gap); currentPoint = Offset(currentPoint.dx, currentPoint.dy + gap); }
//       }
//       shouldDraw = !shouldDraw;
//     }
//     return path;
//   }
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }