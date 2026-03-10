// import 'package:flutter/material.dart';
// import 'package:wememmory/profile/albumDetailPage.dart';

// class AlbumHistoryPage extends StatelessWidget {
//   const AlbumHistoryPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // กำหนดสีธีม
//     const kOrangeColor = Color(0xFFF05A28);
//     const kGreenColor = Color(0xFF28C668);
//     const kPeachColor = Color(0xFFFDCB9E);
//     const kPeachIconColor = Color(0xFFFDB67F);

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
//           style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w800),
//         ),
//       ),
//       body: ListView(
//         padding: EdgeInsets.zero,
//         children: [
//           // 1. Banner ส่วนหัว
//           const _HeaderBanner(),

//           const SizedBox(height: 20),

//           // --- รายการที่ 1: สั่งพิมพ์ (มี Tag ของขวัญ) ---
//           _HistoryCard(
//             title: 'อัลบั้ม',
//             statusText: 'สั่งพิมพ์',
//             barCount: 1, // ปรับตามสถานะจริง
//             isGift: true, // โชว์ Tag ของขวัญ
//             mainColor: kOrangeColor,
//             icon: Image.asset(
//               'assets/icons/truck.png', 
//               width: 18, height: 18, color: Colors.white,
//             ),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => AlbumDetailPage(
//                     statusTitle: 'สั่งพิมพ์',
//                     statusText: 'รอชำระ',
//                     dateText: 'วันที่ 20 มิถุนายน 2568',
//                     barCount: 1,
//                     mainColor: kOrangeColor,
//                     icon: Image.asset(
//                       'assets/icons/truck.png',
//                       width: 24, height: 24, color: Colors.white,
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),

//           // --- รายการที่ 2: ที่ต้องได้รับ ---
//           _HistoryCard(
//             title: 'อัลบั้ม',
//             statusText: 'ที่ต้องได้รับ',
//             barCount: 3,
//             mainColor: kOrangeColor,
//             icon: Image.asset(
//               'assets/icons/truck.png',
//               width: 18, height: 18, color: Colors.white,
//             ),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => AlbumDetailPage(
//                     statusTitle: 'สั่งพิมพ์',
//                     statusText: 'เตรียมจัดส่ง',
//                     dateText: 'วันที่ 22 มิถุนายน 2568',
//                     barCount: 3,
//                     mainColor: kOrangeColor,
//                     icon: Image.asset(
//                       'assets/icons/truck.png',
//                       width: 24, height: 24, color: Colors.white,
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),

//           // --- รายการที่ 3: สำเร็จ ---
//           _HistoryCard(
//             title: 'อัลบั้ม',
//             statusText: 'สำเร็จ',
//             barCount: 4,
//             mainColor: kGreenColor,
//             isCompleted: true,
//             icon: const Icon(Icons.check, color: Colors.white, size: 18),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => const AlbumDetailPage(
//                     statusTitle: 'สั่งพิมพ์',
//                     statusText: 'สำเร็จ',
//                     dateText: 'วันที่ 25 มิถุนายน 2568',
//                     barCount: 4,
//                     mainColor: kGreenColor,
//                     icon: Icon(Icons.check, color: Colors.white, size: 24),
//                   ),
//                 ),
//               );
//             },
//           ),

//           // --- รายการที่ 4: คืนสินค้า ---
//           _HistoryCard(
//             title: 'อัลบั้ม',
//             statusText: 'คืนสินค้า',
//             barCount: 4, 
//             mainColor: kPeachColor,
//             overrideIconBgColor: kPeachIconColor,
//             icon: Image.asset(
//               'assets/icons/cube.png',
//               width: 18, height: 18, color: Colors.white,
//             ),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => AlbumDetailPage(
//                     statusTitle: 'สั่งพิมพ์',
//                     statusText: 'คืนสินค้า',
//                     dateText: 'วันที่ 26 มิถุนายน 2568',
//                     barCount: 3,
//                     mainColor: kPeachColor,
//                     overrideIconBgColor: kPeachIconColor,
//                     icon: Image.asset(
//                       'assets/icons/cube.png',
//                       width: 24, height: 24, color: Colors.white,
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),

//           const SizedBox(height: 40),
//         ],
//       ),
//     );
//   }
// }

// // -------------------------------------------------------------------
// // WIDGET: Banner ด้านบน
// // -------------------------------------------------------------------
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

// // -------------------------------------------------------------------
// // WIDGET: การ์ดประวัติ (รวม UI รูปภาพซ้อนกัน + Logic ของขวัญ)
// // -------------------------------------------------------------------
// class _HistoryCard extends StatelessWidget {
//   final String title;
//   final String statusText;
//   final int barCount;
//   final int totalBars;
//   final Color mainColor;
//   final Widget icon; 
//   final bool isCompleted;
//   final Color? overrideIconBgColor;
//   final bool isGift;
//   final VoidCallback? onTap;

//   const _HistoryCard({
//     required this.title,
//     required this.statusText,
//     required this.barCount,
//     this.totalBars = 4,
//     required this.mainColor,
//     required this.icon,
//     this.isCompleted = false,
//     this.overrideIconBgColor,
//     this.isGift = false,
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
//             BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               blurRadius: 10,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Column(
//           children: [
//             // ส่วนหัวการ์ด (Title + Gift Tag + Arrow)
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     Text(
//                       title,
//                       style: const TextStyle(
//                         fontWeight: FontWeight.w700,
//                         fontSize: 16,
//                       ),
//                     ),
//                     if (isGift) ...[
//                       const SizedBox(width: 8),
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 8,
//                           vertical: 4,
//                         ),
//                         decoration: BoxDecoration(
//                           color: const Color(0xFFFFF0EB),
//                           borderRadius: BorderRadius.circular(4),
//                         ),
//                         child: Row(
//                           children: [
//                             Image.asset(
//                               'assets/icons/gift.png',
//                               width: 14, height: 14,
//                               color: const Color(0xFFF05A28),
//                             ),
//                             const SizedBox(width: 4),
//                             const Text(
//                               'ของขวัญ',
//                               style: TextStyle(
//                                 color: Color(0xFFF05A28),
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ],
//                 ),
//                 Container(
//                   width: 32, height: 32,
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF5B9DA9),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: const Icon(
//                     Icons.arrow_forward,
//                     color: Colors.white,
//                     size: 18,
//                   ),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 12),

//             // ส่วนเนื้อหา (รูปภาพซ้อนกัน + Progress Bar)
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 // --- ส่วนแสดงรูปภาพซ้อนกัน (เอามาจาก OrderHistoryPage) ---
//                 SizedBox(
//                   width: 90, 
//                   height: 80,
//                   child: Stack(
//                     alignment: Alignment.center,
//                     children: [
//                       // รูปด้านหลัง (ซ้าย)
//                      Positioned(
//                         left: 0,
//                         top: 5,
//                         child: Transform.rotate(
//                           angle: 0.10, 
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
                      
//                       // รูปด้านหน้า (ขวา)
//                       Positioned(
//                         right: 0, 
//                         bottom: 0,
//                         child: Transform.rotate(
//                           angle: -0.10, 
//                           child: Container(
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(10),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black.withOpacity(0.15),
//                                   blurRadius: 5,
//                                   offset: const Offset(-2, 4)
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
                
//                 // --- ส่วน Progress Bar และ Text ---
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         statusText,
//                         style: const TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.black87,
//                         ),
//                       ),
//                       const SizedBox(height: 8),

//                       // Progress Bar
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

//                             if (barCount == totalBars) {
//                               iconLeftPos = barAreaWidth - (iconSize / 2);
//                             } else if (barCount == 1) {
//                               iconLeftPos = singleBarWidth - (iconSize / 2);
//                             }

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
//                                     width: iconSize,
//                                     height: iconSize,
//                                     decoration: BoxDecoration(
//                                       color: overrideIconBgColor ?? mainColor,
//                                       shape: BoxShape.circle,
//                                       border: Border.all(
//                                         color: Colors.white,
//                                         width: 2.5,
//                                       ),
//                                       boxShadow: [
//                                         BoxShadow(
//                                           color: (overrideIconBgColor ?? mainColor).withOpacity(0.4),
//                                           blurRadius: 4,
//                                           offset: const Offset(0, 3),
//                                         ),
//                                       ],
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
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }