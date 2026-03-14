import 'package:flutter/material.dart';
import 'package:wememmory/Album/upload_photo_page.dart';
import 'package:wememmory/data/album_data.dart'; // ✅ import globalAlbumList

class CreateAlbumModal extends StatefulWidget {
  const CreateAlbumModal({super.key});

  @override
  State<CreateAlbumModal> createState() => _CreateAlbumModalState();
}

class _CreateAlbumModalState extends State<CreateAlbumModal> {
  int selectedYear = 2026;
  final List<int> years = [2026, 2025, 2024, 2023, 2022, 2021, 2020];

  final List<String> thaiMonths = [
    "มกราคม",
    "กุมภาพันธ์",
    "มีนาคม",
    "เมษายน",
    "พฤษภาคม",
    "มิถุนายน",
    "กรกฎาคม",
    "สิงหาคม",
    "กันยายน",
    "ตุลาคม",
    "พฤศจิกายน",
    "ธันวาคม",
  ];

  // ✅ เช็คว่าอัลบั้มเดือน+ปีนี้สร้างแล้วหรือยัง โดยดูจาก globalAlbumList
  bool _isAlbumDone(String fullLabel) {
    return globalAlbumList.any((album) => album.month == fullLabel);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 61,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2.5),
            ),
          ),

          // 1. Header + Dropdown เลือกปี
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 10, 16, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'สร้างอัลบั้มรูป',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: selectedYear,
                      items:
                          years.map((int year) {
                            return DropdownMenuItem<int>(
                              value: year,
                              child: Text(
                                '$year',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          }).toList(),
                      onChanged: (int? newValue) {
                        if (newValue != null) {
                          setState(() => selectedYear = newValue);
                        }
                      },
                      icon: const Icon(Icons.keyboard_arrow_down),
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 2. Credit Info
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Column(
              children: [
                Text(
                  'คุณมีอยู่ 10 เครดิต',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  'ให้แต่ละเดือนบอกเล่าเรื่องราวของคุณ ผ่านภาพแห่งความทรงจำ',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),
          const Divider(height: 1, color: Colors.black12),

          // 3. List of Months
          Expanded(
            child: ListView.separated(
              itemCount: 12,
              physics: const BouncingScrollPhysics(),
              separatorBuilder:
                  (context, index) => const Divider(
                    height: 1,
                    indent: 24,
                    endIndent: 24,
                    color: Colors.black12,
                  ),
              itemBuilder: (context, index) {
                final monthIndex = 11 - index;
                final monthName = thaiMonths[monthIndex];
                final fullLabel = "$monthName $selectedYear";

                // ✅ เช็คจาก globalAlbumList จริงๆ
                final bool isDone = _isAlbumDone(fullLabel);

                return _AlbumOptionItem(month: fullLabel, isDone: isDone);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _AlbumOptionItem extends StatelessWidget {
  final String month;
  final bool isDone;

  const _AlbumOptionItem({required this.month, required this.isDone});

  void _showUploadPhotoSheet(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => UploadPhotoPage(selectedMonth: month),
    );
    // ✅ ไม่เรียก onUploaded() ที่นี่
    // Modal ถูก pop ไปก่อนแล้ว การเรียก setState จะเกิด "setState after dispose"
    // เมื่อผู้ใช้เปิด Modal ใหม่ จะ rebuild และอ่าน globalAlbumList ใหม่เองอัตโนมัติ
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:
          isDone
              ? null
              : () {
                Navigator.pop(context);
                Future.delayed(const Duration(milliseconds: 150), () {
                  if (context.mounted) {
                    _showUploadPhotoSheet(context);
                  }
                });
              },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    month,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: isDone ? Colors.grey[400] : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // ✅ แสดงสถานะ "สร้างอัลบั้มสำเร็จ" หรือ "สร้างอัลบั้ม"
                  Text(
                    isDone ? "สร้างอัลบั้มสำเร็จ" : "สร้างอัลบั้ม",
                    style: TextStyle(
                      fontSize: 13,
                      color:
                          isDone ? const Color(0xFF66BB6A) : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            // ✅ ไอคอนแสดงสถานะ
            if (isDone)
              const Icon(Icons.check_circle, color: Color(0xFF66BB6A), size: 24)
            else
              Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 24),
          ],
        ),
      ),
    );
  }
}
