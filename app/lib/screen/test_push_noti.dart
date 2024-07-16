import 'package:app/Component/app_bar.dart';
import 'package:flutter/material.dart';

class PushNoti extends StatefulWidget {
  const PushNoti({super.key});
  

  @override
  State<PushNoti> createState() => _PushNotiState();
}

class _PushNotiState extends State<PushNoti> {
  String avatarUrl = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  CustomAppBar(avatarUrl: avatarUrl,),
      body: Center(
        child: Text(
          'Hello, world!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
