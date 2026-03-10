import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wememmory/login/loginPage.dart';
import 'package:wememmory/home/firstPage.dart';
import 'package:wememmory/login/username_page.dart'; // ✅ Import หน้าตั้งชื่อ

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xFFF4F6F8),
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFFE18253)),
            ),
          );
        }

        // ถ้ามี User ล็อกอินอยู่
        if (snapshot.hasData) {
          final user = snapshot.data!;

          // ✅ เช็คว่ามีชื่อผู้ใช้ (displayName) หรือยัง
          if (user.displayName == null || user.displayName!.isEmpty) {
            // ถ้ายังไม่มีชื่อ ให้ไปหน้า UsernamePage
            return const UsernamePage();
          } else {
            // ถ้ามีชื่อแล้ว เข้าแอปปกติ
            return const FirstPage();
          }
        }

        // ถ้ายังไม่ได้ล็อกอิน
        return const LoginPage();
      },
    );
  }
}
