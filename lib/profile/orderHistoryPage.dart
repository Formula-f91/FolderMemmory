// import 'package:flutter/material.dart';
// import 'package:wememmory/profile/orderDetailPage.dart';
// import 'package:wememmory/shop/paymentPage.dart'; 

// class OrderHistoryPage extends StatelessWidget {
//   const OrderHistoryPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // กำหนดสีธีมต่างๆ
//     const kOrangeColor = Color(0xFFF05A28);
//     const kGreenColor = Color(0xFF28C668);
//     const kRedColor = Color(0xFFFF3B30);
//     const kPeachColor = Color(0xFFFDCB9E);
//     const kPeachDarkColor = Color(0xFFFDB67F);

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
//           'ประวัติสินค้า',
//           style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w800),
//         ),
//       ),
//       body: ListView(
//         padding: EdgeInsets.zero,
//         children: [
//           // 1. Banner
//           const _HeaderBanner(),

//           const SizedBox(height: 20),

//           // Case 1: รอชำระ
//           _OrderCard(
//             statusText: 'รอชำระ',
//             barCount: 1,
//             totalBars: 4,
//             mainColor: kOrangeColor,
//             icon: Image.asset(
//               'assets/icons/truck.png', 
//               width: 18, height: 18, color: Colors.white,
//             ),
//             onTap: () {
//               Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PaymentPage()));
//             },
//           ),

//           // Case 2: เตรียมจัดส่ง
//           _OrderCard(
//             statusText: 'เตรียมจัดส่ง',
//             barCount: 2,
//             totalBars: 4,
//             mainColor: kOrangeColor,
//             icon: Image.asset(
//               'assets/icons/truck.png', 
//               width: 18, height: 18, color: Colors.white,
//             ),
//             onTap: () {
//               Navigator.push(context, MaterialPageRoute(builder: (context) => const OrderDetailPage(status: OrderStatus.preparing)));
//             },
//           ),

//           // Case 3: อยู่ระหว่างขนส่ง
//           _OrderCard(
//             statusText: 'อยู่ระหว่างขนส่ง',
//             barCount: 3,
//             totalBars: 4,
//             mainColor: kOrangeColor,
//             icon: Image.asset(
//               'assets/icons/truck.png', 
//               width: 18, height: 18, color: Colors.white,
//             ),
//             onTap: () {
//               Navigator.push(context, MaterialPageRoute(builder: (context) => const OrderDetailPage(status: OrderStatus.shipping)));
//             },
//           ),

//           // Case 4: สำเร็จ
//           _OrderCard(
//             statusText: 'สำเร็จ',
//             barCount: 4,
//             totalBars: 4,
//             mainColor: kGreenColor,
//             isCompleted: true,
//             icon: const Icon(Icons.check, size: 18, color: Colors.white),
//             onTap: () {
//               Navigator.push(context, MaterialPageRoute(builder: (context) => const OrderDetailPage(status: OrderStatus.completed)));
//             },
//           ),

//           // Case 5: คืนสินค้า
//           _OrderCard(
//             statusText: 'คืนสินค้า',
//             barCount: 4,
//             totalBars: 4,
//             mainColor: kPeachColor,
//             overrideIconBgColor: kPeachDarkColor,
//             icon: Image.asset(
//               'assets/icons/cube.png', 
//               width: 18, height: 18, color: Colors.white,
//             ),
//             onTap: () {
//               Navigator.push(context, MaterialPageRoute(builder: (context) => const OrderDetailPage(status: OrderStatus.returned)));
//             },
//           ),
          
//           // Case 6: ยกเลิก
//            _OrderCard(
//             statusText: 'ยกเลิก',
//             barCount: 4,
//             totalBars: 4,
//             mainColor: kRedColor,
//             isCompleted: true,
//             icon: Image.asset(
//               'assets/icons/bag-cross.png', 
//               width: 18, height: 18, color: Colors.white,
//             ),
//             onTap: () {
//               Navigator.push(context, MaterialPageRoute(builder: (context) => const OrderDetailPage(status: OrderStatus.cancelled)));
//             },
//           ),

//           const SizedBox(height: 40),
//         ],
//       ),
//     );
//   }
// }

// // ------------------------------------------
// // Widgets ส่วนประกอบ
// // ------------------------------------------

// class _HeaderBanner extends StatelessWidget {
//   const _HeaderBanner();

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Image.asset(
//           'assets/images/bannerOrder.png',
//           width: double.infinity,
//           fit: BoxFit.fitWidth,
//         ),
//         Positioned.fill(
//           child: Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _OrderCard extends StatelessWidget {
//   final String statusText;
//   final int barCount;
//   final int totalBars;
//   final Color mainColor;
//   final Widget icon;
//   final bool isCompleted;
//   final Color? overrideIconBgColor;
//   final VoidCallback? onTap;

//   const _OrderCard({
//     required this.statusText,
//     required this.barCount,
//     this.totalBars = 4,
//     required this.mainColor,
//     required this.icon,
//     this.isCompleted = false,
//     this.overrideIconBgColor,
//     this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: const Color(0xFFEEEEEE)),
//           boxShadow: [
//             BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
//           ],
//         ),
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text('อัลบั้มสำหรับใส่รูปครอบครัว', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
//                 Container(
//                   width: 32, height: 32,
//                   decoration: BoxDecoration(color: const Color(0xFF5B9DA9), borderRadius: BorderRadius.circular(8)),
//                   child: const Icon(Icons.arrow_forward, color: Colors.white, size: 18),
//                 )
//               ],
//             ),
//             const SizedBox(height: 12),
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
                
//                 // ✅ ส่วนที่แก้ไข: สลับตำแหน่งซ้าย-ขวา
//                 SizedBox(
//                   width: 90, 
//                   height: 80,
//                   child: Stack(
//                     alignment: Alignment.center,
//                     children: [
//                       // --- รูปด้านหลัง (Back Layer) : ย้ายมาซ้าย ---
//                       Positioned(
//                         left: 0, // ชิดซ้าย
//                         top: 5,
//                         child: Transform.rotate(
//                           angle: 0.10, // เอียงซ้าย (ค่าลบ)
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(8),
//                             child: Opacity(
//                               opacity: 0.8,
//                               child: Image.asset(
//                                 'assets/images/order2.png', 
//                                 width: 70, 
//                                 height: 70, 
//                                 fit: BoxFit.cover
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
                      
//                       // --- รูปด้านหน้า (Front Layer) : ย้ายมาขวา ---
//                       Positioned(
//                         right: 0, // ชิดขวา
//                         bottom: 0,
//                         child: Transform.rotate(
//                           angle: -0.10, // เอียงขวา (ค่าบวก)
//                           child: Container(
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(10),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black.withOpacity(0.15),
//                                   blurRadius: 5,
//                                   offset: const Offset(-2, 4) // ปรับเงาให้สมจริงขึ้นเมื่อย้ายฝั่ง
//                                 )
//                               ]
//                             ),
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.circular(8),
//                               child: Image.asset(
//                                 'assets/images/order1.png', 
//                                 width: 70, 
//                                 height: 70, 
//                                 fit: BoxFit.cover
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
                
//                 const SizedBox(width: 16),
                
//                 // ส่วน Text และ Progress Bar (เหมือนเดิม)
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(statusText, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
//                       const SizedBox(height: 8),
//                       SizedBox(
//                         height: 40,
//                         child: LayoutBuilder(
//                           builder: (context, constraints) {
//                             double totalWidth = constraints.maxWidth;
//                             double iconSize = 36.0;
//                             double rightPadding = 20.0;
//                             double barAreaWidth = totalWidth - rightPadding;
//                             double singleBarWidth = barAreaWidth / totalBars;
//                             double iconLeftPos = (singleBarWidth * barCount) - (iconSize / 2);

//                             if (barCount == totalBars) iconLeftPos = barAreaWidth - (iconSize / 2);
//                             else if (barCount == 1) iconLeftPos = singleBarWidth - (iconSize / 2);

//                             return Stack(
//                               alignment: Alignment.centerLeft,
//                               children: [
//                                 Padding(
//                                   padding: EdgeInsets.only(right: rightPadding),
//                                   child: Row(
//                                     children: List.generate(totalBars, (index) {
//                                       bool isActive = index < barCount;
//                                       return Expanded(
//                                         child: Container(
//                                           margin: const EdgeInsets.only(right: 2),
//                                           height: 16,
//                                           decoration: BoxDecoration(
//                                             color: isActive ? mainColor : const Color(0xFFE0E0E0),
//                                             borderRadius: BorderRadius.circular(4),
//                                           ),
//                                         ),
//                                       );
//                                     }),
//                                   ),
//                                 ),
//                                 Positioned(
//                                   left: iconLeftPos,
//                                   child: Container(
//                                     width: iconSize, height: iconSize,
//                                     decoration: BoxDecoration(
//                                       color: overrideIconBgColor ?? mainColor,
//                                       shape: BoxShape.circle,
//                                       border: Border.all(color: Colors.white, width: 2.5),
//                                       boxShadow: [BoxShadow(color: (overrideIconBgColor ?? mainColor).withOpacity(0.4), blurRadius: 4, offset: const Offset(0, 3))],
//                                     ),
//                                     child: Center(child: icon),
//                                   ),
//                                 ),
//                               ],
//                             );
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }