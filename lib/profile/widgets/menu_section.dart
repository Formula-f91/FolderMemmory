import 'package:flutter/material.dart';

class MenuSection extends StatelessWidget {
  const MenuSection({super.key, required this.items, this.onItemTap});
  final List<String> items;
  final Function(String item, int index)? onItemTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias, // เพิ่มเพื่อให้ ripple effect ไม่เกิน border radius
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            MenuItem(title: items[i], onTap: () => onItemTap?.call(items[i], i)),
            if (i != items.length - 1) const Divider(height: 1, thickness: 1, color: Color(0xFFEFEFEF)),
          ],
        ],
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  const MenuItem({super.key, required this.title, this.onTap});
  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontSize: 15, color: Color(0xFF5F5F5F), fontWeight: FontWeight.w500)),
            const Icon(Icons.chevron_right, color: Color(0xFFB7B7B7)),
          ],
        ),
      ),
    );
  }
}
