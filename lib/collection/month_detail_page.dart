import 'dart:typed_data';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:wememmory/collection/FanStackDetailPage.dart';
import 'package:wememmory/collection/MemorySlidePage.dart';
import 'package:wememmory/collection/photo_viewer_page.dart';
import 'package:wememmory/collection/share_sheet.dart';
import 'package:wememmory/data/album_data.dart';
import 'package:wememmory/models/media_item.dart';

class MonthDetailPage extends StatelessWidget {
  final String monthName;
  final List<MediaItem> items;
  // ✅ เพิ่ม storagePhotos สำหรับรูปจาก Firebase
  final List<StoragePhoto> storagePhotos;

  const MonthDetailPage({
    super.key,
    required this.monthName,
    required this.items,
    this.storagePhotos = const [],
  });

  // ✅ Factory: สร้างจาก AlbumCollection ได้ง่าย
  factory MonthDetailPage.fromAlbum(AlbumCollection album) {
    return MonthDetailPage(
      monthName: album.month,
      items: album.items,
      storagePhotos: album.storagePhotos,
    );
  }

  // ✅ รูปทั้งหมดที่มี (ใช้ local ถ้ามี ไม่งั้นใช้ storagePhotos)
  bool get _hasLocalItems => items.isNotEmpty;
  int get _totalPhotos => _hasLocalItems ? items.length : storagePhotos.length;

  @override
  Widget build(BuildContext context) {
    // สุ่มรูป background
    MediaItem? bgItem;
    if (items.isNotEmpty) {
      bgItem = items[Random().nextInt(items.length)];
    }
    final String? bgUrl =
        (!_hasLocalItems && storagePhotos.isNotEmpty)
            ? storagePhotos[Random().nextInt(storagePhotos.length)].url
            : null;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Header
            Stack(
              children: [
                Container(
                  height: 250,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF8E8E8E), Color(0xFF4A4A4A)],
                    ),
                  ),
                  child:
                      bgItem != null
                          ? FutureBuilder<Uint8List?>(
                            future:
                                bgItem.capturedImage != null
                                    ? Future.value(bgItem.capturedImage)
                                    : bgItem.asset.thumbnailDataWithSize(
                                      const ThumbnailSize(800, 800),
                                    ),
                            builder: (context, snapshot) {
                              if (snapshot.hasData && snapshot.data != null) {
                                return Image.memory(
                                  snapshot.data!,
                                  fit: BoxFit.cover,
                                  color: Colors.black.withOpacity(0.3),
                                  colorBlendMode: BlendMode.darken,
                                );
                              }
                              return Container();
                            },
                          )
                          : bgUrl != null
                          // ✅ ใช้ network image เป็น background
                          ? Image.network(
                            bgUrl,
                            fit: BoxFit.cover,
                            color: Colors.black.withOpacity(0.3),
                            colorBlendMode: BlendMode.darken,
                          )
                          : Container(),
                ),
                Positioned(
                  top: 50,
                  left: 16,
                  right: 16,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 28,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 28,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 60,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      Text(
                        monthName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              blurRadius: 4,
                              color: Colors.black45,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "เก็บเรื่องราวกับครอบครัว",
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // 2. Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "พิมพ์แล้ว 2 ครั้ง",
                    style: TextStyle(color: Color(0xFF67A5BA), fontSize: 14),
                  ),
                  Row(
                    children: [
                      _buildIconButton('assets/icons/print.png'),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap:
                            () => showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) => const ShareSheet(),
                            ),
                        child: _buildIconButton('assets/icons/share.png'),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 3. Album Grid — ✅ รองรับทั้ง local และ storagePhotos
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _buildFullAlbumPreview(context),
              ),
            ),

            const SizedBox(height: 40),

            // 4. Bottom Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap:
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => MemorySlidePage(
                                        monthName: monthName,
                                        items: items,
                                      ),
                                ),
                              ),
                          child: _buildPolaroidStack(),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: GestureDetector(
                          onTap:
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => FanStackDetailPage(
                                        monthName: monthName,
                                        items: items,
                                      ),
                                ),
                              ),
                          child: _buildFanImageStack(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap:
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => MemorySlidePage(
                                        monthName: monthName,
                                        items: items,
                                      ),
                                ),
                              ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "แท็กทั้งหมด",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "#ครอบครัว #ความรัก ...",
                                style: TextStyle(
                                  color: Color(0xFFED7D31),
                                  fontSize: 12,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "การแชร์ของเดือนนี้",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "ผู้ที่เข้าชม 23+",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 60),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 2),
            //   child: _buildBottomStatsSection(),
            // ),
            // const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ✅ Build photo slot ที่รองรับทั้ง local และ network
  Widget _buildPhotoSlot(int index, BuildContext context) {
    if (_hasLocalItems) {
      if (index >= items.length) return const SizedBox();
      return _TappablePhotoSlot(
        photo: ViewerPhoto.fromLocal(items[index]),
        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (_) => PhotoViewerPage.fromItems(
                      items: items,
                      initialIndex: index,
                    ),
              ),
            ),
      );
    } else {
      if (index >= storagePhotos.length) return const SizedBox();
      return _TappablePhotoSlot(
        photo: ViewerPhoto.fromNetwork(storagePhotos[index]),
        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (_) => PhotoViewerPage(
                      photos:
                          storagePhotos
                              .map((p) => ViewerPhoto.fromNetwork(p))
                              .toList(),
                      initialIndex: index,
                    ),
              ),
            ),
      );
    }
  }

  Widget _buildFullAlbumPreview(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(color: Color(0xFF555555)),
        child: IntrinsicWidth(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPageContainer(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 3,
                  mainAxisSpacing: 3,
                  childAspectRatio: 1.0,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  children: [
                    Container(
                      decoration: const BoxDecoration(color: Colors.white),
                      child: Center(
                        child: Text(
                          monthName.split(' ')[0],
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    for (int i = 0; i < 5; i++) _buildPhotoSlot(i, context),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              _buildPageContainer(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 3,
                  mainAxisSpacing: 3,
                  childAspectRatio: 1.0,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  children: [
                    for (int i = 5; i < 11; i++) _buildPhotoSlot(i, context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPageContainer({required Widget child}) =>
      SizedBox(width: 160, height: 245, child: child);

  Widget _buildIconButton(String iconPath) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(10),
      child: Image.asset(
        iconPath,
        width: 20,
        height: 20,
        color: const Color(0xFF6BB0C5),
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildImage(MediaItem item) {
    if (item.capturedImage != null) {
      return Image.memory(item.capturedImage!, fit: BoxFit.cover);
    }
    return FutureBuilder<Uint8List?>(
      future: item.asset.thumbnailDataWithSize(const ThumbnailSize(300, 300)),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return Image.memory(snapshot.data!, fit: BoxFit.cover);
        }
        return Container(color: Colors.grey[200]);
      },
    );
  }

  Widget _buildPolaroidStack() {
    final mainItem = items.isNotEmpty ? items[0] : null;
    final String? mainUrl =
        (!_hasLocalItems && storagePhotos.isNotEmpty)
            ? storagePhotos[0].url
            : null;
    const double cardWidth = 120;
    const double cardHeight = 154;

    return SizedBox(
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 7,
            top: 22,
            child: Transform.rotate(
              angle: -0.13,
              child: _buildPolaroidCard(width: cardWidth, height: cardHeight),
            ),
          ),
          Positioned(
            right: 12,
            top: 20,
            child: Transform.rotate(
              angle: 0.2,
              child: _buildPolaroidCard(width: cardWidth, height: cardHeight),
            ),
          ),
          Container(
            width: cardWidth,
            height: cardHeight,
            padding: const EdgeInsets.fromLTRB(17, 17, 17, 6),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 1.0,
                  child:
                      mainItem != null
                          ? _buildImage(mainItem)
                          : mainUrl != null
                          ? Image.network(mainUrl, fit: BoxFit.cover)
                          : Container(color: Colors.grey[200]),
                ),
                const Spacer(),
                const Text(
                  "อากาศดี วิวสวย",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                const Text(
                  "#ครอบครัว #ความรัก",
                  style: TextStyle(fontSize: 10, color: Color(0xFF67A5BA)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPolaroidCard({required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
    );
  }

  Widget _buildFanImageStack() {
    final displayItems = items.take(4).toList();
    final displayUrls = storagePhotos.take(4).toList();
    return SizedBox(
      height: 150,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          if (_hasLocalItems)
            for (int i = 0; i < displayItems.length; i++)
              _buildFanItem(item: displayItems[i], index: i)
          else
            for (int i = 0; i < displayUrls.length; i++)
              _buildFanItem(url: displayUrls[i].url, index: i),
        ],
      ),
    );
  }

  Widget _buildFanItem({MediaItem? item, String? url, required int index}) {
    const double cardWidth = 92.0;
    const double cardHeight = 80.0;
    final List<double> rotations = [0.08, -0.1, 0.08, -0.1];
    final double angle = (index < rotations.length) ? rotations[index] : 0.0;
    final double leftOffset = index * 20.0;

    return Positioned(
      left: leftOffset + 8,
      top: 60,
      child: Transform.rotate(
        angle: angle,
        child: Container(
          width: cardWidth,
          height: cardHeight,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white, width: 1),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child:
                item != null
                    ? _buildImage(item)
                    : url != null
                    ? Image.network(url, fit: BoxFit.cover)
                    : Container(color: Colors.grey[200]),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomStatsSection() {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(color: Colors.white),
          child: Row(
            children: [
              Image.asset(
                'assets/icons/MainFlame.png',
                width: 128,
                height: 128,
                fit: BoxFit.contain,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "ต่อเนื่อง 4 เดือน",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 36),
                  ),
                  Text(
                    "สร้างอัลบั้มต่อเนื่องมาแล้ว 4 เดือนติด",
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Container(
          width: 373,
          height: 113,
          padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "ทุกภาพมีเรื่องเล่าของตัวเอง",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Text(
                    "คุณได้อธิบายภาพในเดือนนี้",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
              Stack(
                alignment: Alignment.center,
                children: const [
                  SizedBox(
                    width: 68,
                    height: 68,
                    child: CircularProgressIndicator(
                      value: 0.76,
                      backgroundColor: Color(0xFFE0E0E0),
                      color: Color(0xFF67A5BA),
                      strokeWidth: 6,
                    ),
                  ),
                  Text(
                    "76%",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
        Container(
          width: 362,
          height: 318,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(color: Colors.grey.shade100),
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  const SizedBox(height: 2),
                  _buildDashedGridLine(label: "100"),
                  const Spacer(),
                  _buildDashedGridLine(label: "50"),
                  const Spacer(),
                  _buildDashedGridLine(label: "25"),
                  const Spacer(),
                  _buildDashedGridLine(label: "0"),
                  const SizedBox(height: 20),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildFixedBar(
                      height: 160,
                      label: "ความสม่ำเสมอ",
                      color: const Color(0xFFED7D31),
                    ),
                    _buildFixedBar(
                      height: 86,
                      label: "ตรงตามเวลา",
                      color: const Color(0xFFED7D31),
                    ),
                    _buildFixedBar(
                      height: 86,
                      label: "อัพรูปครบ",
                      color: const Color(0xFFED7D31),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Container(
          width: 373,
          height: 211,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "เวลาในการสร้างอัลบั้ม",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "15.00 นาที",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.only(top: 8),
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Color(0xFFEEEEEE), width: 1),
                          ),
                        ),
                        child: const Text(
                          "สูงสุด 30.00 นาที",
                          style: TextStyle(color: Colors.grey, fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 120,
                    height: 60,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Container(
                          width: 120,
                          height: 60,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFFF0E0),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(60),
                              topRight: Radius.circular(60),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 0,
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: const BoxDecoration(
                              color: Color(0xFFED7D31),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(60),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 80,
                          height: 40,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40),
                            ),
                          ),
                        ),
                        const Positioned(
                          bottom: 0,
                          child: Text(
                            "15.00 นาที",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                "เร็วกว่าค่าเฉลี่ย 15.00 นาที",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildDashedGridLine({required String label}) {
    return Row(
      children: [
        SizedBox(
          width: 25,
          child: Text(
            label,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
            textAlign: TextAlign.right,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              const dashWidth = 4.0;
              const dashSpace = 4.0;
              final dashCount =
                  (constraints.constrainWidth() / (dashWidth + dashSpace))
                      .floor();
              return Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(dashCount, (_) {
                  return SizedBox(
                    width: dashWidth,
                    height: 1,
                    child: DecoratedBox(
                      decoration: BoxDecoration(color: Colors.grey.shade300),
                    ),
                  );
                }),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFixedBar({
    required double height,
    required String label,
    required Color color,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 59,
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

// ✅ TappablePhotoSlot รองรับทั้ง local และ network
class _TappablePhotoSlot extends StatefulWidget {
  final ViewerPhoto photo;
  final VoidCallback onTap;

  const _TappablePhotoSlot({required this.photo, required this.onTap});

  @override
  State<_TappablePhotoSlot> createState() => _TappablePhotoSlotState();
}

class _TappablePhotoSlotState extends State<_TappablePhotoSlot> {
  Uint8List? _imageData;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    if (widget.photo.networkUrl != null) return; // ใช้ Image.network
    final item = widget.photo.mediaItem!;
    if (item.capturedImage != null) {
      if (mounted) setState(() => _imageData = item.capturedImage);
    } else {
      final data = await item.asset.thumbnailDataWithSize(
        const ThumbnailSize(300, 300),
      );
      if (mounted) setState(() => _imageData = data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: const BoxDecoration(color: Colors.white),
        padding: const EdgeInsets.all(4.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6.0),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // ✅ แสดงรูปตามประเภท
              if (widget.photo.networkUrl != null)
                Image.network(
                  widget.photo.networkUrl!,
                  fit: BoxFit.cover,
                  // ✅ cacheWidth ลดขนาด decode ให้เร็วขึ้น
                  cacheWidth: 300,
                  loadingBuilder: (_, child, progress) {
                    if (progress == null) return child;
                    return Container(color: Colors.grey[200]);
                  },
                  errorBuilder:
                      (_, __, ___) => Container(color: Colors.grey[200]),
                )
              else if (_imageData != null)
                Image.memory(_imageData!, fit: BoxFit.cover)
              else
                Container(color: Colors.grey[200]),

              // ✅ ไอคอน zoom
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.zoom_in,
                    color: Colors.white,
                    size: 10,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
