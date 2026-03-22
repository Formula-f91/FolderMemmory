import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:wememmory/Album/album_layout_page.dart';
import 'package:wememmory/models/media_item.dart';
import 'package:wememmory/cupping/cartPage.dart';

class UploadPhotoPage extends StatefulWidget {
  final String selectedMonth;
  const UploadPhotoPage({super.key, required this.selectedMonth});

  @override
  State<UploadPhotoPage> createState() => _UploadPhotoPageState();
}

class _UploadPhotoPageState extends State<UploadPhotoPage> {
  final List<MediaItem> mediaList = [];
  final List<MediaItem> selectedItems = [];
  final Map<String, Future<Uint8List?>> _thumbnailFutures = {};

  List<AssetPathEntity> albums = [];
  AssetPathEntity? selectedAlbum;

  bool isLoading = true;

  // ✅ แยก monthTitle และ yearTitle จาก selectedMonth ("มกราคม 2025")
  String get _monthTitle {
    final parts = widget.selectedMonth.split(' ');
    return parts[0];
  }

  String get _yearTitle {
    final parts = widget.selectedMonth.split(' ');
    return parts.length > 1 ? parts[1] : '';
  }

  @override
  void initState() {
    super.initState();
    _loadAlbums();
  }

  Future<void> _loadAlbums() async {
    setState(() => isLoading = true);
    final ps = await PhotoManager.requestPermissionExtend();
    if (!ps.isAuth) {
      PhotoManager.openSetting();
      return;
    }

    final filterOption = FilterOptionGroup(
      orders: [const OrderOption(type: OrderOptionType.createDate, asc: false)],
    );

    albums = await PhotoManager.getAssetPathList(
      type: RequestType.common,
      filterOption: filterOption,
    );

    if (albums.isNotEmpty) {
      selectedAlbum = albums.first;
      await _loadMediaFromAlbum(selectedAlbum!);
    } else {
      setState(() => isLoading = false);
    }
  }

  Future<void> _loadMediaFromAlbum(AssetPathEntity album) async {
    setState(() => isLoading = true);
    final List<AssetEntity> assets = await album.getAssetListPaged(
      page: 0,
      size: 1000,
    );

    final List<MediaItem> temp =
        assets.map((a) {
          return MediaItem(
            asset: a,
            type: a.type == AssetType.video ? MediaType.video : MediaType.image,
          );
        }).toList();

    setState(() {
      mediaList.clear();
      mediaList.addAll(temp);
      _thumbnailFutures.clear();
      isLoading = false;
    });
  }

  void _toggleSelection(MediaItem item) {
    setState(() {
      final existingIndex = selectedItems.indexWhere(
        (s) => s.asset.id == item.asset.id,
      );
      if (existingIndex != -1) {
        selectedItems.removeAt(existingIndex);
      } else {
        if (selectedItems.length < 11) {
          selectedItems.add(item);
        } else {
          _showMaxLimitSnackBar();
        }
      }
    });
  }

  void _showMaxLimitSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('เลือกได้สูงสุด 11 ไฟล์'),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  void _onNextPressed() {
    if (selectedItems.isNotEmpty) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder:
            (context) => AlbumLayoutPage(
              selectedItems: selectedItems,
              // ✅ ส่ง selectedMonth เต็ม ("มกราคม 2025") ไปให้ AlbumLayoutPage
              monthName: widget.selectedMonth,
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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

          // ✅ Header แสดงเดือน + ปี ครบถ้วน
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 13, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        // ✅ แสดง "มกราคม 2025 : เลือกรูปภาพ 11 รูป"
                        '$_monthTitle${_yearTitle.isNotEmpty ? ' $_yearTitle' : ''} : เลือกรูปภาพ 11 รูป',
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, size: 28),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 7),
            child: Row(
              children: [
                _StepItem(label: 'เลือกรูปภาพ', isActive: true, isFirst: true),
                _StepItem(label: 'แก้ไขและจัดเรียง', isActive: false),
                _StepItem(
                  label: 'พรีวิวสุดท้าย',
                  isActive: false,
                  isLast: true,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Dropdown เลือกอัลบั้ม
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                const Text(
                  "อัลบั้ม: ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child:
                          albums.isEmpty
                              ? const Padding(
                                padding: EdgeInsets.symmetric(vertical: 14),
                                child: Text(
                                  "กำลังโหลด...",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              )
                              : DropdownButton<String>(
                                value: selectedAlbum?.id,
                                isExpanded: true,
                                items:
                                    albums.map((album) {
                                      return DropdownMenuItem<String>(
                                        value: album.id,
                                        child: Text(
                                          album.name == "Recent"
                                              ? "รูปภาพทั้งหมด"
                                              : album.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      );
                                    }).toList(),
                                onChanged: (String? albumId) {
                                  if (albumId != null) {
                                    final album = albums.firstWhere(
                                      (a) => a.id == albumId,
                                    );
                                    setState(() => selectedAlbum = album);
                                    _loadMediaFromAlbum(album);
                                  }
                                },
                              ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Media Grid
          Expanded(
            child:
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                      itemCount: mediaList.length,
                      itemBuilder: (context, index) {
                        final item = mediaList[index];
                        final selectionIndex = selectedItems.indexWhere(
                          (s) => s.asset.id == item.asset.id,
                        );
                        final isSelected = selectionIndex != -1;

                        return GestureDetector(
                          onTap: () => _toggleSelection(item),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              _buildThumbnail(item),
                              if (isSelected)
                                _buildSelectionOverlay(selectionIndex),
                            ],
                          ),
                        );
                      },
                    ),
          ),

          _buildBottomSection(),
        ],
      ),
    );
  }

  Widget _buildThumbnail(MediaItem item) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: FutureBuilder<Uint8List?>(
        future:
            _thumbnailFutures[item.asset.id] ??= item.asset
                .thumbnailDataWithSize(const ThumbnailSize(200, 200)),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Image.memory(snapshot.data!, fit: BoxFit.cover);
          }
          return Container(color: Colors.grey[200]);
        },
      ),
    );
  }

  Widget _buildSelectionOverlay(int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color.fromARGB(255, 77, 231, 82),
          width: 3,
        ),
      ),
    );
  }

  Widget _buildBottomSection() {
    return Container(
      padding: const EdgeInsets.only(top: 18, bottom: 30),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.black12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (selectedItems.isNotEmpty)
            SizedBox(
              height: 80,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: selectedItems.length,
                itemBuilder: (context, index) {
                  final item = selectedItems[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        _buildThumbnail(item),

                        // หมายเลขลำดับ (มุมซ้ายบน)
                        Positioned(
                          top: 4,
                          left: 4,
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: const BoxDecoration(
                              color: Color(0xFF5AB6D8),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),

                        // ปุ่มลบ (ตรงกลาง)
                        Positioned.fill(
                          child: Center(
                            child: GestureDetector(
                              onTap:
                                  () => setState(
                                    () => selectedItems.removeAt(index),
                                  ),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.5),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 24,
                                ),
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

          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: selectedItems.isNotEmpty ? _onNextPressed : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 238, 145, 5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'ถัดไป (${selectedItems.length}/11)',
                  style: const TextStyle(
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
    );
  }
}

class _StepItem extends StatelessWidget {
  final String label;
  final bool isActive;
  final bool isFirst;
  final bool isLast;

  const _StepItem({
    super.key,
    required this.label,
    required this.isActive,
    this.isFirst = false,
    this.isLast = false,
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
                  color: isLast ? Colors.transparent : Colors.grey[300],
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
