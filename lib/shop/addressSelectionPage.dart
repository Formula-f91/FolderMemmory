import 'package:flutter/material.dart';
import 'package:wememmory/shop/address_model.dart';
import 'package:wememmory/shop/editAddressPage.dart'; 

class AddressSelectionPage extends StatefulWidget {
  final AddressInfo? selected;
  const AddressSelectionPage({super.key, this.selected});

  @override
  State<AddressSelectionPage> createState() => _AddressSelectionPageState();
}

class _AddressSelectionPageState extends State<AddressSelectionPage> {
  AddressInfo? _current;

  @override
  void initState() {
    super.initState();
    _current = widget.selected ?? (globalAddressList.isNotEmpty ? globalAddressList.first : null);
  }

  void _addNewAddress() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EditAddressPage(index: null)),
    );
    setState(() {}); 
  }

  void _editAddress(int index) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditAddressPage(index: index)),
    );
    setState(() {}); 
  }

  // ฟังก์ชันนี้สำคัญ: อัปเดต state และส่งค่ากลับทันที
  void _select(AddressInfo info) {
    setState(() => _current = info);
    Navigator.pop(context, info); // ส่งค่ากลับไปหน้า PaymentPage
  }

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFFFF8A3D);
    const grey = Color(0xFF9B9B9B);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('ที่อยู่', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      body: globalAddressList.isEmpty
          ? const Center(child: Text("ยังไม่มีที่อยู่ กรุณากดเพิ่ม"))
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
              itemCount: globalAddressList.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) {
                final item = globalAddressList[i];
                final isSelected = item == _current;
                
                return InkWell(
                  // --- แก้ไขจุดที่ 1: เรียก _select เมื่อกดที่กล่อง ---
                  onTap: () => _select(item), 
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: isSelected ? accent : Colors.grey.shade300, width: isSelected ? 1.5 : 1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Radio<AddressInfo>(
                          value: item,
                          groupValue: _current,
                          activeColor: accent,
                          // --- แก้ไขจุดที่ 2: เรียก _select เมื่อกดปุ่ม Radio ---
                          onChanged: (val) {
                            if (val != null) _select(val);
                          },
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${item.name}  ${item.phone}', style: const TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text(
                                '${item.detail} ${item.subDistrict} ${item.district} ${item.province}',
                                style: const TextStyle(color: grey, fontSize: 13),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          // ปุ่มแก้ไขไม่ต้องเลือก ให้ไปหน้า Edit อย่างเดียว ถูกแล้ว
                          onPressed: () => _editAddress(i),
                          child: const Text('แก้ไข', style: TextStyle(color: grey)),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: SizedBox(
          height: 48,
          child: ElevatedButton(
            onPressed: _addNewAddress,
            style: ElevatedButton.styleFrom(backgroundColor: accent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            child: const Text('เพิ่มที่อยู่', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }
}