import 'dart:ui'; // ✅ จำเป็นสำหรับ ImageFilter.blur

import 'package:flutter/material.dart';
import 'package:wememmory/Album/createAlbumModal.dart';
import 'package:wememmory/constants.dart';
import 'package:wememmory/home/homePage.dart';
import 'package:wememmory/collection/collectionPage.dart';
import 'package:wememmory/shop/shopPage.dart';
import 'package:wememmory/profile/profilePage.dart';
import 'package:wememmory/models/media_item.dart';

class FirstPage extends StatefulWidget {
  
  final int initialIndex;
  final List<MediaItem>? newAlbumItems;
  final String? newAlbumMonth;

  const FirstPage({
    super.key,
    this.initialIndex = 0,
    this.newAlbumItems,
    this.newAlbumMonth,
  });

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  // ... (คงเดิม)
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _showCreateAlbumModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const CreateAlbumModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ... (pages list คงเดิม)
    final List<Widget> pages = [
      HomePage(
        newAlbumItems: widget.newAlbumItems,
        newAlbumMonth: widget.newAlbumMonth,
      ),
      CollectionPage(
        newAlbumItems: widget.newAlbumItems,
        newAlbumMonth: widget.newAlbumMonth,
      ),
      const SizedBox(),
      const ShopPage(),
      const ProfilePage(),
    ];

    return Scaffold(
      backgroundColor: kBackgroundColor,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(
            child: IndexedStack(
              index: _currentIndex,
              children: pages,
            ),
          ),
          // ✅ ปรับ Positioned ให้ชิดขอบล่าง
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: CustomBottomNavBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                if (index == 2) {
                  _showCreateAlbumModal();
                } else {
                  setState(() => _currentIndex = index);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ✅✅✅ ส่วนที่ปรับปรุงหลัก: CustomBottomNavBar ✅✅✅
class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // สีต่างๆ คงเดิม
    const Color activeIconColor = Color(0xFF67A5BA); 
    const Color inactiveIconColor = Color(0xFF555555); 
    const Color centerButtonColor = Color(0xFFED7D31); 
    const Color staticTextColor = Color(0xFF3C3C3B); 

    // ✅ เอา Padding รอบนอกออกเพื่อให้เต็มจอ
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // --- Layer 1: Shadow (เงาด้านบน) ---
        Container(
          height: 80, // ปรับความสูงเล็กน้อยให้รับกับ Safe Area ด้านล่าง
          decoration: BoxDecoration(
            color: Colors.transparent,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05), // เงาบางๆ ด้านบน
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
        ),
        // --- Layer 2: Blurred Background & Content ---
        ClipRRect(
          // ✅ ปรับ Radius เฉพาะด้านบน (ถ้าต้องการให้ดูมนๆ) หรือลบออกถ้าอยากได้เหลี่ยม
          // borderRadius: const BorderRadius.only(
          //   topLeft: Radius.circular(20),
          //   topRight: Radius.circular(20),
          // ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              height: 96, // ความสูงแถบ
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                // border: Border(top: BorderSide(color: Colors.white.withOpacity(0.2), width: 0.5)), // ขอบบนบางๆ
              ),
              child: SafeArea( // ✅ เพิ่ม SafeArea เพื่อรองรับมือถือรุ่นใหม่ (ไม่มีปุ่มโฮม)
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 12, 10, 0), // Padding ซ้ายขวาภายใน
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 1. หน้าหลัก
                      Expanded(
                        child: _buildNavItem(
                          iconPath: 'assets/icons/homePage.png',
                          label: 'หน้าหลัก',
                          index: 0,
                          isActive: currentIndex == 0,
                          activeColor: activeIconColor,
                          inactiveColor: inactiveIconColor,
                          textColor: staticTextColor,
                          width: 20,
                          height: 21.88,
                        ),
                      ),
                      
                      // 2. สมุดภาพ
                      Expanded(
                        child: _buildNavItem(
                          iconPath: 'assets/icons/albumPage.png',
                          label: 'สมุดภาพ',
                          index: 1,
                          isActive: currentIndex == 1,
                          activeColor: activeIconColor,
                          inactiveColor: inactiveIconColor,
                          textColor: staticTextColor,
                          width: 25,
                          height: 25,
                        ),
                      ),

                      // 3. ปุ่มตรงกลาง (Add Button)
                      Expanded(
                        child: Center(
                          child: GestureDetector(
                            onTap: () => onTap(2),
                            child: Container(
                              width: 44,
                              height: 44,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: Image.asset(
                                'assets/icons/btupload.png',
                                width: 44,
                                height: 44,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // 4. ร้านค้า
                      Expanded(
                        child: _buildNavItem(
                          iconPath: 'assets/icons/ShopPage.png',
                          label: 'ร้านค้า',
                          index: 3,
                          isActive: currentIndex == 3,
                          activeColor: activeIconColor,
                          inactiveColor: inactiveIconColor,
                          textColor: staticTextColor,
                          width: 20,
                          height: 25,
                        ),
                      ),

                      // 5. บัญชี
                      Expanded(
                        child: _buildNavItem(
                          iconPath: 'assets/icons/ProfilePage.png',
                          label: 'บัญชี',
                          index: 4,
                          isActive: currentIndex == 4,
                          activeColor: activeIconColor,
                          inactiveColor: inactiveIconColor,
                          textColor: staticTextColor,
                          width: 22.5,
                          height: 22.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ✅ ฟังก์ชันสร้าง Item (คงเดิม)
  Widget _buildNavItem({
    required String iconPath,
    required String label,
    required int index,
    required bool isActive,
    required Color activeColor,
    required Color inactiveColor,
    required Color textColor,
    required double width,
    required double height,
  }) {
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 28, 
            child: Center(
              child: Image.asset(
                iconPath,
                width: width,
                height: height,
                color: isActive ? activeColor : inactiveColor,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: textColor, 
              fontSize: 10, // ปรับขนาดตัวหนังสือให้พอดี
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}