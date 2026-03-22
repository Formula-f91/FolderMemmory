import 'package:flutter/material.dart';

class FAQPage extends StatelessWidget {
  const FAQPage({super.key});

  @override
  Widget build(BuildContext context) {
    final questions = [
      'คำถามที่พบบ่อย',
      'คำถามที่พบบ่อย',
      'คำถามที่พบบ่อย',
      'คำถามที่พบบ่อย',
      'การชำระเงิน',
      'คำถามที่พบบ่อย',
      'การซื้อสินค้า',
    ];

    return Scaffold(
      body: Column(
        children: [
          Container(
            color: const Color(0xFFF29C64),
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: ListTile(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              title: const Text('คำถามที่พบบ่อย', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemBuilder: (_, i) => ListTile(title: Text(questions[i])),
                separatorBuilder: (_, __) => const Divider(),
                itemCount: questions.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
