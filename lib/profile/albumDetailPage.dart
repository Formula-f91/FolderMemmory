import 'package:flutter/material.dart';

// ==============================================================================
// 0. ENUM & CONFIG: กำหนดสถานะออเดอร์
// ==============================================================================
enum OrderStatus {
  waitingPayment, // รอชำระ
  printing,       // สั่งพิมพ์ (เตรียมจัดส่ง)
  preparing,      // เตรียมจัดส่ง
  shipping,       // ที่ต้องได้รับ (ขนส่ง)
  completed,      // สำเร็จ
  returned,       // คืนสินค้า
  cancelled       // ยกเลิก
}

// ==============================================================================
// 1. PAGE: หน้าประวัติอัลบั้ม (AlbumHistoryPage - หน้ารายการรวม)
// ==============================================================================
class AlbumHistoryPage extends StatelessWidget {
  const AlbumHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // กำหนดสีธีม
    const kOrangeColor = Color(0xFFF05A28);
    const kGreenColor = Color(0xFF28C668);
    const kRedColor = Color(0xFFFF3B30);
    const kPeachColor = Color(0xFFFDCB9E); // สีพื้นหลังไอคอนตอนคืนสินค้า
    const kPeachIconColor = Color(0xFFFDB67F); // สีวงกลมตอนคืนสินค้า

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'ประวัติอัลบั้ม',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w800),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Banner ส่วนหัว
          const _HeaderBanner(),
          const SizedBox(height: 20),

          // =================================================================
          // GROUP 1: อัลบั้มปกติ
          // =================================================================
          
          // 1. รอชำระ (Waiting Payment)
          _HistoryCard(
            title: 'อัลบั้มสำหรับใส่รูปครอบครัว',
            statusText: 'รอชำระ',
            barCount: 1,
            mainColor: kOrangeColor,
            icon: const Icon(Icons.access_time_filled, color: Colors.white, size: 18), // นาฬิกา
            onTap: () => _goToDetail(context, OrderStatus.waitingPayment),
          ),

          // 2. เตรียมจัดส่ง (Preparing)
          _HistoryCard(
            title: 'อัลบั้มสำหรับใส่รูปครอบครัว',
            statusText: 'เตรียมจัดส่ง',
            barCount: 2,
            mainColor: kOrangeColor,
            icon: Image.asset('assets/icons/cube.png', width: 18, color: Colors.white, errorBuilder: (c,e,s)=>const Icon(Icons.inventory_2, color: Colors.white, size: 18)), // กล่อง
            onTap: () => _goToDetail(context, OrderStatus.preparing),
          ),

          // 3. ที่ต้องได้รับ (Shipping)
          _HistoryCard(
            title: 'อัลบั้มสำหรับใส่รูปครอบครัว',
            statusText: 'ที่ต้องได้รับ',
            barCount: 3,
            mainColor: kOrangeColor,
            icon: Image.asset('assets/icons/truck.png', width: 18, color: Colors.white, errorBuilder: (c,e,s)=>const Icon(Icons.local_shipping, color: Colors.white, size: 18)), // รถ
            onTap: () => _goToDetail(context, OrderStatus.shipping),
          ),

          // 4. สำเร็จ (Completed)
          _HistoryCard(
            title: 'อัลบั้มสำหรับใส่รูปครอบครัว',
            statusText: 'สำเร็จ',
            barCount: 4,
            mainColor: kGreenColor,
            isCompleted: true, // เต็มหลอด
            icon: const Icon(Icons.check, color: Colors.white, size: 18), // ติ๊กถูก
            onTap: () => _goToDetail(context, OrderStatus.completed),
          ),

          // 5. คืนสินค้า (Returned)
          _HistoryCard(
            title: 'อัลบั้มสำหรับใส่รูปครอบครัว',
            statusText: 'คืนสินค้า',
            barCount: 4,
            mainColor: kPeachColor, // สีส้มอ่อน
            overrideIconBgColor: kPeachIconColor,
            icon: const Icon(Icons.cached, color: Colors.white, size: 18), // ไอคอนหมุนวน
            onTap: () => _goToDetail(context, OrderStatus.returned),
          ),

          // 6. ยกเลิก (Cancelled)
          _HistoryCard(
            title: 'อัลบั้มสำหรับใส่รูปครอบครัว',
            statusText: 'ยกเลิก',
            barCount: 4,
            mainColor: kRedColor, // สีแดง
            isCompleted: true,
            icon: Image.asset('assets/icons/bag-cross.png', width: 18, color: Colors.white, errorBuilder: (c,e,s)=>const Icon(Icons.lock, color: Colors.white, size: 18)), // แม่กุญแจ/ถุงกากบาท
            onTap: () => _goToDetail(context, OrderStatus.cancelled),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Divider(thickness: 1, color: Color(0xFFEEEEEE)),
          ),

          // =================================================================
          // GROUP 2: สั่งพิมพ์รูปภาพ (Gift / ของขวัญ)
          // =================================================================

          // 7. สั่งพิมพ์ (Gift - Printing)
          _HistoryCard(
            title: 'สั่งพิมพ์รูปภาพ',
            statusText: 'สั่งพิมพ์',
            barCount: 2,
            isGift: true, // โชว์ Tag ของขวัญ
            mainColor: kOrangeColor,
            icon: Image.asset('assets/icons/cube.png', width: 18, color: Colors.white, errorBuilder: (c,e,s)=>const Icon(Icons.print, color: Colors.white, size: 18)),
            onTap: () => _goToDetail(context, OrderStatus.printing),
          ),

          // 8. ที่ต้องได้รับ (Gift - Shipping)
          _HistoryCard(
            title: 'สั่งพิมพ์รูปภาพ',
            statusText: 'ที่ต้องได้รับ',
            barCount: 3,
            mainColor: kOrangeColor,
            icon: Image.asset('assets/icons/truck.png', width: 18, color: Colors.white, errorBuilder: (c,e,s)=>const Icon(Icons.local_shipping, color: Colors.white, size: 18)),
            onTap: () => _goToDetail(context, OrderStatus.shipping),
          ),

          // 9. สำเร็จ (Gift - Completed)
          _HistoryCard(
            title: 'สั่งพิมพ์รูปภาพ',
            statusText: 'สำเร็จ',
            barCount: 4,
            mainColor: kGreenColor,
            isCompleted: true,
            icon: const Icon(Icons.check, color: Colors.white, size: 18),
            onTap: () => _goToDetail(context, OrderStatus.completed),
          ),

          // 10. คืนสินค้า (Gift - Returned)
          _HistoryCard(
            title: 'สั่งพิมพ์รูปภาพ',
            statusText: 'คืนสินค้า',
            barCount: 4,
            mainColor: kPeachColor,
            overrideIconBgColor: kPeachIconColor,
            icon: const Icon(Icons.cached, color: Colors.white, size: 18),
            onTap: () => _goToDetail(context, OrderStatus.returned),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  void _goToDetail(BuildContext context, OrderStatus status) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OrderDetailPage(status: status)),
    );
  }
}

// ==============================================================================
// 2. PAGE: หน้ารายละเอียดออเดอร์ (OrderDetailPage - หน้าปลายทาง)
// ==============================================================================
class OrderDetailPage extends StatelessWidget {
  final OrderStatus status;

  const OrderDetailPage({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final info = _getStatusInfo(status);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'รายละเอียดออเดอร์',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            // ส่วนหัว
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('อัลบั้มสำหรับใส่รูปครอบครัว', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text('จำนวน 1 ชิ้น', style: TextStyle(fontSize: 14, color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 15),

            // สถานะ
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('สถานะ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(
                  info.label,
                  style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold,
                    color: status == OrderStatus.cancelled ? Colors.black : info.color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Progress Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('วันที่ 20 มิถุนายน 2568', style: TextStyle(color: Colors.grey, fontSize: 13)),
                SizedBox(width: 140, height: 32, child: _buildDetailProgressBar(info)),
              ],
            ),
            const SizedBox(height: 20),

            // รูปภาพ
            Container(
              height: 220, width: double.infinity,
              decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
              child: Image.asset('assets/images/album.png', fit: BoxFit.contain, errorBuilder: (c,e,s) => const Center(child: Icon(Icons.photo, size: 50, color: Colors.grey))),
            ),
            const SizedBox(height: 20),

            // ที่อยู่
            Container(
              width: double.infinity, padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: const Color(0xFF333333), borderRadius: BorderRadius.circular(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('ที่อยู่', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  const Text('หมู่บ้าน สุวรรณภูมิทาวน์ซอย ลาดกระบัง 54/3 ถนนลาดกระบัง แขวงลาดกระบัง เขตลาดกระบัง กรุงเทพมหานคร', style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4)),
                  const SizedBox(height: 25),
                  _buildInfoRow('ช่องทางชำระเงิน', 'QR พร้อมเพย์'),
                  const SizedBox(height: 8),
                  _buildInfoRow('ชำระเงิน', '10 ม.ค. 2025'),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Conditional UI
            if (status == OrderStatus.shipping) ...[
              _buildStatusBlueBox(context, title: 'พัสดุอยู่ระหว่างการนำส่ง', time: '9 มิ.ย. 11:00', targetStatus: 'ที่ต้องได้รับ'),
              const SizedBox(height: 20),
              SizedBox(width: double.infinity, height: 50, child: ElevatedButton(onPressed: () => _showConfirmDialog(context), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF05A28), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), elevation: 0), child: const Text('ยืนยันการจัดส่ง', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)))),
              const SizedBox(height: 20),
            ],
            if (status == OrderStatus.preparing || status == OrderStatus.printing) ...[
              _buildStatusBlueBox(context, title: 'กำลังเตรียมพัสดุ', time: '9 มิ.ย. 10:00', targetStatus: 'เตรียมจัดส่ง'),
              const SizedBox(height: 40),
            ],
            if (status == OrderStatus.returned) ...[
              _buildStatusBlueBox(context, title: 'คืนสินค้า', time: '9 มิ.ย. 11:00', targetStatus: 'คืนสินค้า'),
              const SizedBox(height: 40),
            ]
          ],
        ),
      ),
    );
  }

  // --- Helper Methods ---
  _StatusConfig _getStatusInfo(OrderStatus status) {
    const kOrange = Color(0xFFF05A28);
    const kGreen = Color(0xFF28C668);
    const kRed = Color(0xFFFF3B30);
    const kPeach = Color(0xFFFDCB9E);

    Widget icon(IconData data) => Icon(data, color: Colors.white, size: 18);
    Widget truckIcon() => Image.asset('assets/icons/truck.png', width: 18, height: 18, color: Colors.white, errorBuilder: (c,e,s)=>const Icon(Icons.local_shipping, color: Colors.white, size: 18));
    Widget returnIcon() => Image.asset('assets/icons/cube.png', width: 18, height: 18, color: Colors.white, errorBuilder: (c,e,s)=>const Icon(Icons.inventory_2, color: Colors.white, size: 18));

    switch (status) {
      case OrderStatus.waitingPayment:
        return _StatusConfig('รอชำระ', 1, kOrange, const Icon(Icons.access_time_filled, color: Colors.white, size: 18));
      case OrderStatus.printing:
        return _StatusConfig('สั่งพิมพ์', 2, kOrange, truckIcon());
      case OrderStatus.preparing:
        return _StatusConfig('เตรียมจัดส่ง', 2, kOrange, truckIcon());
      case OrderStatus.shipping:
        return _StatusConfig('ที่ต้องได้รับ', 3, kOrange, truckIcon());
      case OrderStatus.completed:
        return _StatusConfig('สำเร็จ', 4, kGreen, icon(Icons.check));
      case OrderStatus.returned:
        return _StatusConfig('คืนสินค้า', 4, kPeach, returnIcon());
      case OrderStatus.cancelled:
        return _StatusConfig('ยกเลิก', 4, kRed, Image.asset('assets/icons/bag-cross.png', width: 18, color: Colors.white, errorBuilder: (c,e,s)=>icon(Icons.lock)));
    }
  }

  Widget _buildDetailProgressBar(_StatusConfig config) {
    return LayoutBuilder(builder: (context, constraints) {
      double width = constraints.maxWidth;
      double iconSize = 30.0;
      double segmentWidth = (width - iconSize) / 3;
      double iconLeftPos = (config.barCount - 1) * segmentWidth;
      if (iconLeftPos < 0) iconLeftPos = 0;
      if (iconLeftPos > width - iconSize) iconLeftPos = width - iconSize;

      return Stack(alignment: Alignment.centerLeft, children: [
        Container(margin: EdgeInsets.only(left: 2, right: iconSize / 2), height: 6, width: double.infinity, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(3))),
        Container(margin: const EdgeInsets.only(left: 2), height: 6, width: iconLeftPos + (iconSize / 2), decoration: BoxDecoration(color: config.color, borderRadius: BorderRadius.circular(3))),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: List.generate(4, (index) { if (index == 3) return const SizedBox.shrink(); return Container(margin: EdgeInsets.only(left: segmentWidth), width: 2, height: 6, color: Colors.white); })),
        Positioned(left: iconLeftPos, child: Container(width: iconSize, height: iconSize, decoration: BoxDecoration(color: config.color, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2), boxShadow: [BoxShadow(color: config.color.withOpacity(0.4), blurRadius: 4, offset: const Offset(0, 2))]), child: Center(child: config.iconWidget))),
      ]);
    });
  }

  Widget _buildStatusBlueBox(BuildContext context, {required String title, required String time, required String targetStatus}) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TrackingTimelinePage(statusType: targetStatus))),
      child: Container(width: double.infinity, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16), decoration: BoxDecoration(color: const Color(0xFF59A5B3), borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: const Color(0xFF59A5B3).withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))]), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)), const SizedBox(height: 4), Text(time, style: const TextStyle(color: Colors.white70, fontSize: 13))]), const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16)])),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(label, style: const TextStyle(color: Colors.white70, fontSize: 14)), Text(value, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500))]);
  }

  void _showConfirmDialog(BuildContext context) {
    showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent, builder: (context) => Container(decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(16))), padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 20, right: 20, top: 10), child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [Center(child: Container(width: 40, height: 4, margin: const EdgeInsets.only(bottom: 20), decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)))), Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('ยืนยันการจัดส่ง', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), IconButton(icon: const Icon(Icons.close, color: Colors.grey), onPressed: () => Navigator.pop(context))]), const SizedBox(height: 10), RichText(text: const TextSpan(text: 'แนบไฟล์หลักฐาน ', style: TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.w600), children: [TextSpan(text: '*', style: TextStyle(color: Colors.red))])), const Text('อัปโหลดรูปภาพ (.png, .jpg)', style: TextStyle(color: Colors.grey, fontSize: 12)), const SizedBox(height: 10), GestureDetector(onTap: () {}, child: CustomPaint(painter: _DashedRectPainter(color: Colors.grey, strokeWidth: 1.0, gap: 5.0), child: Container(height: 100, width: double.infinity, alignment: Alignment.center, child: RichText(textAlign: TextAlign.center, text: TextSpan(text: 'เปิดกล้องหรือ ', style: TextStyle(color: Colors.grey[600], fontSize: 14), children: const [TextSpan(text: 'เลือกจากไฟล์ที่มี', style: TextStyle(color: Colors.blue))]))))), const SizedBox(height: 20), TextField(maxLines: 4, decoration: InputDecoration(hintText: 'คำติชมเพิ่มเติม', hintStyle: TextStyle(color: Colors.grey[400]), contentPadding: const EdgeInsets.all(12), border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[300]!)))), const SizedBox(height: 20), SizedBox(width: double.infinity, height: 50, child: ElevatedButton(onPressed: () => Navigator.pop(context), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF05A28), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)), elevation: 0), child: const Text('ยืนยัน', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)))), const SizedBox(height: 30)]))));
  }
}

// ==============================================================================
// 3. PAGE: หน้า Timeline สถานะสินค้า
// ==============================================================================
class TrackingTimelinePage extends StatelessWidget {
  final String statusType;
  const TrackingTimelinePage({super.key, this.statusType = 'ที่ต้องได้รับ'});

  @override
  Widget build(BuildContext context) {
    List<Widget> timelineItems = [];
    if (statusType == 'เตรียมจัดส่ง') {
      timelineItems = [
        _buildTimelineItem(date: '9 มิ.ย.', time: '10:00', status: 'กำลังเตรียมพัสดุ', isFirst: true, isActive: true),
        _buildTimelineItem(date: '9 มิ.ย.', time: '09:00', status: 'ยืนยันคำสั่งซื้อ', isFirst: false, isLast: true),
      ];
    } else if (statusType == 'คืนสินค้า') {
      timelineItems = [
        _buildTimelineItem(date: '10 มิ.ย.', time: '14:00', status: 'คืนสินค้าสำเร็จ', isFirst: true, isActive: true),
        _buildTimelineItem(date: '9 มิ.ย.', time: '11:00', status: 'ร้านค้าได้รับสินค้าคืน', isFirst: false),
        _buildTimelineItem(date: '8 มิ.ย.', time: '09:00', status: 'ส่งคำขอคืนสินค้า', isFirst: false, isLast: true),
      ];
    } else {
      timelineItems = [
        _buildTimelineItem(date: '9 มิ.ย.', time: '11:00', status: 'พัสดุอยู่ระหว่างการนำส่ง', isFirst: true, isActive: true),
        _buildTimelineItem(date: '8 มิ.ย.', time: '15:30', status: 'พัสดุถึงศูนย์คัดแยก', isFirst: false),
        _buildTimelineItem(date: '8 มิ.ย.', time: '10:00', status: 'บริษัทขนส่งเข้ารับพัสดุ', isFirst: false),
        _buildTimelineItem(date: '7 มิ.ย.', time: '09:00', status: 'ยืนยันคำสั่งซื้อ', isFirst: false, isLast: true),
      ];
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0, leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black87), onPressed: () => Navigator.pop(context)), title: const Text('สถานะสินค้า', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold))),
      body: SingleChildScrollView(child: Column(children: [Container(padding: const EdgeInsets.all(20), decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE)))), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Container(width: 60, height: 60, decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(4), image: const DecorationImage(image: AssetImage('assets/images/album.png'), fit: BoxFit.cover))), const SizedBox(width: 15), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('อัลบั้มสำหรับใส่รูปครอบครัว', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)), const SizedBox(height: 4), Text('สีส้ม   X1', style: TextStyle(color: Colors.grey[400], fontSize: 14))])), const Text('฿ 599', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))])), Padding(padding: const EdgeInsets.all(20.0), child: Column(children: timelineItems))])),
    );
  }

  Widget _buildTimelineItem({required String date, required String time, required String status, bool isFirst = false, bool isLast = false, bool isActive = false}) {
    return IntrinsicHeight(child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [SizedBox(width: 50, child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [Text(date, style: TextStyle(color: Colors.grey[600], fontSize: 12)), Text(time, style: TextStyle(color: Colors.grey[400], fontSize: 12))])), const SizedBox(width: 10), Column(children: [Container(width: 2, height: 5, color: isFirst ? Colors.transparent : Colors.grey[300]), Container(width: 12, height: 12, decoration: BoxDecoration(color: isActive ? const Color(0xFF28C668) : Colors.grey[300], shape: BoxShape.circle)), Expanded(child: Container(width: 2, color: isLast ? Colors.transparent : Colors.grey[300]))]), const SizedBox(width: 15), Expanded(child: Padding(padding: const EdgeInsets.only(bottom: 30), child: Text(status, style: TextStyle(color: isActive ? const Color(0xFF28C668) : Colors.grey[500], fontSize: 14, fontWeight: isActive ? FontWeight.w500 : FontWeight.normal))))]));
  }
}

// ==============================================================================
// 4. SHARED WIDGETS
// ==============================================================================

class _HeaderBanner extends StatelessWidget {
  const _HeaderBanner();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset('assets/images/bannerOrder.png', width: double.infinity, fit: BoxFit.fitWidth),
        Positioned.fill(child: Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black.withOpacity(0.7)])))),
      ],
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final String title;
  final String statusText;
  final int barCount;
  final int totalBars;
  final Color mainColor;
  final Widget icon; 
  final bool isCompleted;
  final Color? overrideIconBgColor;
  final bool isGift;
  final VoidCallback? onTap;

  const _HistoryCard({
    required this.title,
    required this.statusText,
    required this.barCount,
    this.totalBars = 4,
    required this.mainColor,
    required this.icon,
    this.isCompleted = false,
    this.overrideIconBgColor,
    this.isGift = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFEEEEEE)), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))]),
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Row(children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)), if (isGift) ...[const SizedBox(width: 8), Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: const Color(0xFFFFF0EB), borderRadius: BorderRadius.circular(4)), child: Row(children: [Image.asset('assets/icons/gift.png', width: 14, height: 14, color: const Color(0xFFF05A28), errorBuilder: (c,e,s)=>const Icon(Icons.card_giftcard, size: 14, color: Color(0xFFF05A28))), const SizedBox(width: 4), const Text('ของขวัญ', style: TextStyle(color: Color(0xFFF05A28), fontSize: 12, fontWeight: FontWeight.bold))]))]]),
              Container(width: 32, height: 32, decoration: BoxDecoration(color: const Color(0xFF5B9DA9), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.arrow_forward, color: Colors.white, size: 18))
            ]),
            const SizedBox(height: 12),
            Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
              SizedBox(width: 90, height: 80, child: Stack(alignment: Alignment.center, children: [Positioned(left: 0, top: 5, child: Transform.rotate(angle: 0.10, child: ClipRRect(borderRadius: BorderRadius.circular(8), child: Opacity(opacity: 0.8, child: Image.asset('assets/images/order2.png', width: 70, height: 70, fit: BoxFit.cover, errorBuilder: (c,e,s)=>Container(width: 70, height: 70, color: Colors.grey[300])))))), Positioned(right: 0, bottom: 0, child: Transform.rotate(angle: -0.10, child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 5, offset: const Offset(-2, 4))]), child: ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.asset('assets/images/order1.png', width: 70, height: 70, fit: BoxFit.cover, errorBuilder: (c,e,s)=>Container(width: 70, height: 70, color: Colors.grey[400]))))))])),
              const SizedBox(width: 16),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(statusText, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)), const SizedBox(height: 8), SizedBox(height: 40, child: LayoutBuilder(builder: (context, constraints) { double totalWidth = constraints.maxWidth; double iconSize = 36.0; double rightPadding = 20.0; double barAreaWidth = totalWidth - rightPadding; double singleBarWidth = barAreaWidth / totalBars; double iconLeftPos = (singleBarWidth * barCount) - (iconSize / 2); if (barCount == totalBars) { iconLeftPos = barAreaWidth - (iconSize / 2); } else if (barCount == 1) { iconLeftPos = singleBarWidth - (iconSize / 2); } return Stack(alignment: Alignment.centerLeft, children: [Padding(padding: EdgeInsets.only(right: rightPadding), child: Row(children: List.generate(totalBars, (index) { bool isActive = index < barCount; return Expanded(child: Container(margin: const EdgeInsets.only(right: 2), height: 16, decoration: BoxDecoration(color: isActive ? mainColor : const Color(0xFFE0E0E0), borderRadius: BorderRadius.circular(4)))); }))), Positioned(left: iconLeftPos, child: Container(width: iconSize, height: iconSize, decoration: BoxDecoration(color: overrideIconBgColor ?? mainColor, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2.5), boxShadow: [BoxShadow(color: (overrideIconBgColor ?? mainColor).withOpacity(0.4), blurRadius: 4, offset: const Offset(0, 3))]), child: Center(child: icon)))]); }))]))
            ])
          ],
        ),
      ),
    );
  }
}

class _StatusConfig {
  final String label;
  final int barCount;
  final Color color;
  final Widget iconWidget;
  _StatusConfig(this.label, this.barCount, this.color, this.iconWidget);
}

class _DashedRectPainter extends CustomPainter {
  final double strokeWidth; final Color color; final double gap;
  _DashedRectPainter({this.strokeWidth = 1.0, this.color = Colors.grey, this.gap = 5.0});
  @override void paint(Canvas canvas, Size size) {
    Paint dashedPaint = Paint()..color = color..strokeWidth = strokeWidth..style = PaintingStyle.stroke;
    Path path = Path();
    path.addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    Path dashPath = Path();
    double distance = 0.0;
    for (var pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        dashPath.addPath(pathMetric.extractPath(distance, distance + 5), Offset.zero);
        distance += 5 + gap;
      }
    }
    canvas.drawPath(dashPath, dashedPaint);
  }
  @override bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}