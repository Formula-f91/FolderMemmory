import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // ✅ เหลือเพียง Controller เดียวสำหรับ Username
  final _usernameController = TextEditingController();

  File? _selectedImage;
  bool _isLoading = false;
  final User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    // ดึงชื่อเดิมมาแสดง
    _usernameController.text = currentUser?.displayName ?? '';
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  // ฟังก์ชันเลือกรูปจากแกลลอรี่
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50, // บีบอัดไฟล์เพื่อให้โหลดไวขึ้น
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  // ฟังก์ชันอัปเดตข้อมูล
  Future<void> _updateProfile() async {
    FocusScope.of(context).unfocus();

    if (_usernameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('กรุณากรอกชื่อผู้ใช้งาน')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      // ✅ ดึง User ปัจจุบันใหม่ทุกครั้งที่กดปุ่ม เพื่อความแม่นยำ
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("ไม่พบข้อมูลผู้ใช้งาน");

      String? newPhotoUrl;

      // 1. จัดการเรื่องรูปภาพ
      if (_selectedImage != null) {
        debugPrint('➡️ กำลังอัปโหลดรูปภาพ...');
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('profile_images')
            .child('${user.uid}.jpg');

        // เริ่มการอัปโหลด
        await storageRef.putFile(_selectedImage!);
        newPhotoUrl = await storageRef.getDownloadURL();
        debugPrint('➡️ อัปโหลดรูปสำเร็จ URL: $newPhotoUrl');
      }

      // 2. อัปเดตข้อมูล Profile
      debugPrint('➡️ กำลังบันทึกชื่อผู้ใช้...');
      await user.updateDisplayName(_usernameController.text.trim());

      if (newPhotoUrl != null) {
        await user.updatePhotoURL(newPhotoUrl);
      }

      // 3. ✨ จุดสำคัญ: ต้อง Reload และเรียก currentUser ใหม่เพื่อให้ค่าในแอปเปลี่ยนจริง
      await user.reload();
      debugPrint('➡️ รีโหลดข้อมูลสำเร็จ');

      if (mounted) {
        setState(() => _isLoading = false); // ปิดโหลดก่อน Pop
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('อัปเดตโปรไฟล์สำเร็จ!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(
          context,
          true,
        ); // ส่งค่า true กลับไปบอกหน้าเดิมว่ามีการแก้ไข
      }
    } catch (e) {
      debugPrint('❌ Error: $e');
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('เกิดข้อผิดพลาด: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFFF98B75);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                // 🔹 ส่วนหัว Header
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 200,
                      decoration: const BoxDecoration(color: primaryColor),
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                ),
                                onPressed: () => Navigator.pop(context),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Text(
                                  'Edit Profile',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 48,
                              ), // แทนที่ปุ่มแชร์เพื่อให้ Text อยู่กลาง
                            ],
                          ),
                        ),
                      ),
                    ),

                    // 🔹 รูปโปรไฟล์
                    Positioned(
                      bottom: -50,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 4),
                            color: Colors.grey.shade300,
                            image:
                                _selectedImage != null
                                    ? DecorationImage(
                                      image: FileImage(_selectedImage!),
                                      fit: BoxFit.cover,
                                    )
                                    : (currentUser?.photoURL != null
                                        ? DecorationImage(
                                          image: NetworkImage(
                                            currentUser!.photoURL!,
                                          ),
                                          fit: BoxFit.cover,
                                        )
                                        : const DecorationImage(
                                          image: AssetImage(
                                            'assets/images/userpic.png',
                                          ),
                                          fit: BoxFit.cover,
                                        )),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 55),

                GestureDetector(
                  onTap: _pickImage,
                  child: const Text(
                    'Change Picture',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // 🔹 ฟอร์มกรอกชื่อ
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Username',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          hintText: 'Enter Username',
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade400),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: primaryColor,
                              width: 2,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 50),

                      // 🔹 ปุ่ม Update
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1A201D),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: _isLoading ? null : _updateProfile,
                          child: const Text(
                            'Update',
                            style: TextStyle(
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
          ),

          // หน้าจอ Loading
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.4),
              child: const Center(
                child: CircularProgressIndicator(color: primaryColor),
              ),
            ),
        ],
      ),
    );
  }
}
