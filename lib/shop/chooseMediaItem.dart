import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

// --- Imports จากโปรเจกต์ของคุณ ---
import 'package:wememmory/models/media_item.dart';
import 'package:wememmory/shop/paymentPage.dart'; 

// ==========================================
// ส่วนที่ 1: หน้าเลือกรูปปก (AlbumCoverSelectionPage) - ย้ายมาเป็นหน้าแรก
// ==========================================
class AlbumCoverSelectionPage extends StatefulWidget {
  final List<MediaItem> items;

  const AlbumCoverSelectionPage({
    super.key,
    required this.items,
  });

  @override
  State<AlbumCoverSelectionPage> createState() => _AlbumCoverSelectionPageState();
}

class _AlbumCoverSelectionPageState extends State<AlbumCoverSelectionPage> {
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    print("DEBUG: เข้าสู่หน้าเลือกปก - ได้รับรูปมาทั้งหมด ${widget.items.length} รูป");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'รูปภาพหน้าปกอัลบั้ม',
          style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Text(
              "เลือก 1 ภาพที่สะท้อนเรื่องราวและความทรงจำของคุณ",
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ),
          Expanded(
            child: widget.items.isEmpty
                ? const Center(child: Text("ไม่มีรูปภาพที่จะแสดง"))
                : GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: widget.items.length,
                    itemBuilder: (context, index) {
                      final item = widget.items[index];
                      final isSelected = _selectedIndex == index;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedIndex = index;
                          });
                        },
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: _DebugCoverImageTile(item: item, index: index),
                            ),
                            if (isSelected)
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF67A5BA),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 2),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      '1',
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Colors.black12)),
          ),
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: _selectedIndex == null
                  ? null
                  : () {
                      // [แก้ไข Flow] เมื่อเลือกเสร็จ ให้ไปหน้า OrderPage พร้อมส่งรูปที่เลือกไป
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderPage(
                            items: widget.items, // ส่ง List เดิมไป
                            initialCover: widget.items[_selectedIndex!], // ส่งรูปปกที่เลือกไป
                          ),
                        ),
                      );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFED7D31),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                elevation: 0,
                disabledBackgroundColor: Colors.grey[300],
              ),
              child: const Text(
                'ยืนยัน',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ==========================================
// ส่วนที่ 2: หน้า OrderPage (หน้าหลักในการสั่งซื้อ)
// ==========================================
class OrderPage extends StatefulWidget {
  final List<MediaItem> items; 
  final MediaItem? initialCover; // [เพิ่ม] รับค่ารูปปกเริ่มต้น

  const OrderPage({
    super.key, 
    required this.items, 
    this.initialCover,
  });

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  int _quantity = 1;
  int _selectedColorIndex = 0; 
  File? _selectedCoverImage; 

  final List<Map<String, dynamic>> _colorOptions = [
    {'name': 'เทา', 'color': const Color(0xFF424242)},
    {'name': 'ส้ม', 'color': const Color(0xFFFF7043)},
    {'name': 'ดำ', 'color': const Color(0xFF000000)},
    {'name': 'น้ำเงิน', 'color': const Color(0xFF4FC3F7)}, 
  ];

  @override
  void initState() {
    super.initState();
    // [เพิ่ม] ถ้ามีรูปปกส่งมา ให้แปลงเป็น File และแสดงผลเลย
    if (widget.initialCover != null) {
      _loadInitialCover();
    }
  }

  Future<void> _loadInitialCover() async {
    final file = await widget.initialCover!.asset.file;
    if (file != null && mounted) {
      setState(() {
        _selectedCoverImage = file;
      });
    }
  }

  // ฟังก์ชันไปเลือกรูปใหม่ (ถ้าอยากเปลี่ยน)
  Future<void> _pickCoverImage() async {
    // เนื่องจากเราย้าย Flow แล้ว ตรงนี้อาจจะให้ pop กลับไปหน้าเลือก หรือ push ไปหน้าเลือกใหม่ก็ได้
    // ในที่นี้เลือก push ไปหน้าเลือกใหม่ เพื่อให้เลือกใหม่ได้
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AlbumCoverSelectionPage(
          items: widget.items, 
        ),
      ),
    );
    // หมายเหตุ: การรับค่ากลับอาจจะต้องปรับ Logic ถ้าต้องการให้กด Confirm จากหน้านั้นแล้วกลับมาหน้านี้พร้อมค่าใหม่
    // แต่ตาม Flow A->B->C การกด "ย้อนกลับ" ที่ App bar จะดู make sense กว่าสำหรับการเปลี่ยนรูป
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
          'สั่งซื้อ',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'รูปภาพหน้าปกอัลบั้ม',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        if (_selectedCoverImage != null)
                          GestureDetector(
                            onTap: () => setState(() => _selectedCoverImage = null),
                            child: const Text('ลบรูป', style: TextStyle(color: Colors.red, fontSize: 12)),
                          )
                      ],
                    ),
                    const SizedBox(height: 12),
                    
                    GestureDetector(
                      onTap: _pickCoverImage,
                      child: Container(
                        width: double.infinity,
                        height: _selectedCoverImage != null ? 200 : null, 
                        padding: _selectedCoverImage != null 
                            ? EdgeInsets.zero 
                            : const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                          image: _selectedCoverImage != null
                              ? DecorationImage(
                                  image: FileImage(_selectedCoverImage!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: _selectedCoverImage != null
                            ? null 
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'เลือกรูปที่ไว้ใส่หน้าปกของคุณ',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  ElevatedButton(
                                    onPressed: _pickCoverImage,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF5D9CAB),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    ),
                                    child: const Text('เลือกรูปภาพ', style: TextStyle(color: Colors.white)),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Container(
                width: double.infinity,
                height: 300,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Image.asset(
                    'assets/images/Rectangle1.png', 
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.image, size: 50, color: Colors.grey)),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(_colorOptions.length, (index) {
                  return _buildColorOption(
                    index: index,
                    color: _colorOptions[index]['color'],
                    label: _colorOptions[index]['name'],
                  );
                }),
              ),
              
              const SizedBox(height: 100), 
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Colors.grey.shade300)),
            color: Colors.white,
          ),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const PaymentPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF7043),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    '฿ 599',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      iconSize: 18,
                      onPressed: () {
                        setState(() {
                          if (_quantity > 1) _quantity--;
                        });
                      },
                    ),
                    Text(
                      '$_quantity',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      iconSize: 18,
                      onPressed: () {
                        setState(() {
                          _quantity++;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildColorOption({required int index, required Color color, required String label}) {
    bool isSelected = _selectedColorIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedColorIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: isSelected 
              ? Border.all(color: Colors.deepOrange, width: 1.5)
              : Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.deepOrange : Colors.grey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -------------------------------------------------------------------
// Widget แสดงรูป พร้อมตัวเช็ค Error (Debug Mode)
// -------------------------------------------------------------------
class _DebugCoverImageTile extends StatefulWidget {
  final MediaItem item;
  final int index;

  const _DebugCoverImageTile({required this.item, required this.index});

  @override
  State<_DebugCoverImageTile> createState() => _DebugCoverImageTileState();
}

class _DebugCoverImageTileState extends State<_DebugCoverImageTile> {
  Uint8List? _imageData;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  @override
  void didUpdateWidget(covariant _DebugCoverImageTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.item != widget.item) {
      _loadImage();
    }
  }

  Future<void> _loadImage() async {
    setState(() {
      _imageData = null;
      _hasError = false;
    });

    try {
      if (widget.item.capturedImage != null) {
        if (mounted) setState(() => _imageData = widget.item.capturedImage);
        return;
      }

      final asset = widget.item.asset;
      if (!await asset.exists) {
        if (mounted) setState(() => _hasError = true);
        return;
      }

      final data = await asset.thumbnailDataWithSize(
        const ThumbnailSize(300, 300),
        quality: 80,
      );

      if (data != null) {
        if (mounted) setState(() => _imageData = data);
      } else {
        if (mounted) setState(() => _hasError = true);
      }
    } catch (e) {
      print("Error loading image index ${widget.index}: $e");
      if (mounted) setState(() => _hasError = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return Container(
        color: Colors.grey[300],
        child: const Icon(Icons.broken_image, color: Colors.grey),
      );
    }

    if (_imageData != null) {
      return Image.memory(_imageData!, fit: BoxFit.cover, gaplessPlayback: true);
    }

    return Container(
      color: Colors.grey[200],
      child: const Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))),
    );
  }
}