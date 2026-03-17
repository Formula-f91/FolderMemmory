import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:wememmory/Album/photo_readonly_page.dart';
import 'package:wememmory/Album/print_sheet.dart';
import 'package:wememmory/data/album_data.dart';
import 'package:wememmory/models/media_item.dart';
import 'package:wememmory/services/album_service.dart';

// หน้า พรีวิวสุดท้าย & ยืนยัน
class FinalPreviewSheet extends StatefulWidget {
  final List<MediaItem> items;
  final String monthName;

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

  String get _monthTitle => widget.monthName.split(' ')[0];
  String get _yearTitle {
    final parts = widget.monthName.split(' ');
    return parts.length > 1 ? parts[1] : '';
  }

  // ✅ แสดง Upload Progress Dialog
  Future<void> _onConfirm() async {
    int _current = 0;
    final int _total = widget.items.length;

    // ✅ เปิด Dialog และรอผลลัพธ์
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder:
          (dialogContext) => _UploadProgressDialog(
            monthName: widget.monthName,
            total: _total,
            uploadFuture: AlbumService.saveAlbum(
              monthName: widget.monthName,
              items: widget.items,
              onProgress: (current, total) {
                _current = current;
              },
            ),
            getCurrentProgress: () => _current,
          ),
    );

    if (!mounted) return;

    // ✅ อัพโหลดสำเร็จ → บันทึก local และเปิด PrintSheet
    if (result == true) {
      globalAlbumList.insert(
        0,
        AlbumCollection(month: widget.monthName, items: widget.items),
      );

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder:
            (context) =>
                PrintSheet(items: widget.items, monthName: widget.monthName),
      );
    }
  }

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
          const SizedBox(height: 12),
          Container(
            width: 61,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2.5),
            ),
          ),

          // 1. Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 13, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'พรีวิวสุดท้าย & ยืนยัน',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
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
                  isCompleted: true,
                ),
                _StepItem(label: 'พรีวิวสุดท้าย', isActive: true, isLast: true),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // 3. Toggle Options
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                _buildCustomToggle(
                  "พิมพ์พร้อมคำบรรยาย",
                  _withCaption,
                  (val) => setState(() => _withCaption = val),
                ),
                const SizedBox(height: 12),
                _buildCustomToggle(
                  "พิมพ์พร้อมวันที่",
                  _withDate,
                  (val) => setState(() => _withDate = val),
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

          // 5. Album Preview
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _AlbumPreviewSection(
                    items: widget.items,
                    monthName: widget.monthName,
                  ),
                  const SizedBox(height: 20),
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
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "สร้างภาพสวยๆ เพื่อแชร์ลงโซเชียลมีเดียได้เลย!",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
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
            padding: const EdgeInsets.fromLTRB(16, 30, 16, 99),
            decoration: const BoxDecoration(color: Colors.white),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _onConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFED7D31),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(1),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'ยืนยัน',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                    child: const Text(
                      'ย้อนกลับ',
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
          ),
        ],
      ),
    );
  }

  Widget _buildCustomToggle(
    String label,
    bool value,
    Function(bool) onChanged,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
              color: value ? const Color(0xFFED7D31) : const Color(0xFFE0E0E0),
            ),
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeIn,
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
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

// ✅ Upload Progress Dialog Widget
class _UploadProgressDialog extends StatefulWidget {
  final String monthName;
  final int total;
  final Future<void> uploadFuture;
  final int Function() getCurrentProgress;

  const _UploadProgressDialog({
    required this.monthName,
    required this.total,
    required this.uploadFuture,
    required this.getCurrentProgress,
  });

  @override
  State<_UploadProgressDialog> createState() => _UploadProgressDialogState();
}

class _UploadProgressDialogState extends State<_UploadProgressDialog> {
  int _current = 0;
  bool _isDone = false;
  bool _hasError = false;
  String _errorMsg = '';

  @override
  void initState() {
    super.initState();
    _startUpload();
  }

  Future<void> _startUpload() async {
    // ✅ อัปเดต progress ทุก 300ms
    final ticker = Stream.periodic(const Duration(milliseconds: 300), (_) {
      return widget.getCurrentProgress();
    });

    final sub = ticker.listen((progress) {
      if (mounted && !_isDone) {
        setState(() => _current = progress);
      }
    });

    try {
      await widget.uploadFuture;

      sub.cancel();
      if (mounted) {
        setState(() {
          _current = widget.total;
          _isDone = true;
        });
      }

      // ✅ รอ 1 วินาทีให้เห็น "สำเร็จ" แล้วปิด dialog
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      sub.cancel();
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMsg = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = widget.total > 0 ? _current / widget.total : 0.0;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── ไอคอน ──
            SizedBox(
              width: 64,
              height: 64,
              child:
                  _hasError
                      // ❌ Error
                      ? Container(
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.error_outline,
                          color: Colors.red.shade400,
                          size: 32,
                        ),
                      )
                      : _isDone
                      // ✅ สำเร็จ
                      ? Container(
                        decoration: const BoxDecoration(
                          color: Color(0xFFE8F5E9),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check_circle_outline,
                          color: Color(0xFF66BB6A),
                          size: 32,
                        ),
                      )
                      // ⏳ กำลังโหลด — วงล้อหมุน
                      : const CircularProgressIndicator(
                        color: Color(0xFF6BB0C5),
                        strokeWidth: 4,
                      ),
            ),

            const SizedBox(height: 16),

            // ── ชื่อเดือน ──
            Text(
              widget.monthName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 8),

            // ── ข้อความสถานะ ──
            Text(
              _hasError
                  ? 'เกิดข้อผิดพลาด'
                  : _isDone
                  ? 'บันทึกอัลบั้มสำเร็จ! 🎉'
                  : 'กำลังอัพโหลดรูปภาพ...',
              style: TextStyle(
                fontSize: 14,
                color:
                    _hasError
                        ? Colors.red.shade400
                        : _isDone
                        ? const Color(0xFF66BB6A)
                        : Colors.grey[600],
              ),
            ),

            const SizedBox(height: 20),

            if (!_hasError) ...[
              // ── Progress Bar ──
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: _isDone ? 1.0 : progress,
                  minHeight: 8,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _isDone ? const Color(0xFF66BB6A) : const Color(0xFF6BB0C5),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // ── ตัวเลข ──
              Text(
                _isDone
                    ? '${widget.total}/${widget.total} รูป'
                    : '$_current/${widget.total} รูป',
                style: TextStyle(fontSize: 13, color: Colors.grey[500]),
              ),
            ],

            // ── ปุ่ม error ──
            if (_hasError) ...[
              const SizedBox(height: 16),
              Text(
                _errorMsg,
                style: TextStyle(fontSize: 11, color: Colors.grey[400]),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(false),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade400,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: const Text('ปิด', style: TextStyle(color: Colors.white)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Album Preview Section ──
class _AlbumPreviewSection extends StatelessWidget {
  final List<MediaItem> items;
  final String monthName;

  const _AlbumPreviewSection({required this.items, required this.monthName});

  String get _monthTitle => monthName.split(' ')[0];
  String get _yearTitle {
    final parts = monthName.split(' ');
    return parts.length > 1 ? parts[1] : '';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Center(
        child: FittedBox(
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
                      children: [
                        Container(
                          decoration: const BoxDecoration(color: Colors.white),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _monthTitle,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (_yearTitle.isNotEmpty)
                                  Text(
                                    _yearTitle,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        for (int i = 0; i < 5; i++)
                          if (i < items.length)
                            _StaticPhotoSlot(item: items[i])
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

// ── Static Photo Slot ──
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
      if (mounted) setState(() => _imageData = widget.item.capturedImage);
    } else {
      final data = await widget.item.asset.thumbnailDataWithSize(
        const ThumbnailSize(300, 300),
      );
      if (mounted) setState(() => _imageData = data);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isEdited =
        widget.item.caption.isNotEmpty || widget.item.tags.isNotEmpty;

    return GestureDetector(
      onTap:
          isEdited
              ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PhotoReadonlyPage(item: widget.item),
                  ),
                );
              }
              : null,
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
                if (_imageData != null)
                  Image.memory(_imageData!, fit: BoxFit.cover)
                else
                  Container(color: Colors.grey[200]),
                if (isEdited)
                  Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 2,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/icons/alert.png',
                              width: 11,
                              height: 11,
                              color: Colors.white,
                              fit: BoxFit.contain,
                            ),
                            const Text(
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

// ── Step Item ──
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
