import 'dart:typed_data';
import 'package:photo_manager/photo_manager.dart';

// ข้อมูลภาพและวิดิโอ

enum MediaType { image, video }   //ตัวระบุประเภทของไฟล์

class MediaItem {
  final AssetEntity asset; //ใช้ดึงรูป Thumbnail, ดึงไฟล์ต้นฉบับ, หรือดูวันที่ถ่าย
  final MediaType type;  //เก็บค่าจาก enum 
  String caption;   //เก็บ "คำบรรยาย" หรือความรู้สึกที่ user พิมพ์ใส่
  List<String> tags; //เก็บแท็กต่างๆ
  Uint8List? capturedImage; //รูปที่แคปแล้ว

  MediaItem({
    required this.asset,
    required this.type,
    this.caption = '',     // ค่าเริ่มต้นว่าง
    this.tags = const [],
    this.capturedImage,  // ค่าเริ่มต้น list ว่าง
  });
}

class AlbumPhoto {
  final MediaItem mediaItem;
  final Uint8List? imageBytes;
  AlbumPhoto({required this.mediaItem, this.imageBytes});
}

class AlbumCollection {
  final String month;
  final List<MediaItem> items;

  AlbumCollection({required this.month, required this.items});
}