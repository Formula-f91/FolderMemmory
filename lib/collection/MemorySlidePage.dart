import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:wememmory/models/media_item.dart';

// หน้า รูปภาพจากแท็คสามารถเลือน slide ได้
class MemorySlidePage extends StatelessWidget {
  final String monthName;
  final List<MediaItem> items;

  const MemorySlidePage({
    super.key,
    required this.monthName,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    // แบ่งข้อมูลออกเป็น 2 ชุดสำหรับ 2 แถว
    final int halfLength = (items.length / 2).ceil();
    final List<MediaItem> firstRowItems = items.take(halfLength).toList();
    final List<MediaItem> secondRowItems = items.skip(halfLength).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // ให้หัวข้อชิดซ้าย
          children: [
            // --- ส่วนหัวข้อ (ย้ายจาก AppBar มาไว้ตรงนี้) ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Center(
                // ใช้ Center เพื่อให้ข้อความอยู่กลางหน้าจอตามภาพต้นฉบับ
                child: Column(
                  children: [
                    Text(
                      "ความทรงจำใน$monthName",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 22, // ปรับขนาดให้ใหญ่ขึ้นเล็กน้อย
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "100 แท็กที่ใช้ไปในเดือนนี้",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // --- แถวที่ 1 ---
            _buildMemoryRow(firstRowItems, "#ครอบครัว"),

            const SizedBox(height: 40), // ระยะห่างระหว่างกลุ่มแถว
            // --- แถวที่ 2 ---
            _buildMemoryRow(secondRowItems, "#ความรัก"),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ฟังก์ชันสร้างแถวที่มี Tag กำกับแค่คำเดียวด้านล่าง
  Widget _buildMemoryRow(List<MediaItem> rowItems, String tagLabel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ส่วนของรายการรูปภาพที่เลื่อนได้
        SizedBox(
          height: 300, // ปรับความสูงของการ์ด
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: rowItems.length,
            itemBuilder: (context, index) {
              return Container(
                width: 220, // ความกว้างของการ์ด
                margin: const EdgeInsets.only(right: 16, bottom: 10, top: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: _StaticPhotoSlot(item: rowItems[index]),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(8, 0, 8, 12),
                      child: Text(
                        "อากาศดี วิวสวย ครอบครัวพร้อม",
                        style: TextStyle(fontSize: 12, color: Colors.black87),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),

        // --- ส่วนของ Tag (แสดงแค่คำเดียวชิดซ้ายใต้แถว) ---
        Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 8),
          child: Text(
            tagLabel,
            style: const TextStyle(
              color: Color(0xFFED7D31),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

// _StaticPhotoSlot คงเดิมตามที่คุณมี...
class _StaticPhotoSlot extends StatelessWidget {
  final MediaItem item;
  const _StaticPhotoSlot({required this.item});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(2),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (item.capturedImage != null)
            Image.memory(item.capturedImage!, fit: BoxFit.cover)
          else
            FutureBuilder<Uint8List?>(
              future: item.asset.thumbnailDataWithSize(
                const ThumbnailSize(400, 400),
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.data != null) {
                  return Image.memory(snapshot.data!, fit: BoxFit.cover);
                }
                return Container(color: Colors.grey[100]);
              },
            ),
        ],
      ),
    );
  }
}
