import 'package:flutter/material.dart';
import 'package:wememmory/home/widgets/AchievementLayout.dart';
import 'package:wememmory/home/widgets/Recommended.dart';
import 'package:wememmory/home/widgets/summary_strip.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wememmory/models/media_item.dart';

class HomePage extends StatefulWidget {
  final List<MediaItem>? newAlbumItems;
  final String? newAlbumMonth;

  const HomePage({super.key, this.newAlbumItems, this.newAlbumMonth});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<MediaItem>? _currentAlbumItems;
  String? _currentAlbumMonth;

  @override
  void initState() {
    super.initState();
    _currentAlbumItems = widget.newAlbumItems;
    _currentAlbumMonth = widget.newAlbumMonth;
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    // ถ้าดึงชื่อไม่ได้ (เช่น เกิด error หรือตั้งค่าไม่ทัน) จะใช้คำว่า 'User' เป็นค่าเริ่มต้น (Fallback)
    final userName = user?.displayName ?? 'User';
    final photoUrl = user?.photoURL;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: const Color(0xFFFFB085),
            elevation: 0,
            toolbarHeight: 110,
            pinned: false,
            floating: false,
            snap: false,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.elliptical(420, 70),
              ),
            ),
            automaticallyImplyLeading: false,
            titleSpacing: 24,
            title: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image:
                        photoUrl != null
                            ? DecorationImage(
                              image: NetworkImage(
                                photoUrl,
                              ), // ดึงรูปจาก Firebase Storage
                              fit: BoxFit.cover,
                            )
                            : const DecorationImage(
                              image: AssetImage(
                                'assets/images/userpic.png',
                              ), // รูป Default ถ้าไม่มีรูปในระบบ
                              fit: BoxFit.cover,
                            ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  // ✅ 3. นำตัวแปร userName มาแสดงผลแทน 'Sippawit'
                  child: Text(
                    userName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      height: 1.2,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            actions: [
              // IconButton(
              //   onPressed: () {
              //     Navigator.of(context).push(
              //       MaterialPageRoute(builder: (_) => const NotificationPage()),
              //     );
              //   },
              //   icon: const Icon(Icons.notifications, color: Colors.white, size: 25),
              // ),
              const SizedBox(width: 12),
            ],
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Recommended(
                    albumItems: _currentAlbumItems,
                    albumMonth: _currentAlbumMonth,
                  ),
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
    );
  }
}
