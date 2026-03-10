import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:wememmory/models/media_item.dart';
import 'package:wememmory/Album/photo_detail_sheet.dart'; 
import 'package:wememmory/Album/video_detail_sheet.dart';
import 'package:wememmory/Album/final_preview_sheet.dart'; 

class PhotoDragData {
  final int index;
  PhotoDragData(this.index);
}

class AlbumLayoutPage extends StatefulWidget {
  final List<MediaItem> selectedItems;
  final String monthName; 

  const AlbumLayoutPage({
    super.key,
    required this.selectedItems,
    required this.monthName,
  });

  @override
  State<AlbumLayoutPage> createState() => _AlbumLayoutPageState();
}

class _AlbumLayoutPageState extends State<AlbumLayoutPage> {
  late List<MediaItem> _items; 
  bool _isDragging = false;

  final double _imageRadius = 6.0; 
  final double _frameRadius = 0.0; 

  @override
  void initState() {
    super.initState();
    _items = List.from(widget.selectedItems);
  }

  void _handlePhotoDrop(PhotoDragData source, int targetIndex) {
    if (source.index == targetIndex) return;
    setState(() {
      final temp = _items[source.index];
      _items[source.index] = _items[targetIndex];
      _items[targetIndex] = temp;
    });
  }

  // ✅ แก้ไข: รอรับการกลับมาจากการแก้ไขรูป แล้วสั่ง setState
  Future<void> _handlePhotoTap(int index) async {
    final selectedItem = _items[index];
    
    if (selectedItem.type == MediaType.video) {
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => VideoDetailSheet(item: selectedItem),
      );
    } else {
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => PhotoDetailSheet(item: selectedItem),
      );
    }

    // เมื่อ Sheet ปิดลง ให้รีเฟรชหน้า (เพื่อให้รูปที่เพิ่งแก้แสดงผล)
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final String monthTitle = widget.monthName.split(' ')[0];

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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

          Padding(
            padding: const EdgeInsets.fromLTRB(20, 13, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$monthTitle : อัลบั้ม (0 แก้ไข)',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
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

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 7.0),
            child: Row(
              children: [
                _StepItem(label: 'เลือกรูปภาพ', isActive: true, isFirst: true, isCompleted: true),
                _StepItem(label: 'แก้ไขและจัดเรียง', isActive: true, isCompleted: false),
                _StepItem(label: 'พรีวิวสุดท้าย', isActive: false, isLast: true),
              ],
            ),
          ),

          const SizedBox(height: 20),

          const Text.rich(
            TextSpan(
              style: TextStyle(fontSize: 13, color: Colors.grey),
              children: [
                TextSpan(text: "แตะ", style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 121, 121, 121))),
                TextSpan(text: "เพื่อแก้ไข • "),
                TextSpan(text: "ลาก", style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 121, 121, 121))),
                TextSpan(text: "เพื่อจัดลำดับ"),
              ],
            ),
          ),

          const SizedBox(height: 12),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: Color(0xFF555555),
                          ),
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
                                    children: [
                                      Container(
                                        decoration: const BoxDecoration(color: Colors.white),
                                        child: Center(
                                          child: Text(
                                            monthTitle,
                                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
                                          ),
                                        ),
                                      ),
                                      for (int i = 0; i < 5; i++)
                                        if (i < _items.length)
                                          _ReorderableSlot(
                                            key: ObjectKey(_items[i]), 
                                            item: _items[i],
                                            index: i,
                                            onDrop: _handlePhotoDrop,
                                            onTap: () => _handlePhotoTap(i),
                                            onDragStart: () => setState(() => _isDragging = true),
                                            onDragEnd: () => setState(() => _isDragging = false),
                                            imageRadius: _imageRadius,
                                            frameRadius: _frameRadius,
                                          )
                                        else
                                          const SizedBox(),
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
                                    children: [
                                      for (int i = 0; i < 6; i++)
                                        if ((i + 5) < _items.length)
                                          _ReorderableSlot(
                                            key: ObjectKey(_items[i + 5]),
                                            item: _items[i + 5],
                                            index: i + 5,
                                            onDrop: _handlePhotoDrop,
                                            onTap: () => _handlePhotoTap(i + 5),
                                            onDragStart: () => setState(() => _isDragging = true),
                                            onDragEnd: () => setState(() => _isDragging = false),
                                            imageRadius: _imageRadius,
                                            frameRadius: _frameRadius,
                                          )
                                        else
                                          const SizedBox(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 24, 30, 10),
                    child: Text(
                      "นี่คืออัลบั้มรูปของคุณในเดือน$monthTitle พร้อมจะเปลี่ยนช่วงเวลาเหล่านี้ให้\nเป็นความทรงจำสุดพิเศษแล้วหรือยัง?",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color.fromARGB(255, 61, 61, 61),
                        height: 1.5,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Buttons
          Container(
            padding: const EdgeInsets.fromLTRB(20, 25, 20, 50),
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      // ✅ เมื่อกดบันทึก ส่ง _items ไปยังหน้า FinalPreviewSheet
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => FinalPreviewSheet(
                          items: _items,
                          monthName: monthTitle,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFED7D31),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1)),
                      elevation: 0,
                    ),
                    child: const Text('บันทึก', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1)),
                    ),
                    child: const Text('ย้อนกลับ', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageContainer({required Widget child}) {
    return SizedBox(
      width: 160,
      height: 245,
      child: child,
    );
  }
}

// ... (ส่วน _ReorderableSlot, _PhotoSlot, _StepItem เหมือนเดิม ไม่ต้องแก้)
// ถ้าต้องการ ผมสามารถรวมส่วน Widget ย่อยทั้งหมดให้ในคำตอบเดียวได้ครับ 
// แต่เพื่อความกระชับ สามารถใช้ Widget ย่อยเดิมจากคำตอบก่อนหน้าได้เลย

// _ReorderableSlot (ตัวจัดการการลาก) 
class _ReorderableSlot extends StatelessWidget {
  final MediaItem item;
  final int index;
  final Function(PhotoDragData, int) onDrop;
  final VoidCallback onTap;
  final VoidCallback onDragStart;
  final VoidCallback onDragEnd;
  final double imageRadius;
  final double frameRadius;

  const _ReorderableSlot({
    super.key,
    required this.item,
    required this.index,
    required this.onDrop,
    required this.onTap,
    required this.onDragStart,
    required this.onDragEnd,
    required this.imageRadius,
    required this.frameRadius,
  });

  @override
  Widget build(BuildContext context) {
    final photoWidget = _PhotoSlot(
      key: ValueKey(item), 
      item: item, 
      frameRadius: frameRadius, 
      imageRadius: imageRadius
    );

    return DragTarget<PhotoDragData>(
      onWillAcceptWithDetails: (details) => details.data.index != index,
      onAcceptWithDetails: (details) => onDrop(details.data, index),
      builder: (context, candidateData, rejectedData) {
        final isHovered = candidateData.isNotEmpty;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(frameRadius),
            border: isHovered ? Border.all(color: const Color(0xFF5AB6D8), width: 3) : null,
          ),
          child: LongPressDraggable<PhotoDragData>(
            data: PhotoDragData(index),
            feedback: Material(
              color: Colors.transparent,
              child: SizedBox(
                width: 75,
                height: 75,
                child: Opacity(opacity: 0.9, child: photoWidget),
              ),
            ),
            childWhenDragging: Opacity(opacity: 0.3, child: photoWidget),
            onDragStarted: onDragStart,
            onDragEnd: (_) => onDragEnd(),
            child: GestureDetector(
              onTap: onTap,
              child: photoWidget,
            ),
          ),
        );
      },
    );
  }
}class _PhotoSlot extends StatefulWidget {
  final MediaItem item;
  final double frameRadius;
  final double imageRadius;

  const _PhotoSlot({
    super.key,
    required this.item,
    required this.frameRadius,
    required this.imageRadius,
  });

  @override
  State<_PhotoSlot> createState() => _PhotoSlotState();
}

class _PhotoSlotState extends State<_PhotoSlot> {
  Uint8List? _thumbnailData;

  @override
  void initState() {
    super.initState();
    _loadThumbnail();
  }

  @override
  void didUpdateWidget(covariant _PhotoSlot oldWidget) {
    super.didUpdateWidget(oldWidget);
    // เช็คว่า item เปลี่ยน หรือ capturedImage เปลี่ยนหรือไม่ เพื่อโหลดใหม่
    if (oldWidget.item != widget.item || oldWidget.item.capturedImage != widget.item.capturedImage) {
      _loadThumbnail();
    }
  }

  void _loadThumbnail() {
    // ถ้ามีรูปที่ capture มาแล้ว (แก้ไขแล้ว) ไม่ต้องโหลด thumbnail เดิม
    if (widget.item.capturedImage != null) {
      if (mounted) setState(() {}); 
      return;
    }

    widget.item.asset.thumbnailDataWithSize(const ThumbnailSize(300, 300)).then((data) {
      if (mounted && data != null) {
        setState(() {
          _thumbnailData = data;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // -----------------------------------------------------------------
    // [LOGIC ตรวจสอบสถานะ]: รูปนี้ถูกแก้ไขหรือยัง?
    // เช็คว่ามี capturedImage (รูปที่แต่งแล้ว) หรือมี caption (คำบรรยาย) หรือไม่
    // -----------------------------------------------------------------
    bool isModified = widget.item.capturedImage != null || 
                      (widget.item.caption != null && widget.item.caption!.isNotEmpty);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(4.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.imageRadius),
        child: Container(
          color: Colors.grey[200],
          child: Stack(
            fit: StackFit.expand,
            children: [
              // 1. แสดงรูปภาพ (ลำดับล่างสุด)
              if (widget.item.capturedImage != null)
                Image.memory(widget.item.capturedImage!, fit: BoxFit.cover)
              else if (_thumbnailData != null)
                Image.memory(_thumbnailData!, fit: BoxFit.cover)
              else
                Container(color: Colors.grey[200]),

              // 2. [ส่วนที่เพิ่ม] : ไอคอน Status Update (มุมขวาบน)
              if (isModified)
                Positioned(
                  top: 5,
                  right: 5,
                  child: Container(
                    // ใส่เงาเล็กน้อยเพื่อให้มองเห็นชัดบนพื้นหลังสีขาวหรือดำ
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        )
                      ],
                    ),
                    child: Image.asset(
                      'assets/icons/statusupdate.png', // path รูปไอคอน
                      width: 18, // ขนาดไอคอน
                      height: 18,
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
              // --- เส้นซ้าย ---
              Expanded(
                flex: 2,
                child: Container(
                  height: 2,
                  // ถ้า Active เส้นซ้ายเป็นสีฟ้า
                  color: isFirst
                      ? Colors.transparent
                      : (isActive ? const Color(0xFF5AB6D8) : Colors.grey[300]),
                ),
              ),
              
              const SizedBox(width: 40),
              
              // --- จุดวงกลม ---
              Container(
                width: 11,
                height: 11,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive ? const Color(0xFF5AB6D8) : Colors.grey[300],
                ),
              ),
              
              const SizedBox(width: 40),
              
              // --- เส้นขวา ---
              Expanded(
                flex: 2,
                child: Container(
                  height: 2,
                  // Logic: ถ้าไม่ใช่ตัวสุดท้าย และ isCompleted เป็นจริง ให้เป็นสีฟ้า
                  color: isLast
                      ? Colors.transparent
                      : (isCompleted ? const Color(0xFF5AB6D8) : Colors.grey[300]),
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