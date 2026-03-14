import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:wememmory/models/media_item.dart';

// หน้า รายละเอียดรูปภาพ
class PhotoDetailSheet extends StatefulWidget {
  final MediaItem item;
  final String monthTitle; // ✅ รับค่าเดือน
  final String yearTitle; // ✅ รับค่าปี

  const PhotoDetailSheet({
    super.key,
    required this.item,
    required this.monthTitle,
    required this.yearTitle,
  });

  @override
  State<PhotoDetailSheet> createState() => _PhotoDetailSheetState();
}

class _PhotoDetailSheetState extends State<PhotoDetailSheet> {
  late TextEditingController _captionController;
  late List<String> _selectedTags;

  final GlobalKey _cropKey = GlobalKey();
  final TransformationController _transformationController =
      TransformationController();
  final TransformationController _editTransformController =
      TransformationController();

  BoxFit _currentFit = BoxFit.contain;

  Color _selectedTextColor = Colors.black;
  Color? _dropdownValue;

  bool _isEditMode = false;

  final List<String> _allTags = ["family", "kid", "home", "lover", "favor"];

  Uint8List? _imageData;
  bool _isLoadingImage = true;

  @override
  void initState() {
    super.initState();
    _captionController = TextEditingController(text: widget.item.caption);
    _selectedTags = List.from(widget.item.tags);
    _loadImage();
  }

  Future<void> _loadImage() async {
    if (widget.item.capturedImage != null) {
      setState(() {
        _imageData = widget.item.capturedImage;
        _isLoadingImage = false;
      });
    } else {
      final data = await widget.item.asset.thumbnailDataWithSize(
        const ThumbnailSize(1000, 1000),
      );
      if (mounted) {
        setState(() {
          _imageData = data;
          _isLoadingImage = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _captionController.dispose();
    _transformationController.dispose();
    _editTransformController.dispose();
    super.dispose();
  }

  void _toggleTag(String tag) {
    setState(() {
      if (_selectedTags.contains(tag)) {
        _selectedTags.remove(tag);
      } else {
        _selectedTags.add(tag);
      }
    });
  }

  void _openEditMode() {
    _editTransformController.value = Matrix4.copy(
      _transformationController.value,
    );
    setState(() => _isEditMode = true);
  }

  void _confirmEditMode() {
    _transformationController.value = Matrix4.copy(
      _editTransformController.value,
    );
    setState(() => _isEditMode = false);
  }

  void _cancelEditMode() {
    setState(() => _isEditMode = false);
  }

  Future<void> _saveData() async {
    try {
      RenderRepaintBoundary boundary =
          _cropKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      if (byteData != null) {
        widget.item.capturedImage = byteData.buffer.asUint8List();
        widget.item.caption = _captionController.text;
        widget.item.tags = List.from(_selectedTags);

        if (mounted) {
          Navigator.pop(context);
        }
      }
    } catch (e) {
      debugPrint("Error capturing photo: $e");
      widget.item.caption = _captionController.text;
      widget.item.tags = List.from(_selectedTags);
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ── หน้าหลัก ──
        Container(
          height: MediaQuery.of(context).size.height * 0.92,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
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

              // 1. Header — ✅ แสดง "รายละเอียดรูปภาพ • เดือน ปี"
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 13, 16, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.black87,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "รายละเอียดรูปภาพ",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            // ✅ แสดงเดือน + ปี ใต้ชื่อหน้า
                            if (widget.monthTitle.isNotEmpty)
                              Text(
                                '${widget.monthTitle}${widget.yearTitle.isNotEmpty ? ' ${widget.yearTitle}' : ''}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Image.asset(
                        'assets/icons/cross.png',
                        width: 25,
                        height: 25,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 2. Steps Indicator
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 7.0),
                child: Row(
                  children: [
                    _StepItem(
                      label: 'เลือกรูปภาพ',
                      isActive: true,
                      isFirst: true,
                      isCompleted: true,
                    ),
                    _StepItem(
                      label: 'แก้ไขและจัดเรียง',
                      isActive: true,
                      isCompleted: false,
                    ),
                    _StepItem(
                      label: 'พรีวิวสุดท้าย',
                      isActive: false,
                      isLast: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 3. Content Area
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          height: 350,
                          width: double.infinity,
                          color: Colors.grey[200],
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              RepaintBoundary(
                                key: _cropKey,
                                child: InteractiveViewer(
                                  transformationController:
                                      _transformationController,
                                  minScale: 1.0,
                                  maxScale: 4.0,
                                  panEnabled: false,
                                  scaleEnabled: false,
                                  child:
                                      _isLoadingImage
                                          ? const Center(
                                            child: CircularProgressIndicator(),
                                          )
                                          : _imageData != null
                                          ? Image.memory(
                                            _imageData!,
                                            fit: _currentFit,
                                            width: double.infinity,
                                            height: double.infinity,
                                          )
                                          : const Center(
                                            child: Text(
                                              "ไม่สามารถโหลดรูปภาพได้",
                                            ),
                                          ),
                                ),
                              ),

                              // Grid Overlay
                              IgnorePointer(
                                child: Stack(
                                  children: [
                                    Column(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                  color: Colors.white
                                                      .withOpacity(0.5),
                                                  width: 1,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                  color: Colors.white
                                                      .withOpacity(0.5),
                                                  width: 1,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(child: Container()),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border(
                                                right: BorderSide(
                                                  color: Colors.white
                                                      .withOpacity(0.5),
                                                  width: 1,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border(
                                                right: BorderSide(
                                                  color: Colors.white
                                                      .withOpacity(0.5),
                                                  width: 1,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(child: Container()),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              // ปุ่ม "แก้ไขภาพ" มุมขวาล่าง
                              Positioned(
                                right: 10,
                                bottom: 10,
                                child: GestureDetector(
                                  onTap: _openEditMode,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.55),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.crop_free,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          "แก้ไขภาพ",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: SizedBox(
                              height: 45,
                              child: ElevatedButton.icon(
                                onPressed: _openEditMode,
                                icon: const Icon(
                                  Icons.zoom_in,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                label: const Text(
                                  "ซูม / จัดภาพ",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF67A5BA),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 0,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 2,
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                return PopupMenuButton<Color>(
                                  constraints: BoxConstraints.tightFor(
                                    width: constraints.maxWidth,
                                  ),
                                  offset: const Offset(0, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  color: Colors.white,
                                  elevation: 4,
                                  onSelected: (Color value) {
                                    setState(() {
                                      _dropdownValue = value;
                                      _selectedTextColor = value;
                                    });
                                  },
                                  itemBuilder:
                                      (BuildContext context) => [
                                        PopupMenuItem<Color>(
                                          value: Colors.black,
                                          child: Row(
                                            children: [
                                              const Text(
                                                "สีดำ",
                                                style: TextStyle(fontSize: 14),
                                              ),
                                              const Spacer(),
                                              Container(
                                                width: 21,
                                                height: 20,
                                                decoration: BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  border: Border.all(
                                                    color: const Color(
                                                      0xFF95989A,
                                                    ),
                                                    width: 1,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        PopupMenuItem<Color>(
                                          value: Colors.white,
                                          child: Row(
                                            children: [
                                              const Text(
                                                "สีขาว",
                                                style: TextStyle(fontSize: 14),
                                              ),
                                              const Spacer(),
                                              Container(
                                                width: 21,
                                                height: 20,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  border: Border.all(
                                                    color: Colors.grey[300]!,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                  child: Container(
                                    height: 45,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                        color: Colors.grey[300]!,
                                      ),
                                      color: Colors.white,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          _dropdownValue == null
                                              ? "เลือกสีฟอนต์"
                                              : (_dropdownValue == Colors.black
                                                  ? "สีดำ"
                                                  : "สีขาว"),
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontSize:
                                                _dropdownValue == null
                                                    ? 16
                                                    : 14,
                                          ),
                                        ),
                                        const Icon(
                                          Icons.keyboard_arrow_down,
                                          color: Colors.grey,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[200]!),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: TextField(
                          controller: _captionController,
                          maxLines: 4,
                          style: TextStyle(color: _selectedTextColor),
                          decoration: InputDecoration(
                            hintText:
                                "เขียนความรู้สึกหรือเรื่องราวเล็ก ๆ ที่ซ่อนอยู่หลังภาพนี้.....",
                            hintStyle: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 13,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(12),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children:
                            _allTags.map((tag) => _buildTagChip(tag)).toList(),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              // 4. Bottom Button (Save)
              Container(
                padding: const EdgeInsets.fromLTRB(20, 13, 20, 38),
                child: SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: _saveData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFED7D31),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(1),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      "บันทึก",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // ── Edit Mode Overlay ──
        if (_isEditMode)
          Positioned.fill(
            child: Material(
              color: Colors.black,
              child: SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: _cancelEditMode,
                            child: const Text(
                              "ยกเลิก",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          // ✅ แสดงเดือน + ปี ใน Edit Mode ด้วย
                          Column(
                            children: [
                              const Text(
                                "จัดภาพ",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (widget.monthTitle.isNotEmpty)
                                Text(
                                  '${widget.monthTitle}${widget.yearTitle.isNotEmpty ? ' ${widget.yearTitle}' : ''}',
                                  style: const TextStyle(
                                    color: Colors.white54,
                                    fontSize: 11,
                                  ),
                                ),
                            ],
                          ),
                          GestureDetector(
                            onTap: _confirmEditMode,
                            child: const Text(
                              "ยืนยัน",
                              style: TextStyle(
                                color: Color(0xFF67A5BA),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: Center(
                        child:
                            _imageData != null
                                ? InteractiveViewer(
                                  transformationController:
                                      _editTransformController,
                                  minScale: 0.5,
                                  maxScale: 6.0,
                                  panEnabled: true,
                                  scaleEnabled: true,
                                  child: Image.memory(
                                    _imageData!,
                                    fit: BoxFit.contain,
                                  ),
                                )
                                : const CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                      ),
                    ),

                    const Padding(
                      padding: EdgeInsets.only(bottom: 24, top: 12),
                      child: Text(
                        "ใช้ 2 นิ้วเพื่อซูมและจัดภาพ  •  กด ยืนยัน เพื่อบันทึก",
                        style: TextStyle(color: Colors.white54, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTagChip(String label) {
    bool isSelected = _selectedTags.contains(label);
    return GestureDetector(
      onTap: () => _toggleTag(label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? const Color(0xFFED7D31) : Colors.grey[300]!,
          ),
          borderRadius: BorderRadius.circular(20),
          color: isSelected ? const Color(0xFFED7D31) : Colors.white,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[600],
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _StepItem extends StatelessWidget {
  final String label;
  final bool isActive;
  final bool isFirst;
  final bool isLast;
  final bool isCompleted;

  const _StepItem({
    super.key,
    required this.label,
    required this.isActive,
    this.isFirst = false,
    this.isLast = false,
    this.isCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  height: 2,
                  color:
                      isFirst
                          ? Colors.transparent
                          : (isActive
                              ? const Color(0xFF5AB6D8)
                              : Colors.grey[300]),
                ),
              ),
              const SizedBox(width: 40),
              Container(
                width: 11,
                height: 11,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive ? const Color(0xFF5AB6D8) : Colors.grey[300],
                ),
              ),
              const SizedBox(width: 40),
              Expanded(
                flex: 2,
                child: Container(
                  height: 2,
                  color:
                      isLast
                          ? Colors.transparent
                          : (isCompleted
                              ? const Color(0xFF5AB6D8)
                              : Colors.grey[300]),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? const Color(0xFF5AB6D8) : Colors.grey[400],
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
