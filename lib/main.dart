import 'package:flutter/material.dart';
import 'package:wememmory/home/firstPage.dart';
import 'package:wememmory/login/loginPage.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wememory', // ตั้งชื่อแอป
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // ✅ ส่วนนี้จะทำให้ Text ปกติทั้งแอปเป็น Prompt
        textTheme: GoogleFonts.promptTextTheme(
          Theme.of(context).textTheme,
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const LoginPage(), // หรือ FirstPage() ตาม Flow ของคุณ
    );
  }
}

