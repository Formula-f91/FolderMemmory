import 'package:flutter/material.dart';
import 'package:wememmory/collection/collectionPage.dart';
import 'package:wememmory/home/widgets/AchievementLayout.dart';
import 'package:wememmory/home/widgets/Recommended.dart';
import 'package:wememmory/home/widgets/summary_strip.dart';
import 'package:wememmory/models/media_item.dart';

class HomePage extends StatefulWidget {
  // ✅ 1. ประกาศตัวแปรรับค่าให้ถูกต้อง (ลบอันเก่าที่ซ้ำซ้อนออก)
  final List<MediaItem>? newAlbumItems;
  final String? newAlbumMonth;

  const HomePage({
    super.key,
    // ✅ 2. รับค่าผ่าน Constructor
    this.newAlbumItems,
    this.newAlbumMonth,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ตัวแปร State สำหรับจัดการข้อมูลภายในหน้านี้
  List<MediaItem>? _currentAlbumItems;
  String? _currentAlbumMonth;

  @override
  void initState() {
    super.initState();
    // ✅ 3. กำหนดค่าเริ่มต้นจาก widget ที่รับมา
    _currentAlbumItems = widget.newAlbumItems;
    _currentAlbumMonth = widget.newAlbumMonth;
  }

  // (ฟังก์ชัน _navigateToCollection ไม่ได้ถูกใช้ในหน้านี้ อาจลบออกได้ถ้าไม่จำเป็น)
  // แต่ถ้าจะเก็บไว้เผื่ออนาคตก็ไม่เสียหายครับ

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFB085),
        elevation: 0,
        toolbarHeight: 110,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.elliptical(420, 70)),
        ),
        automaticallyImplyLeading: false, 
        titleSpacing: 24,
        title: Row(
          children: [
            // รูปโปรไฟล์
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle, 
                image: DecorationImage(
                  image: AssetImage('assets/images/userpic.png'), 
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 14),
            // ชื่อผู้ใช้
            const Text(
              'korawit',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w400,
                height: 1.2,
              ),
            ),
          ],
        ),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.notifications, color: Colors.white, size: 25)),
            ],
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  // 4. ส่งค่า _currentAlbumItems/Month ไปยัง Recommended
                  Recommended(
                    albumItems: _currentAlbumItems, // ใช้ตัวแปร state ที่รับค่ามาแล้ว
                    albumMonth: _currentAlbumMonth,
                  ),
                  const SummaryStrip(),
                  const SizedBox(height: 37),
                ],
              ),
            ),
            
            const SliverFillRemaining(
              hasScrollBody: false, 
              child: AchievementLayout(),
            ),
          ],
        ),
      ),
    );
  }
}