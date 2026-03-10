import 'package:flutter/material.dart';
import 'package:wememmory/constants.dart';

class JourneyPage extends StatelessWidget {
  const JourneyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(backgroundColor: kBackgroundColor, elevation: 0, title: Text('Journey Page')),
      body: SafeArea(child: Column(children: [Text('Journey Page')])),
    );
  }
}
