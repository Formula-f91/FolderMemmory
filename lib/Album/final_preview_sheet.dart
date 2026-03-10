import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:wememmory/Album/photo_readonly_page.dart';
import 'package:wememmory/Album/print_sheet.dart'; 
import 'package:wememmory/models/media_item.dart';

// หน้า พรีวิวสุดท้าย & ยืนยัน
class FinalPreviewSheet extends StatefulWidget {
  final List<MediaItem> items; //รับรูปภาพมาแสดง มาจาก album_layout_page.dart
  final String monthName; //รับตัวแปร ชื่อเดือนมา มาจาก album_layout_page.dart

  const FinalPreviewSheet({
    super.key,
    required this.items,
    required this.monthName,
  });

  @override
  State<FinalPreviewSheet> createState() => _FinalPreviewSheetState();
}

class _FinalPreviewSheetState extends State<FinalPreviewSheet> {
  bool _withCaption = false;
  bool _withDate = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.95,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // ---------------------------------------------------------
          // Slide Indicator
          // ---------------------------------------------------------
          const SizedBox(height: 12),
          Container(
            width: 61,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2.5),
            ),
          ),
          // ---------------------------------------------------------

          // 1. Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 13, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'พรีวิวสุดท้าย & ยืนยัน',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
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
                // Step 1: เลือกรูปภาพ
                _StepItem(
                  label: 'เลือกรูปภาพ', 
                  isActive: true,
                  isFirst: true,
                  isCompleted: true,
                ),
                // Step 2: แก้ไขและจัดเรียง
                _StepItem(
                  label: 'แก้ไขและจัดเรียง', 
                  isActive: true,
                  isCompleted: true, 
                ),
                // Step 3: พรีวิวสุดท้าย
                _StepItem(
                  label: 'พรีวิวสุดท้าย', 
                  isActive: true, 
                  isLast: true,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // 3. Toggle Options (เรียกใช้ Custom Toggle)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                _buildCustomToggle(
                  "พิมพ์พร้อมคำบรรยาย", 
                  _withCaption, 
                  (val) => setState(() => _withCaption = val)
                ),
                const SizedBox(height: 12),
                _buildCustomToggle(
                  "พิมพ์พร้อมวันที่", 
                  _withDate, 
                  (val) => setState(() => _withDate = val)
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 4. Preview Text
          Text(
            "คอลเลกชัน${widget.monthName}ของคุณจะออกมาเป็นแบบนี้..\nพร้อมที่จะสร้างความทรงจำที่จับต้องได้แล้วหรือยัง?",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),

          const SizedBox(height: 16),

          // 5. Album Preview Area
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _AlbumPreviewSection(items: widget.items, monthName: widget.monthName),

                  const SizedBox(height: 20),

                  // กล่องข้อความสีฟ้าอ่อน
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F2F7),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFB3E0EE)),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "พร้อมแบ่งปันความทรงจำแล้วหรือยัง?",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "สร้างภาพสวยๆ เพื่อแชร์ลงโซเชียลมีเดียได้เลย!",
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // 6. Bottom Buttons
          Container(
            padding: const EdgeInsets.fromLTRB(16, 30 , 16, 99),
            decoration: const BoxDecoration(
              color: Colors.white,
              // border: Border(top: BorderSide(color: Colors.black12)),
            ),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => PrintSheet(
                          items: widget.items,
                          monthName: widget.monthName,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFED7D31),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1)),
                      elevation: 0,
                    ),
                    child: const Text('ยืนยัน', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
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

  // ✅ ฟังก์ชัน Custom Toggle ที่ปรับปรุงให้ใช้ซ้ำได้
  Widget _buildCustomToggle(String label, bool value, Function(bool) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label, 
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)
        ),
        GestureDetector(
          onTap: () => onChanged(!value),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 50,
            height: 30,
            padding: const EdgeInsets.all(3.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              // พื้นหลัง: สีส้ม (เปิด) / สีเทาอ่อน (ปิด)
              color: value
                  ? const Color(0xFFED7D31)
                  : const Color(0xFFE0E0E0),
            ),
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeIn,
              // สลับตำแหน่งซ้าย-ขวา
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  // วงกลมเป็นสีขาวเมื่อเปิด, เป็นสีเทาเข้มเมื่อปิด
                  color: value ? Colors.white : const Color(0xFFC7C7C7),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// _AlbumPreviewSection
class _AlbumPreviewSection extends StatelessWidget {
  final List<MediaItem> items;
  final String monthName;

  const _AlbumPreviewSection({
    required this.items,
    required this.monthName,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Color(0xFF555555), // สีเทาเข้ม
            ),
            child: IntrinsicWidth(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // หน้าซ้าย
                  _buildPageContainer(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 3,
                      mainAxisSpacing: 3,
                      childAspectRatio: 1.0,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        // Slot 0: ชื่อเดือน
                        Container(
                          decoration: const BoxDecoration(color: Colors.white),
                          child: Center(
                            child: Text(
                              monthName,
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        // Slot 1-5: รูปภาพ
                        for (int i = 0; i < 5; i++)
                          if (i < items.length)
                            _StaticPhotoSlot(item: items[i])
                          else
                            const SizedBox(),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  // หน้าขวา
                  _buildPageContainer(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 3,
                      mainAxisSpacing: 3,
                      childAspectRatio: 1.0,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        // Slots 6-11: รูปภาพ
                        for (int i = 0; i < 6; i++)
                          if ((i + 5) < items.length)
                            _StaticPhotoSlot(item: items[i + 5])
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
    );
  }

  Widget _buildPageContainer({required Widget child}) {
    return SizedBox(width: 160, height: 245, child: child);
  }
}

// _StaticPhotoSlot
class _StaticPhotoSlot extends StatefulWidget {
  final MediaItem item;
  const _StaticPhotoSlot({required this.item});

  @override
  State<_StaticPhotoSlot> createState() => _StaticPhotoSlotState();
}

class _StaticPhotoSlotState extends State<_StaticPhotoSlot> {
  Uint8List? _imageData;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    if (widget.item.capturedImage != null) {
      if (mounted) {
        setState(() {
          _imageData = widget.item.capturedImage;
        });
      }
    } else {
      final data = await widget.item.asset.thumbnailDataWithSize(const ThumbnailSize(300, 300));
      if (mounted) {
        setState(() {
          _imageData = data;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ เช็คว่ามีการแก้ไขหรือไม่ (มี caption หรือ tags)
    bool isEdited = widget.item.caption.isNotEmpty || widget.item.tags.isNotEmpty;

    return GestureDetector(
      // ✅ ถ้ามีการแก้ไข ให้กดแล้วไปหน้า PhotoReadonlyPage
      onTap: isEdited ? () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PhotoReadonlyPage(item: widget.item),
          ),
        );
      } : null,
      child: Container(
        decoration: const BoxDecoration(color: Colors.white),
        padding: const EdgeInsets.all(4.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6.0),
          child: Container(
            color: Colors.grey[200],
            child: Stack(
              fit: StackFit.expand,
              children: [
                // แสดงรูปภาพ
                if (_imageData != null)
                  Image.memory(_imageData!, fit: BoxFit.cover)
                else
                  Container(color: Colors.grey[200]),

                // ✅ แสดง Overlay "แตะเพื่ออ่าน" เฉพาะรูปที่มีการแก้ไข
                if (isEdited)
                  Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3), // พื้นหลังสีดำจางๆ
                          borderRadius: BorderRadius.circular(20),
                          // border: Border.all(color: Colors.white.withOpacity(0.5), width: 1),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children:  [
                             Image.asset(
                               'assets/icons/alert.png',
                               width: 11,
                               height: 11,
                               color: Colors.white, // ใส่สีขาวเพื่อให้เห็นชัดบนพื้นดำ (ลบออกได้ถ้ารูปมีสีอยู่แล้ว)
                               fit: BoxFit.contain,
                             ),
                            //  SizedBox(width: 2),
                             Text(
                              "แตะเพื่ออ่าน",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
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
      ),
    );
  }
}
// _StepItem
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
                  color: isFirst
                      ? Colors.transparent
                      : (isActive ? const Color(0xFF5AB6D8) : Colors.grey[300]),
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