import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:wememmory/collection/month_detail_page.dart';
import 'package:wememmory/collection/share_sheet.dart';
import 'package:wememmory/constants.dart';
import 'package:wememmory/data/album_data.dart';
import 'package:wememmory/models/media_item.dart' hide AlbumCollection;
import 'package:wememmory/shop/chooseMediaItem.dart';

// หน้า สมุดภาพ
class CollectionPage extends StatefulWidget {
  final List<MediaItem>? newAlbumItems;
  final String? newAlbumMonth;

  const CollectionPage({super.key, this.newAlbumItems, this.newAlbumMonth});

  @override
  State<CollectionPage> createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
  String? _selectedYear;

  List<String> get _availableYears {
    final years =
        globalAlbumList
            .map((a) {
              final parts = a.month.split(' ');
              return parts.length > 1 ? parts[1] : '';
            })
            .where((y) => y.isNotEmpty)
            .toSet()
            .toList();
    years.sort((a, b) => b.compareTo(a));
    return years;
  }

  List<dynamic> get _filteredAlbums {
    if (_selectedYear == null) return globalAlbumList;
    return globalAlbumList.where((a) {
      final parts = a.month.split(' ');
      return parts.length > 1 && parts[1] == _selectedYear;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    if (widget.newAlbumItems != null && widget.newAlbumMonth != null) {
      bool isDuplicate = globalAlbumList.any(
        (album) =>
            album.month == widget.newAlbumMonth &&
            album.items == widget.newAlbumItems,
      );
      if (!isDuplicate) {
        globalAlbumList.insert(
          0,
          AlbumCollection(
            month: widget.newAlbumMonth!,
            items: widget.newAlbumItems!,
          ),
        );
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_availableYears.isNotEmpty && mounted) {
        setState(() => _selectedYear = _availableYears.first);
      }
    });
  }

  // ✅ ลบอัลบั้ม พร้อม Confirm Dialog
  Future<void> _deleteAlbum(dynamic album) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text(
              "ลบอัลบั้ม",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Text(
              "ต้องการลบอัลบั้ม \"${album.month}\" ใช่หรือไม่?\nการกระทำนี้ไม่สามารถย้อนกลับได้",
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text(
                  "ยกเลิก",
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(ctx, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade400,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("ลบ"),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      setState(() {
        globalAlbumList.remove(album);
        // ✅ ถ้าปีที่เลือกไม่มีอัลบั้มเหลือแล้ว ให้ reset dropdown
        if (_selectedYear != null && !_availableYears.contains(_selectedYear)) {
          _selectedYear =
              _availableYears.isNotEmpty ? _availableYears.first : null;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredAlbums;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: _SearchBar(),
            ),

            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildYearDropdown(),
            ),

            const SizedBox(height: 16),

            Expanded(
              child:
                  filtered.isEmpty
                      ? Center(
                        child: Text(
                          globalAlbumList.isEmpty
                              ? "ยังไม่มีคอลเลกชัน"
                              : "ไม่พบอัลบั้มในปี $_selectedYear",
                          style: const TextStyle(color: Colors.grey),
                        ),
                      )
                      : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final album = filtered[index];
                          return Column(
                            children: [
                              // ✅ ส่ง onDelete ไปให้ Header
                              _MonthSectionHeader(
                                title: album.month,
                                items: album.items,
                                onDelete: () => _deleteAlbum(album),
                              ),
                              const SizedBox(height: 12),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => MonthDetailPage(
                                            monthName: album.month,
                                            items: album.items,
                                          ),
                                    ),
                                  );
                                },
                                child: _AlbumPreviewSection(
                                  items: album.items,
                                  monthName: album.month,
                                ),
                              ),
                              const SizedBox(height: 30),
                            ],
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildYearDropdown() {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child:
            _availableYears.isEmpty
                ? const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "ยังไม่มีอัลบั้ม",
                    style: TextStyle(color: Colors.grey),
                  ),
                )
                : DropdownButton<String>(
                  value: _selectedYear,
                  isExpanded: true,
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Color(0xFF6BB0C5),
                  ),
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  items: [
                    DropdownMenuItem<String>(
                      value: null,
                      child: Text(
                        "ทั้งหมด",
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    ..._availableYears.map(
                      (year) => DropdownMenuItem<String>(
                        value: year,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_today_outlined,
                              size: 16,
                              color: Color(0xFF6BB0C5),
                            ),
                            const SizedBox(width: 8),
                            Text(year),
                            const SizedBox(width: 8),
                            Text(
                              "(${globalAlbumList.where((a) {
                                final parts = a.month.split(' ');
                                return parts.length > 1 && parts[1] == year;
                              }).length} อัลบั้ม)",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade500,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  onChanged: (val) => setState(() => _selectedYear = val),
                ),
      ),
    );
  }
}

// ── Month Section Header — เพิ่มปุ่ม Delete ──
class _MonthSectionHeader extends StatelessWidget {
  final String title;
  final List<MediaItem>? items;
  final VoidCallback onDelete; // ✅ รับ callback ลบ

  const _MonthSectionHeader({
    required this.title,
    required this.onDelete,
    this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        Row(
          children: [
            // ปุ่ม Print
            GestureDetector(
              onTap: () {
                if (items != null && items!.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderPage(items: items!),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('ไม่มีรูปภาพในคอลเลกชันนี้')),
                  );
                }
              },
              child: _buildIconButton('assets/icons/print.png'),
            ),
            const SizedBox(width: 8),

            // ปุ่ม Share
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => const ShareSheet(),
                );
              },
              child: _buildIconButton('assets/icons/share.png'),
            ),
            const SizedBox(width: 8),

            // ✅ ปุ่ม Delete
            GestureDetector(
              onTap: onDelete,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red.shade200),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(10),
                child: Icon(
                  Icons.delete_outline,
                  size: 20,
                  color: Colors.red.shade300,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

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
    return Center(
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
    return Container(
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
            ],
          ),
        ),
      ),
    );
  }
}

// ── Search Bar ──
class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0x0D6BB0C5),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Image.asset(
            'assets/icons/Search.png',
            width: 18,
            height: 18,
            color: Colors.black,
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: TextField(
              cursorColor: Colors.black,
              style: TextStyle(color: Colors.black, fontSize: 14.5),
              decoration: InputDecoration(
                hintText: 'ค้นหาความทรงจำตามแท็กและโน้ต.....',
                isDense: true,
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
