import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:wememmory/Album/order_success_page.dart';
import 'package:wememmory/models/media_item.dart';

// หน้า สั่งพิมพ์อัลบั้มรูป
class PrintSheet extends StatefulWidget {
  final List<MediaItem> items; //รับตัวแปรมาแสดงภาพ จาก final_preview_sheet.dart
  final String monthName; //รับชื่อเดือนมาแสดง จาก final_preview_sheet.dart

  const PrintSheet({
    super.key,
    required this.items,
    required this.monthName,
  });

  @override
  State<PrintSheet> createState() => _PrintSheetState();
}

class _PrintSheetState extends State<PrintSheet> {
  bool _isGift = false;

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
          // Slide Indicator (แถบขีดด้านบน)
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
            padding: const EdgeInsets.fromLTRB(20, 13, 20, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'สั่งพิมพ์',
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
          const SizedBox(height: 9),
          Divider(
            height: 1,       
            color: Colors.grey.withOpacity(0.2), 
            indent: 20,
            endIndent: 20,
          ),

          // 2. Content Scrollable
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // หัวข้ออัลบั้ม
                  const Text("อัลบั้มรูปของคุณ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),

                  // ส่วนแสดงรูป (ใช้ Widget ที่แยกไว้)
                  _PrintPreviewSection(items: widget.items, monthName: widget.monthName),

                  const SizedBox(height: 24),

                  // 1. ที่อยู่ผู้ส่ง (แสดงตลอด)
                  _buildAddressCard(
                    title: "ที่อยู่",
                    address: "หมู่บ้าน สุวรรณภูมิทาวน์ซอย ลาดกระบัง 54/3 ถนนลาดกระบัง\nแขวงลาดกระบัง เขตลาดกระบัง กรุงเทพมหานคร",
                  ),

                  const SizedBox(height: 24),

                  // Toggle ส่งของขวัญ
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("ส่งของขวัญ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      // ✅ เรียกใช้ Custom Switch ตรงนี้
                      _buildCustomSwitch(
                        _isGift, 
                        (val) => setState(() => _isGift = val)
                      ),
                    ],
                  ),

                  // 2. ที่อยู่ผู้รับ (แสดงเมื่อเปิด Gift Mode)
                  if (_isGift) ...[
                    const SizedBox(height: 20),
                    _buildAddressCard(
                      title: "ที่อยู่ผู้รับของขวัญ",
                      address: "กรุณาเลือกที่อยู่ผู้รับ...",
                    ),
                  ],

                  const SizedBox(height: 20),

                  // กล่องยอดเครดิต
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF67A5BA),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text("ยอดเครดิตคงเหลือ : ", style: TextStyle(color: Colors.white, fontSize: 14)),
                                Image.asset(
                                  'assets/icons/dollar-circle.png',
                                  width: 24,
                                  height: 24,
                                ),
                                const SizedBox(width: 4),
                                const Text("10", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const SizedBox(height: 2),
                            const Text("เติมเครดิตตามจำนวนที่คุณต้องการ", style: TextStyle(color: Colors.white70, fontSize: 11)),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF67A5BA),
                            minimumSize: const Size(80, 32),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          ),
                          child: const Text("เติมเครดิต", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // รายละเอียดการสั่งพิมพ์
                  const Text("รายละเอียดการสั่งพิมพ์", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("อัลบั้มรูปของคุณ", style: TextStyle(color: Colors.black87, fontSize: 14)),
                      Row(
                        children: [
                          Image.asset(
                            'assets/icons/dollar-circle.png',
                            width: 24,
                            height: 24,
                          ),
                          const SizedBox(width: 4),
                          const Text("10", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // 3. Bottom Bar
          Container(
            padding: const EdgeInsets.fromLTRB(15, 10 , 16, 30),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.black12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // --- ส่วนแสดงเครดิต (ซ้าย) ---
                Row(
                  children: [
                    const Text(
                      "เครดิตที่ต้องใช้",
                      style: TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.normal),
                    ),
                    const SizedBox(width: 8),
                    Image.asset(
                      'assets/icons/dollar-circle.png',
                      width: 24,
                      height: 24,
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      "10",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                  ],
                ),

                // --- ปุ่มสั่งพิมพ์ (ขวา) ---
                SizedBox(
                  width: 140,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderSuccessPage(
                            items: widget.items,
                            monthName: widget.monthName,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFED7D31),
                      shape: const RoundedRectangleBorder(),
                      elevation: 0,
                    ),
                    child: const Text(
                      "สั่งพิมพ์",
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
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

  // ✅ Helper Widget สำหรับสร้างกล่องที่อยู่
  Widget _buildAddressCard({required String title, required String address}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[200]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  address,
                  style: TextStyle(color: Colors.grey[600], fontSize: 13, height: 1.4),
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ],
    );
  }

  // ✅ Custom Switch Widget (ปรับให้รับค่า value และ onChanged)
  Widget _buildCustomSwitch(bool value, Function(bool) onChanged) {
    return GestureDetector(
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
              // วงกลมเป็นสีขาวเมื่อเปิด, เป็นสีเทาเข้ม (C7C7C7) เมื่อปิด
              color: value ? Colors.white : const Color(0xFFC7C7C7),
            ),
          ),
        ),
      ),
    );
  }
}

// ... _PrintPreviewSection ... (ส่วนนี้เหมือนเดิม)
class _PrintPreviewSection extends StatelessWidget {
  final List<MediaItem> items;
  final String monthName;

  const _PrintPreviewSection({
    required this.items,
    required this.monthName,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
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
                            monthName,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
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

// ... _StaticPhotoSlot ... (ส่วนนี้เหมือนเดิม)
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