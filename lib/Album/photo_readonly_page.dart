import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:wememmory/models/media_item.dart';

class PhotoReadonlyPage extends StatefulWidget {
  final MediaItem item;

  const PhotoReadonlyPage({super.key, required this.item});

  @override
  State<PhotoReadonlyPage> createState() => _PhotoReadonlyPageState();
}

class _PhotoReadonlyPageState extends State<PhotoReadonlyPage> {
  Uint8List? _imageData;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  // โหลดรูปความละเอียดสูงมาแสดง
  Future<void> _loadImage() async {
    if (widget.item.capturedImage != null) {
      setState(() {
        _imageData = widget.item.capturedImage;
      });
    } else {
      // โหลดรูปใหญ่หน่อยเพื่อความชัด (1000x1000)
      final data = await widget.item.asset.thumbnailDataWithSize(const ThumbnailSize(1000, 1000));
      if (mounted) {
        setState(() {
          _imageData = data;
        });
      }
    }
  }

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
        title: const Text(
          "รายละเอียดรูปภาพ",
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. ส่วนแสดง Tags (ถ้ามี)
            if (widget.item.tags.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: widget.item.tags.map((tag) => _buildTag(tag)).toList(),
                ),
              ),

            // 2. ส่วนแสดงรูปภาพ (อยู่ตรงกลาง)
            Container(
              width: double.infinity,
              // กำหนดความสูงขั้นต่ำและสูงสุดเพื่อให้ดูสวยงาม
              constraints: const BoxConstraints(minHeight: 200, maxHeight: 500),
              color: Colors.grey[100],
              child: _imageData != null
                  ? Image.memory(_imageData!, fit: BoxFit.contain)
                  : const Center(child: CircularProgressIndicator()),
            ),

            // 3. ส่วนแสดงข้อความ Caption
            if (widget.item.caption.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  widget.item.caption,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    height: 1.5, // เพิ่มระยะห่างบรรทัดให้อ่านง่าย
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Widget สร้างป้าย Tag สีส้มอ่อน
  Widget _buildTag(String text) {
    Color bgColor = const Color(0xFFFFE0CC); // สีพื้นหลังส้มอ่อน
    Color textColor = const Color(0xFFED7D31); // สีตัวหนังสือส้มเข้ม

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(color: textColor, fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }
}