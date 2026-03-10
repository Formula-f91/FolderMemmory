import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:wememmory/models/media_item.dart';

// หน้า stack การ์ด 4 ใบ ในการแชร์ของเดือนนี้
class FanStackDetailPage extends StatelessWidget {
  final String monthName;
  final List<MediaItem> items;

  const FanStackDetailPage({
    super.key,
    required this.monthName,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
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
      body: Column(
        children: [
          const SizedBox(height: 10),
          // --- Title Section ---
          Center(
            child: Column(
              children: [
                Text(
                  "ความทรงจำใน$monthName",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "0 ครั้งที่แชร์ไปในเดือนนี้",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          
          // --- List Section ---
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: 4, // จำลองข้อมูล 4 รายการ
              itemBuilder: (context, index) {
                int day = 4 - index; 
                
                // ✅ ตรวจสอบว่าเป็นแถวคู่หรือคี่ เพื่อสลับตำแหน่ง
                bool isLeftAligned = index % 2 == 0; 

                return Padding(
                  padding: const EdgeInsets.only(bottom: 40.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: isLeftAligned
                        ? [
                            // แบบ A: รูปซ้าย - ข้อความขวา
                            Expanded(flex: 5, child: _buildFanImageStack()),
                            const SizedBox(width: 8 ),
                            Expanded(
                              flex: 4, 
                              child: _buildTextContent(day, CrossAxisAlignment.start)
                            ),
                          ]
                        : [
                            // แบบ B: ข้อความซ้าย - รูปขวา
                            Expanded(
                              flex: 4, 
                              child: _buildTextContent(day, CrossAxisAlignment.end)
                            ),
                            const SizedBox(width: 26),
                            Expanded(flex: 5, child: _buildFanImageStack()),
                          ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // --- Helper Method: สร้าง Text Content ---
  Widget _buildTextContent(int day, CrossAxisAlignment alignment) {
    return Column(
      crossAxisAlignment: alignment, // จัดชิดซ้ายหรือขวาตามที่ส่งมา
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "$day $monthName 2025",
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          "ผู้ที่เข้าชม 23+",
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  // --- Helper Methods: Fan Stack (คงเดิม) ---
  Widget _buildFanImageStack() {
    final displayItems = items.take(4).toList();
    return SizedBox(
      height: 120, 
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          for (int i = 0; i < displayItems.length; i++)
            _buildFanItem(displayItems[i], index: i),
        ],
      ),
    );
  }

  Widget _buildFanItem(MediaItem item, {required int index}) {
    const double cardWidth = 104.0;
    const double cardHeight = 91.0;

    List<double> rotations = [0.08, -0.1, 0.08, -0.1];
    double angle = (index < rotations.length) ? rotations[index] : 0.0;
    
    double leftOffset = index * 18.0; 

    return Positioned(
      left: leftOffset,
      top: 25,
      child: Transform.rotate(
        angle: angle,
        child: Container(
          width: cardWidth,
          height: cardHeight,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(1, 2),
              ),
            ],
            border: Border.all(color: Colors.white, width: 1),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(7),
            child: _buildImage(item),
          ),
        ),
      ),
    );
  }

  Widget _buildImage(MediaItem item) {
    if (item.capturedImage != null) {
      return Image.memory(item.capturedImage!, fit: BoxFit.cover);
    } else {
      return FutureBuilder<Uint8List?>(
        future: item.asset.thumbnailDataWithSize(const ThumbnailSize(200, 200)),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return Image.memory(snapshot.data!, fit: BoxFit.cover);
          }
          return Container(color: Colors.grey[200]);
        },
      );
    }
  }
}