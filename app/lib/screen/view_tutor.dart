import 'dart:ffi';

import 'package:app/Component/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ViewTutor extends StatefulWidget {
  final String id; // Thêm thuộc tính id
  final String postId; // Thêm thuộc tính id
  final Map<String, dynamic> tutorData;

  const ViewTutor(
      {required this.id,
      required this.postId,
      required this.tutorData,
      Key? key})
      : super(key: key);

  @override
  State<ViewTutor> createState() => _ViewTutorState();
}

class _ViewTutorState extends State<ViewTutor> {
  void getDataAppointment(String tutorId) {
    final postId = widget.postId;
    final dataAppointment = {
      "tutorId": tutorId,
      "postId": postId,
    };
    context.go(
      '/home/create-appointment',
      extra: dataAppointment,
    );
  }

  String getGenderString(int gender) {
    switch (gender) {
      case 0:
        return 'Other';
      case 1:
        return 'Male';
      case 2:
        return 'Female';
      default:
        return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> qualifications = widget.tutorData['qualifications'];
    List<String> qualificationNames = qualifications
        .map<String>((qualification) => qualification['qualificationName'])
        .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('View Tutor'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(widget.tutorData['avatarUrl'] ??
                      'https://i.pinimg.com/736x/95/e8/6b/95e86bcc378d6f9b32480833f73c485b.jpg'), // Thay đổi đường dẫn tới ảnh đại diện của người dùng
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: Text(
                  widget.tutorData['fullname']!, // Tên của người dùng
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 8),
              Center(
                child: Text(
                  widget.tutorData['email']!, // Email của người dùng
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(height: 24),
              Text(
                'Info Tutor',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Phone: ${widget.tutorData['phone']!}', // Số điện thoại của người dùng
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Address: ${widget.tutorData['address']!}', // Địa chỉ của người dùng
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Gender: ${getGenderString(widget.tutorData['gender']!)}', // Giới tính của người dùng
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 24),
              Text(
                'Qualiffication',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: qualifications.isEmpty
                    ? [
                        Text(
                          'No qualification',
                          style: TextStyle(fontSize: 16),
                        )
                      ]
                    : qualificationNames
                        .map((qualification) => Chip(
                              label: Text(qualification),
                            ))
                        .toList(),
              ),
              SizedBox(height: 24),
              Text(
                'Create Appoitment',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    getDataAppointment(widget.tutorData['tutorId']);
                    // Xử lý sự kiện khi người dùng nhấn vào nút "Book Appointment"
                  },
                  child: Text('Book Appointment'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
