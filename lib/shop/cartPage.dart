import 'package:flutter/material.dart';
import 'package:wememmory/shop/paymentPage.dart';

const Color kPrimaryColor = Color(0xFFED7D31);
const Color kBackgroundColor = Color(0xFFF5F5F5);

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      
      // 1. App Bar
      appBar: AppBar(
        backgroundColor: Colors.white, 
        elevation: 0.5,
        centerTitle: false,
        title: const Text(
          'ตะกร้าสินค้า',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 8.0),
        child: Column(
          children: [
            _buildSelectAllSection(),
            
            const Divider(height: 1, color: Colors.grey),
            
            // รายการสินค้า
            _buildCartItem(
              imageUrl: 'assets/images/Rectangle2.png', // ต้องเปลี่ยนเป็น path รูปจริง
              productName: 'อัลบั้มรูป',
              price: 599,
              quantity: 1,
            ),
            
            
          ],
        ),
      ),
      
      // 3. Bottom Bar/ปุ่มสั่งซื้อสินค้า
      bottomNavigationBar: _buildBottomCheckoutBar(context),
    );
  }

  // --- Widget Builders ---

  Widget _buildSelectAllSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          Radio(
            value: 1,
            groupValue: 1,
            onChanged: (val) {},
            activeColor: kPrimaryColor,
          ),
          const Text(
            'เลือกทั้งหมด',
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem({
    required String imageUrl,
    required String productName,
    required double price,
    required int quantity,
  }) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Radio Button Placeholder
          Radio(
            value: 1,
            groupValue: 1, 
            onChanged: (val) {},
            activeColor: kPrimaryColor,
          ),
          
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(4),
              image: const DecorationImage(
                // ⚠️ ต้องเปลี่ยนเป็นรูปภาพจริงของคุณ
                image: AssetImage('assets/images/Rectangle2.png'), 
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          const SizedBox(width: 12),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productName,
                  style: const TextStyle(
                    fontSize: 16, 
                    fontWeight: FontWeight.normal,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '฿ ${price.toStringAsFixed(0)}', // แสดงราคา
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor,
                  ),
                ),
              ],
            ),
          ),
          
          // ตัวควบคุมจำนวนสินค้า
          _buildQuantityControl(quantity),
        ],
      ),
    );
  }

  Widget _buildQuantityControl(int quantity) {
    return Container(
      decoration: BoxDecoration(
        color: kBackgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ปุ่มลบ (-)
          InkWell(
            onTap: () {
              // Logic ลดจำนวน
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Icon(Icons.remove, size: 20, color: Colors.black54),
            ),
          ),
          
          // จำนวน
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            decoration: const BoxDecoration(
              color: Colors.white, // พื้นหลังของช่องตัวเลขเป็นสีขาว
            ),
            child: Text(
              quantity.toString(),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          
          // ปุ่มบวก (+)
          InkWell(
            onTap: () {
              // Logic เพิ่มจำนวน
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Icon(Icons.add, size: 20, color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomCheckoutBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 20, left: 16, right: 16, top: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.black12, width: 0.5)),
      ),
      child: SafeArea(
        top: false, // ไม่ให้ SafeArea กระทบด้านบน
        child: SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              // 💡 โค้ดที่เพิ่ม/ปรับแก้: นำทางไปยัง PaymentPage
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const PaymentPage()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryColor, 
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: const Text(
              'สั่งซื้อสินค้า',
              style: TextStyle(
                fontSize: 18, 
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}