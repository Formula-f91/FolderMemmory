import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:wememmory/data/album_data.dart';
import 'package:wememmory/models/media_item.dart';

// ✅ Unified photo model รองรับทั้ง local และ network
class ViewerPhoto {
  final String? networkUrl; // จาก Firebase Storage
  final MediaItem? mediaItem; // จาก device
  final String caption;
  final List<String> tags;

  ViewerPhoto.fromNetwork(StoragePhoto p)
    : networkUrl = p.url,
      mediaItem = null,
      caption = p.caption,
      tags = p.tags;

  ViewerPhoto.fromLocal(MediaItem item)
    : networkUrl = null,
      mediaItem = item,
      caption = item.caption,
      tags = item.tags;
}

// หน้าดูรูปแบบ fullscreen พร้อม swipe ซ้าย-ขวา
class PhotoViewerPage extends StatefulWidget {
  final List<ViewerPhoto> photos;
  final int initialIndex;

  const PhotoViewerPage({
    super.key,
    required this.photos,
    required this.initialIndex,
  });

  // ✅ Factory: สร้างจาก AlbumCollection (รองรับทั้ง local และ Firebase)
  factory PhotoViewerPage.fromAlbum({
    required AlbumCollection album,
    required int initialIndex,
  }) {
    late List<ViewerPhoto> photos;
    if (album.items.isNotEmpty) {
      photos = album.items.map((e) => ViewerPhoto.fromLocal(e)).toList();
    } else {
      photos =
          album.storagePhotos.map((e) => ViewerPhoto.fromNetwork(e)).toList();
    }
    return PhotoViewerPage(photos: photos, initialIndex: initialIndex);
  }

  // ✅ Factory: สร้างจาก List<MediaItem> (ใช้ใน MonthDetailPage เดิม)
  factory PhotoViewerPage.fromItems({
    required List<MediaItem> items,
    required int initialIndex,
  }) {
    final photos = items.map((e) => ViewerPhoto.fromLocal(e)).toList();
    return PhotoViewerPage(photos: photos, initialIndex: initialIndex);
  }

  @override
  State<PhotoViewerPage> createState() => _PhotoViewerPageState();
}

class _PhotoViewerPageState extends State<PhotoViewerPage> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // ── รูปภาพ swipe ซ้าย-ขวา ──
          PageView.builder(
            controller: _pageController,
            itemCount: widget.photos.length,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemBuilder: (context, index) {
              return _FullscreenPhotoSlot(photo: widget.photos[index]);
            },
          ),

          // ── Header ──
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${_currentIndex + 1} / ${widget.photos.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(width: 36),
                  ],
                ),
              ),
            ),
          ),

          // ── Caption & Tags ด้านล่าง ──
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomInfo(widget.photos[_currentIndex]),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomInfo(ViewerPhoto photo) {
    final hasCaption = photo.caption.isNotEmpty;
    final hasTags = photo.tags.isNotEmpty;
    if (!hasCaption && !hasTags) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Colors.black.withOpacity(0.8), Colors.transparent],
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasCaption)
            Text(
              photo.caption,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                height: 1.5,
              ),
            ),
          if (hasCaption && hasTags) const SizedBox(height: 8),
          if (hasTags)
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children:
                  photo.tags
                      .map(
                        (tag) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF67A5BA).withOpacity(0.7),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '#$tag',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      )
                      .toList(),
            ),
        ],
      ),
    );
  }
}

// ── Fullscreen slot รองรับทั้ง local และ network ──
class _FullscreenPhotoSlot extends StatefulWidget {
  final ViewerPhoto photo;
  const _FullscreenPhotoSlot({required this.photo});

  @override
  State<_FullscreenPhotoSlot> createState() => _FullscreenPhotoSlotState();
}

class _FullscreenPhotoSlotState extends State<_FullscreenPhotoSlot> {
  Uint8List? _imageData;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    if (widget.photo.networkUrl != null) return; // ใช้ Image.network แทน
    final item = widget.photo.mediaItem!;
    if (item.capturedImage != null) {
      if (mounted) setState(() => _imageData = item.capturedImage);
    } else {
      final data = await item.asset.thumbnailDataWithSize(
        const ThumbnailSize(1000, 1000),
      );
      if (mounted) setState(() => _imageData = data);
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Network photo (Firebase)
    if (widget.photo.networkUrl != null) {
      return InteractiveViewer(
        minScale: 0.5,
        maxScale: 4.0,
        child: Center(
          child: Image.network(
            widget.photo.networkUrl!,
            fit: BoxFit.contain,
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            },
            errorBuilder:
                (_, __, ___) => const Center(
                  child: Icon(
                    Icons.broken_image,
                    color: Colors.white54,
                    size: 64,
                  ),
                ),
          ),
        ),
      );
    }

    // ✅ Local photo (device)
    if (_imageData == null) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }
    return InteractiveViewer(
      minScale: 0.5,
      maxScale: 4.0,
      child: Center(child: Image.memory(_imageData!, fit: BoxFit.contain)),
    );
  }
}
