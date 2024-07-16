import 'dart:convert';

import 'package:app/Component/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Appointment extends StatefulWidget {
  const Appointment({super.key});

  @override
  State<Appointment> createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Navigate to different pages based on the selected index
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/home/appointment');
        break;
      case 2:
        context.go('/home/user-profile');
        break;
    }
  }

  Future<void> FetchAppointmentList() async {
    final prefs = await SharedPreferences.getInstance();
    final user = prefs.getString('userLogin');
    if (user != null) {
      final Map<String, dynamic> userMap = jsonDecode(user);
      final userId = userMap['userId'];
      //final url =
          // 'https://10.0.2.2:7194/AppointmentFeedback/appointments/account/$userId';
      final url = 'https://mytutorlink.arisavinh.dev/AppointmentFeedback/appointments/account/$userId';
      final uri = Uri.parse(url);
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final dataAppointment = jsonDecode(response.body);
        setState(() {
          appointments = dataAppointment;
        });
        print(appointments);
      } else {
        print(response.statusCode);
      }
    }
  }

  void sortAppointments(String criteria) {
    setState(() {
      if (criteria == 'nearest') {
        appointments.sort((a, b) => DateTime.parse(a['appointmentTime'])
            .compareTo(DateTime.parse(b['appointmentTime'])));
      } else if (criteria == 'furthest') {
        appointments.sort((a, b) => DateTime.parse(b['appointmentTime'])
            .compareTo(DateTime.parse(a['appointmentTime'])));
      } else if (criteria == 'pending') {
        appointments.sort((a, b) => (a['status'] == 0 ? -1 : 1)
            .compareTo(b['status'] == 0 ? -1 : 1));
      } else if (criteria == 'approve') {
        appointments.sort((a, b) => (a['status'] == 1 ? -1 : 1)
            .compareTo(b['status'] == 1 ? -1 : 1));
      } else if (criteria == 'cancel') {
        appointments.sort((a, b) => (a['status'] == 2 ? -1 : 1)
            .compareTo(b['status'] == 2 ? -1 : 1));
      } else if (criteria == 'all') {
        FetchAppointmentList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    FetchAppointmentList();
  }

  String formatDate(String dateTime) {
    final DateTime parsedDate = DateTime.parse(dateTime);
    final DateFormat formatter = DateFormat('dd MMM yyyy, hh:mm a');
    return formatter.format(parsedDate);
  }

  // Danh sách mẫu các appointment
  List appointments = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text('Appointment'),
          actions: [
            PopupMenuButton<String>(
              onSelected: (String value) {
                // Hành động khi chọn một tùy chọn Sort
                sortAppointments(value);
              },
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem<String>(
                    value: 'all',
                    child: Text('Show all'),
                  ),
                  PopupMenuItem<String>(
                    value: 'nearest',
                    child: Text('Nearest appointment'),
                  ),
                  PopupMenuItem<String>(
                    value: 'furthest',
                    child: Text('Furthest appointment'),
                  ),
                  PopupMenuItem<String>(
                    value: 'pending',
                    child: Text('Appointment is pending'),
                  ),
                  PopupMenuItem<String>(
                    value: 'approve',
                    child: Text('Appoinment was approve'),
                  ),
                  PopupMenuItem<String>(
                    value: 'cancel',
                    child: Text('Appoinment was cancel'),
                  ),
                ];
              },
              icon: Icon(Icons.sort),
            ),
          ]),
      body: RefreshIndicator(
        onRefresh: FetchAppointmentList,
        child: ListView.builder(
          itemCount: appointments.length,
          itemBuilder: (context, index) {
            final appointment = appointments[index];
            final status = appointment['status'];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                            appointment['tutorAvatarUrl'] ??
                                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR4Y4d_9x8ebL0d0uGM776VrF1Ptwe7vyHDJA&s'),
                      ),
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(
                              appointment['tutorUsername'] ?? 'No data',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          status == 0
                              ? Icon(Icons.pending,
                                  size: 16, color: Colors.grey)
                              : status == 1
                                  ? Icon(Icons.check_circle,
                                      size: 16, color: Colors.green)
                                  : Icon(Icons.cancel,
                                      size: 16, color: Colors.red),
                        ],
                      ),
                      subtitle: Text(
                        formatDate(appointment['appointmentTime'] ?? ''),
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Address: ${appointment['address'] ?? ''}',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: CustomNavbar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
