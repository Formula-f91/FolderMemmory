import 'package:flutter/material.dart';
import 'package:wememmory/shop/paymentSuccessPage.dart';
import 'package:wememmory/shop/addCardPage.dart';
import 'package:wememmory/shop/addressSelectionPage.dart';
import 'package:wememmory/shop/couponPage.dart';
import 'package:wememmory/shop/address_model.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  // 2. ตัวแปรเก็บที่อยู่
  AddressInfo? _deliveryAddress; 

  int _selectedMethod = 0; 
  String? _expandedSection;
  int _selectedBankIndex = -1;

  final List<Map<String, dynamic>> _bankOptions = [
    {'name': 'Krungthai NEXT', 'icon': 'assets/icons/kungthai.png'},
    {'name': 'Krungsri Mobile App', 'icon': 'assets/icons/kung.png'},
    {'name': 'K PLUS', 'icon': 'assets/icons/kbank.png'},
    {'name': 'SCB Easy', 'icon': 'assets/icons/theb.png'},
    {'name': 'Bangkok Bank Mobile Banking', 'icon': 'assets/icons/bangkkok.png'},
  ];

  @override
  void initState() {
    super.initState();
    _deliveryAddress = AddressInfo(
       name: 'ชื่อ - นามสกุล',
       phone: '098 - 765 - 4321',
       province: 'กรุงเทพมหานคร',
       district: 'ลาดกระบัง',
       subDistrict: 'ลาดกระบัง',
       detail: 'หมู่บ้าน สุวรรณภูมิทาวน์ซอย ลาดกระบัง 54/3'
    );
  }

  Future<void> _selectAddress() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AddressSelectionPage(selected: _deliveryAddress),
      ),
    );

    if (result != null && result is AddressInfo) {
      setState(() {
        _deliveryAddress = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 0,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('สั่งซื้อ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey.shade200, height: 1),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. ที่อยู่ ---
            const Text('ที่อยู่', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            InkWell(
              onTap: _selectAddress,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _deliveryAddress == null
                          ? const Text('กรุณาเลือกที่อยู่จัดส่ง', style: TextStyle(color: Colors.red))
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${_deliveryAddress!.name} | ${_deliveryAddress!.phone}',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${_deliveryAddress!.detail} ${_deliveryAddress!.subDistrict} ${_deliveryAddress!.district} ${_deliveryAddress!.province} ',
                                  style: TextStyle(color: Colors.grey.shade700, height: 1.5, fontSize: 13),
                                ),
                              ],
                            ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.chevron_right, color: Colors.grey),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            const Divider(thickness: 1, height: 1, color: Color(0xFFEEEEEE)),
            const SizedBox(height: 24),

            // --- 2. รายละเอียดสินค้า ---
            const Text('รายละเอียดสินค้า', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('อัลบั้มรูป', style: TextStyle(fontSize: 15)),
                Text('฿ 599', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              ],
            ),

            const SizedBox(height: 24),
            const Divider(thickness: 1, height: 1, color: Color(0xFFEEEEEE)),
            const SizedBox(height: 24),

            // --- 3. ช่องทางชำระเงิน ---
            const Text('ช่องทางชำระเงิน', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 16),

            // QR พร้อมเพย์
            InkWell(
              onTap: () => setState(() {
                _selectedMethod = 0;
                _expandedSection = null;
              }),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Image.asset('assets/icons/qrPayment.png', width: 28, height: 28, errorBuilder: (_,__,___) => const Icon(Icons.qr_code_2, size: 28, color: Color(0xFF1A237E))),
                    const SizedBox(width: 12),
                    const Expanded(child: Text('QR พร้อมเพย์', style: TextStyle(fontSize: 15))),
                    _buildRadio(_selectedMethod == 0),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Mobile Banking
            _buildDropdownSection(
              title: 'Mobile Banking',
              // ✅ แก้ไข: ส่ง path รูปภาพ (String)
              iconAsset: 'assets/icons/bank.png', 
              isExpanded: _expandedSection == 'mobile',
              onTap: () => setState(() {
                if (_expandedSection == 'mobile') {
                  _expandedSection = null;
                } else {
                  _expandedSection = 'mobile';
                  _selectedMethod = 1;
                }
              }),
              content: Column(
                children: List.generate(_bankOptions.length, (index) {
                  return InkWell(
                    onTap: () => setState(() {
                      _selectedBankIndex = index;
                      _selectedMethod = 1;
                    }),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              _bankOptions[index]['icon'],
                              width: 32,
                              height: 32,
                              errorBuilder: (context, error, stackTrace) => Container(width: 32, height: 32, color: Colors.grey.shade300),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(_bankOptions[index]['name'], style: const TextStyle(fontSize: 14)),
                          ),
                          _buildRadio(_selectedBankIndex == index && _selectedMethod == 1),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 8),

            // บัตรเครดิต
            _buildDropdownSection(
              title: 'บัตรเครดิต/บัตรเดบิต',
              
              // ✅ แก้ไข: เปลี่ยนจาก iconData เป็น iconAsset
              iconAsset: 'assets/icons/card.png', 
              
              isExpanded: _expandedSection == 'card',
              onTap: () => setState(() {
                if (_expandedSection == 'card') {
                  _expandedSection = null;
                } else {
                  _expandedSection = 'card';
                  _selectedMethod = 2;
                }
              }),
              content: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AddCardPage()));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Icon(Icons.add, color: Colors.grey, size: 20),
                        ),
                        const SizedBox(width: 12),
                        const Text('เพิ่มบัตรใหม่', style: TextStyle(color: Colors.grey, fontSize: 14)),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),
            const Divider(thickness: 1, height: 1, color: Color(0xFFEEEEEE)),
            const SizedBox(height: 24),

            // --- 4. ส่วนลด ---
            Row(
              children: [
                const Text('ส่วนลด', style: TextStyle(fontSize: 15)),
                const Spacer(),
                SizedBox(
                  height: 36,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CouponSelectionPage())),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF7043),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    child: const Text('ใช้ส่วนลด', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
      
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(20),
        child: SizedBox(
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              if (_deliveryAddress == null) {
                 ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('กรุณาเลือกที่อยู่จัดส่ง')));
                 return;
              }
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PaymentSuccessPage()));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF7043),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              elevation: 0,
            ),
            child: const Text(
              'ชำระเงิน',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  // ✅ แก้ไข Helper Widget: ให้รองรับทั้ง IconData และ Image Asset
  Widget _buildDropdownSection({
    required String title,
    IconData? iconData, // ทำให้เป็น optional
    String? iconAsset,  // เพิ่ม optional สำหรับ path รูปภาพ
    required bool isExpanded,
    required VoidCallback onTap,
    required Widget content,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                // แสดงผลตามสิ่งที่ส่งมา
                if (iconAsset != null)
                   Image.asset(iconAsset, width: 26, height: 26)
                else if (iconData != null)
                   Icon(iconData, color: const Color(0xFF607D8B), size: 26)
                else
                   const SizedBox(width: 26), // กรณีไม่ส่งอะไรมาเลย
                   
                const SizedBox(width: 12),
                Expanded(child: Text(title, style: const TextStyle(fontSize: 15))),
                Icon(
                  isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: Colors.grey.shade400,
                ),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Container(
            width: double.infinity,
            color: const Color(0xFFF8F9FA),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: content,
          ),
          crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 200),
        ),
      ],
    );
  }

  Widget _buildRadio(bool isSelected) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? const Color(0xFFFF8A3D) : Colors.grey.shade400,
          width: 1.5,
        ),
      ),
      child: isSelected
          ? Center(
              child: Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: Color(0xFFFF8A3D),
                  shape: BoxShape.circle,
                ),
              ),
            )
          : null,
    );
  }
}