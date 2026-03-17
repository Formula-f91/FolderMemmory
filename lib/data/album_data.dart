import '../models/media_item.dart';

// ✅ Model สำหรับรูปที่โหลดจาก Firebase Storage
class StoragePhoto {
  final int index;
  final String url;
  final String caption;
  final List<String> tags;

  StoragePhoto({
    required this.index,
    required this.url,
    required this.caption,
    required this.tags,
  });
}

// ฐานเก็บข้อมูล อัลบั้ม
class AlbumCollection {
  final String month;
  final List<MediaItem> items;
  // ✅ เพิ่ม storagePhotos สำหรับอัลบั้มที่โหลดจาก Firebase
  final List<StoragePhoto> storagePhotos;

  AlbumCollection({
    required this.month,
    required this.items,
    this.storagePhotos = const [],
  });
}

// นี่คือตัวแปรที่จะเก็บข้อมูลอัลบั้มทั้งหมดไว้ ไม่ให้หายไปเมื่อเปลี่ยนหน้า
List<AlbumCollection> globalAlbumList = <AlbumCollection>[];