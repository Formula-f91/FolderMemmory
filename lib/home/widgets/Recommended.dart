import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:wememmory/Album/createAlbumModal.dart';
import 'package:wememmory/models/media_item.dart';

class Recommended extends StatefulWidget {
  final List<MediaItem>? albumItems;
  final String? albumMonth;

  const Recommended({Key? key, this.albumItems, this.albumMonth})
      : super(key: key);

  @override
  State<Recommended> createState() => _RecommendedState();
}

class _RecommendedState extends State<Recommended> {
  int _currentIndex = 0;
  late List<MemoryCardData> _items;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  void didUpdateWidget(covariant Recommended oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.albumItems != oldWidget.albumItems ||
        widget.albumMonth != oldWidget.albumMonth) {
      _initData();
    }
  }

  void _initData() {
    String displayMonth = widget.albumMonth ?? 'พฤษภาคม';
    
    int currentCount = widget.albumItems?.length ?? 0;
    int targetCount = 11;

    _items = [
      // ------------------------------------------------
      // Card 1: ปรับ Data ให้เข้ากับ Layout ใหม่
      // ------------------------------------------------
      MemoryCardData(
        type: CardType.standard,
        // ย้ายเดือนมาไว้ TopTitle เพื่อให้ตัวใหญ่และอยู่มุมซ้าย
        topTitle: '$displayMonth\nของฉัน', 
        mainTitle: '', // ไม่ใช้แล้วสำหรับ layout ใหม่
        // ย้ายข้อความอธิบายมาไว้ subTitle
        subTitle: 'อีกมากกว่า 23+ ที่เพิ่มรูปภาพเดือนนี้', 
        // ใส่ Ticket ID ที่นี่เพื่อให้ไปอยู่มุมขวาบน
        footerText: 'Ticket 10', 
        gradientColors: [const Color(0xFF424242), const Color(0xFF212121)],
        accentColor: const Color(0xFFFF7043),
        assetImages: [
          'assets/images/Hobby2.png',
          'assets/images/Hobby3.png',
          'assets/images/Hobby1.png',
        ],
      ),
      
      // ------------------------------------------------
      // Card 2: Ticket Layout
      // ------------------------------------------------
      MemoryCardData(
        type: CardType.ticket,
        topTitle: '$displayMonth\nของฉัน',
        mainTitle: '5 วัน 23 ชม. 34 นาที 55 วิ',
        subTitle: 'อีกมากกว่า 23+ ที่เพิ่มรูปภาพเดือนนี้',
        footerText: 'Ticket 10',
        currentProgress: currentCount,
        maxProgress: targetCount,
        gradientColors: [], 
        accentColor: const Color(0xFFFF7043),
        backgroundColor: const Color(0xFF111111), 
      ),

      // ------------------------------------------------
      // Card 3: Background Image Layout
      // ------------------------------------------------
      MemoryCardData(
        type: CardType.backgroundImage,
        topTitle: 'เมษายน',
        mainTitle: 'ความทรงจำที่\nน่าจดจำ',
        subTitle: '',
        footerText: '',
        gradientColors: [],
        accentColor: Colors.transparent,
        backgroundImage: 'assets/images/Hobby1.png',
        showTextOverlay: true,
      ),
    ];

    if (widget.albumItems != null && widget.albumItems!.isNotEmpty) {
      final items = widget.albumItems!;
      
      // Update Card 1 Data (เมื่อมีรูปจริง)
      _items[0] = MemoryCardData(
        type: CardType.standard,
        topTitle: '$displayMonth\nของฉัน',
        mainTitle: '',
        subTitle: 'บันทึกความทรงจำในเดือนนี้',
        footerText: 'Ticket 10',
        gradientColors: [const Color(0xFF424242), const Color(0xFF212121)],
        accentColor: const Color(0xFFFF7043),
        imageItems: items,
      );

      // Card 2: Update Data
       _items[1] = MemoryCardData(
        type: CardType.ticket,
        topTitle: '$displayMonth\nของฉัน',
        mainTitle: '5 วัน 23 ชม. 34 นาที 55 วิ', 
        subTitle: 'อีกมากกว่า 23+ ที่เพิ่มรูปภาพเดือนนี้',
        footerText: 'Ticket 10',
        currentProgress: items.length,
        maxProgress: targetCount,
        gradientColors: [], 
        accentColor: const Color(0xFFFF7043),
        backgroundColor: const Color(0xFF111111),
      );

      // Card 3: Update Data
      if (items.isNotEmpty) {
          final bgItem = items.length > 1 ? items[1] : items[0];
          _items[2] = MemoryCardData(
          type: CardType.backgroundImage,
          topTitle: displayMonth,
          mainTitle: 'ช่วงเวลาดีๆ\nในเดือนนี้',
          subTitle: '',
          footerText: '',
          gradientColors: [],
          accentColor: Colors.transparent,
          backgroundMediaItem: bgItem,
          showTextOverlay: true,
        );
      }
    }

    if (mounted) setState(() {});
  }

  // ... (Functions _nextCard, _previousCard, _openCreateAlbumModal, build, _buildCardItem คงเดิม) ...
  void _nextCard() {
    if (_currentIndex < _items.length - 1) {
      setState(() => _currentIndex++);
    }
  }

  void _previousCard() {
    if (_currentIndex > 0) {
      setState(() => _currentIndex--);
    }
  }

  void _openCreateAlbumModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const CreateAlbumModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 416,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: _items
            .asMap()
            .entries
            .map((entry) {
              return _buildCardItem(entry.key, entry.value);
            })
            .toList()
            .reversed
            .toList(),
      ),
    );
  }

  Widget _buildCardItem(int index, MemoryCardData item) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = 330.0;
    final cardHeight = 330.0;
    final centerPosition = (screenWidth - cardWidth) / 1.8;
    final adjustedStartPosition = centerPosition - 25.0;

    // 1. กำหนดค่าตัวแปรตามสถานะ (Active vs Past)
    double left;
    double top;
    double scale;
    double opacity;
    bool isAbsorbing;
    Function(DragEndDetails)? onDragEnd;
    VoidCallback? onTapButton;

    if (index < _currentIndex) {
      // --- สถานะ: การ์ดที่ถูกปัดไปทางซ้ายแล้ว (Past) ---
      left = -350;
      top = 35;
      scale = 0.9;
      opacity = 0.0; // ซ่อนไว้
      isAbsorbing = true; // ป้องกันการกด
      onDragEnd = null; // ปิดการลาก
      onTapButton = null; 
    } else {
      // --- สถานะ: การ์ดปัจจุบันและใบถัดไป (Active/Future) ---
      final int relativeIndex = index - _currentIndex;
      scale = 1.0 - (relativeIndex * 0.15);
      final double rightShift = relativeIndex * 71.0;
      
      left = adjustedStartPosition + rightShift;
      top = 42;
      opacity = relativeIndex > 2 ? 0.0 : 1.0;
      isAbsorbing = relativeIndex > 0; // ยอมให้กดได้เฉพาะใบหน้าสุด (relative 0)

      onDragEnd = (details) {
        if (details.primaryVelocity! < 0) {
          _nextCard();
        } else if (details.primaryVelocity! > 0) {
          _previousCard();
        }
      };

      // เงื่อนไขปุ่มกด (ตาม Logic เดิม)
      if (index == 0 || item.type == CardType.ticket) {
        onTapButton = _openCreateAlbumModal;
      }
    }

    // 2. ใช้โครงสร้าง Widget เดียวกันเสมอ (Unified Structure)
    return AnimatedPositioned(
      // ✅ สำคัญ: ใส่ Key เพื่อให้ Flutter จำได้ว่าเป็น Widget เดิม ไม่ต้องสร้างใหม่
      key: ValueKey(index), 
      duration: const Duration(milliseconds: 500),
      curve: index < _currentIndex ? Curves.easeOutCubic : Curves.easeOutBack,
      top: top,
      left: left,
      child: GestureDetector(
        // ใช้ตัวแปร onDragEnd แทนการลบ Widget ทิ้ง
        onHorizontalDragEnd: onDragEnd, 
        child: Transform.scale(
          scale: scale,
          alignment: Alignment.centerLeft,
          child: Opacity(
            opacity: opacity,
            child: SizedBox(
              width: cardWidth,
              height: cardHeight,
              child: AbsorbPointer(
                // ใช้ตัวแปร isAbsorbing แทนการลบ Widget ทิ้ง
                absorbing: isAbsorbing, 
                child: MemoryCard(
                  data: item,
                  onButtonTap: onTapButton,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ... (Enum และ MemoryCardData คงเดิม แต่ Data ถูกแก้ใน _initData แล้ว) ...
enum CardType { standard, ticket, backgroundImage }

class MemoryCardData {
  final CardType type;
  final String topTitle;
  final String mainTitle;
  final String subTitle;
  final String footerText;
  final List<Color> gradientColors;
  final Color accentColor;
  final Color? backgroundColor;
  final List<MediaItem>? imageItems;
  final List<String>? assetImages;
  final String? backgroundImage;
  final MediaItem? backgroundMediaItem;
  final bool showTextOverlay;
  final int currentProgress;
  final int maxProgress;

  MemoryCardData({
    this.type = CardType.standard,
    required this.topTitle,
    required this.mainTitle,
    required this.subTitle,
    required this.footerText,
    required this.gradientColors,
    required this.accentColor,
    this.backgroundColor,
    this.imageItems,
    this.assetImages,
    this.backgroundImage,
    this.backgroundMediaItem,
    this.showTextOverlay = false,
    this.currentProgress = 0,
    this.maxProgress = 10,
  });
}

// ... (TicketMemoryCard คงเดิม) ...
class TicketMemoryCard extends StatelessWidget {
  final MemoryCardData data;
  final VoidCallback? onButtonTap;

  const TicketMemoryCard({Key? key, required this.data, this.onButtonTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double progressPercent = data.maxProgress > 0 
        ? (data.currentProgress / data.maxProgress).clamp(0.0, 1.0) 
        : 0.0;

    return Container(
      padding: const EdgeInsets.all(24), // เพิ่ม padding ให้เท่า Card 1 ใหม่
      decoration: BoxDecoration(
        color: data.backgroundColor ?? const Color(0xFF111111),
        borderRadius: BorderRadius.circular(0),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.topTitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28, 
                  fontWeight: FontWeight.bold,
                  height: 1.1,
                ),
              ),
              Text(
                data.footerText,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            data.subTitle,
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 12,
            ),
          ),
          const Spacer(),
          Center(
            child: Text(
              data.mainTitle,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 23, 
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "ความคืบหน้า",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              Text(
                "${data.currentProgress}/${data.maxProgress}",
                style: const TextStyle(
                  color: Colors.white, 
                  fontSize: 14, 
                  fontWeight: FontWeight.bold
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 31,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF333333),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Stack(
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    return Container(
                      width: constraints.maxWidth * progressPercent, 
                      decoration: BoxDecoration(
                        color: const Color(0xFF6797A9),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          GestureDetector(
            onTap: onButtonTap,
            child: Container(
              width: double.infinity,
              height: 39,
              decoration: BoxDecoration(
                color: data.accentColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: const Text(
                "คัดสรรรูปภาพของคุณ",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Main MemoryCard Wrapper (ปรับปรุง Layout Card 1)
// ---------------------------------------------------------------------------
class MemoryCard extends StatelessWidget {
  final MemoryCardData data;
  final VoidCallback? onButtonTap;

  const MemoryCard({Key? key, required this.data, this.onButtonTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ✅ CASE 1: เรียกใช้ Class ใหม่สำหรับ Ticket Layout (Card 2)
    if (data.type == CardType.ticket) {
      return TicketMemoryCard(data: data, onButtonTap: onButtonTap);
    }

    // ✅ CASE 2: มี Background Image (Card 3) -- แก้ไขตรงนี้ครับ --
    if (data.type == CardType.backgroundImage || 
        data.backgroundImage != null || 
        data.backgroundMediaItem != null) {
      return Container(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(0),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (data.backgroundMediaItem != null)
                AsyncImageLoader(
                  item: data.backgroundMediaItem!,
                  fit: BoxFit.cover,
                  quality: 600,
                )
              else
                Image.asset(
                  data.backgroundImage!,
                  fit: BoxFit.cover,
                ),
              
              if (data.showTextOverlay)
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.6),
                        Colors.transparent,
                        Colors.transparent,
                        Colors.black.withOpacity(0.3),
                      ],
                      stops: const [0.0, 0.4, 0.7, 1.0],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ✅ แก้ไข: topTitle เป็นตัวใหญ่และหนา (32px, Bold)
                      Text(
                        data.topTitle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32, // ปรับเป็น 32
                          fontWeight: FontWeight.bold, // ปรับเป็นตัวหนา
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 8), // ลดระยะห่างลงนิดหน่อยให้สวยงาม
                      
                      // ✅ แก้ไข: mainTitle เป็นตัวเล็ก (16px)
                      Text(
                        data.mainTitle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16, // ปรับเป็น 16
                          fontWeight: FontWeight.w400, // ปรับน้ำหนักปกติ
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      );
    }

    // ✅ CASE 3: Standard (Card 1) - คงเดิม
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0),
        gradient: LinearGradient(
          colors: data.gradientColors,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: Stack(
          children: [
            // Background Circle Decor
            Positioned(
              top: -100,
              right: -50,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [Colors.white.withOpacity(0.1), Colors.transparent],
                  ),
                ),
              ),
            ),
            
            // Content Layout
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row ส่วนหัว: Title (ซ้าย) + Ticket ID (ขวา)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.topTitle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28, 
                          fontWeight: FontWeight.bold,
                          height: 1.1,
                        ),
                      ),
                      Text(
                        data.footerText,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  // Subtitle ด้านล่าง Title
                  Text(
                    data.subTitle,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 12,
                    ),
                  ),

                  // Spacer ดันรูปภาพมาตรงกลางพื้นที่ว่าง
                  const Spacer(),

                  // รูปภาพ
                  Center(
                    child: SizedBox(
                      height: 138,
                      width: 280,
                      child: _PhotoStack(
                        items: data.imageItems,
                        assetImages: data.assetImages,
                      ),
                    ),
                  ),
                  
                  // Spacer ดันปุ่มลงล่าง
                  const Spacer(),

                  // ปุ่มกด
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: onButtonTap,
                    child: Container(
                      width: double.infinity,
                      height: 39,
                      decoration: BoxDecoration(
                        color: data.accentColor,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        "คัดสรรรูปภาพของคุณ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ... (AsyncImageLoader และ _PhotoStack คงเดิมไว้ได้เลยครับ) ...
class AsyncImageLoader extends StatefulWidget {
  final MediaItem item;
  final BoxFit fit;
  final int quality;

  const AsyncImageLoader({
    Key? key,
    required this.item,
    this.fit = BoxFit.cover,
    this.quality = 300,
  }) : super(key: key);

  @override
  State<AsyncImageLoader> createState() => _AsyncImageLoaderState();
}

class _AsyncImageLoaderState extends State<AsyncImageLoader> {
  Uint8List? _imageData;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant AsyncImageLoader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.item.asset.id != oldWidget.item.asset.id ||
        widget.item.capturedImage != oldWidget.item.capturedImage) {
      _load();
    }
  }

  Future<void> _load() async {
    if (widget.item.capturedImage != null) {
      if (mounted) setState(() => _imageData = widget.item.capturedImage);
      return;
    }
    final data = await widget.item.asset.thumbnailDataWithSize(
      ThumbnailSize(widget.quality, widget.quality),
    );
    if (mounted) {
      setState(() => _imageData = data);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_imageData != null) {
      return Image.memory(
        _imageData!,
        fit: widget.fit,
        gaplessPlayback: true,
      );
    }
    return Container(color: Colors.grey[200]);
  }
}

class _PhotoStack extends StatelessWidget {
  final List<MediaItem>? items;
  final List<String>? assetImages;

  const _PhotoStack({Key? key, this.items, this.assetImages}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    dynamic getItem(int index) {
      if (items != null && index < items!.length) {
        return items![index];
      }
      if (assetImages != null && index < assetImages!.length) {
        return assetImages![index];
      }
      return null;
    }

    final item1 = getItem(0);
    final item2 = getItem(1);
    final item3 = getItem(2);

    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        _buildPolaroid(
          angle: -0.12,
          offset: const Offset(-82, 4),
          item: item3,
          color: Colors.grey[100],
        ),
        _buildPolaroid(
          angle: 0.12,
          offset: const Offset(81, 4),
          item: item2,
          color: Colors.grey[200],
        ),
        _buildPolaroid(
          angle: 0.0,
          offset: const Offset(0, 0),
          item: item1,
          isFront: true,
          color: Colors.white,
        ),
      ],
    );
  }

  Widget _buildPolaroid({
    required double angle,
    required Offset offset,
    bool isFront = false,
    dynamic item,
    Color? color,
  }) {
    const double polaroidWidth = 90;
    const double polaroidHeight = 115;

    return Transform.translate(
      offset: offset,
      child: Transform.rotate(
        angle: angle,
        child: Container(
          width: polaroidWidth,
          height: polaroidHeight,
          padding: const EdgeInsets.fromLTRB(2, 10, 2, 9),
          decoration: BoxDecoration(
            color: color ?? Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Container(
            color: const Color.fromARGB(255, 255, 255, 255),
            child: _buildImageContent(item),
          ),
        ),
      ),
    );
  }

  Widget _buildImageContent(dynamic item) {
    if (item == null) {
      return const Center(
        child: Icon(Icons.image, color: Colors.grey, size: 24),
      );
    }
    const double imagePadding = 4.0;
    if (item is String) {
      return Padding(
        padding: const EdgeInsets.all(imagePadding),
        child: Image.asset(item, fit: BoxFit.cover),
      );
    }
    if (item is MediaItem) {
      return Padding(
        padding: const EdgeInsets.all(imagePadding),
        child: AsyncImageLoader(item: item, fit: BoxFit.cover, quality: 300),
      );
    }
    return const SizedBox();
  }
}