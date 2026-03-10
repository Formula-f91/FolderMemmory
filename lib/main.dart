import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wememmory/Service_system/auth_service.dart';
import 'firebase_options.dart';
// นำเข้าไฟล์ AuthGate ที่เราเพิ่งสร้าง

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wememory',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.promptTextTheme(Theme.of(context).textTheme),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFE18253)),
      ),
      // ✅ ลบ routes และ initialRoute ทิ้งไปเลย แล้วใช้ home ชี้ไปที่ AuthGate แทน
      home: const AuthGate(),
    );
  }
}
