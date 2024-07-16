import 'dart:convert';

import 'package:app/Component/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 2;
  Map<String, dynamic> profileInfo = {};

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

  @override
  void initState() {
    super.initState();
    GetUserProfile();
  }

  void _refreshProfile() {
    GetUserProfile();
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

  void logoutHandle(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('userLogin');

    // Show toast notification at the top of the screen
    Fluttertoast.showToast(
      msg: "Logout success",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 16.0,
    );

    // Navigate to login page
    context.go('/login');
  }

  Future<void> GetUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final user = prefs.getString('userLogin');
    if (user != null) {
      final Map<String, dynamic> userMap = jsonDecode(user);
      final userId = userMap['userId'];
      // final url = 'https://10.0.2.2:7194/Account/get/$userId';
      final url = 'https://mytutorlink.arisavinh.dev/Account/get/$userId';
      final uri = Uri.parse(url);
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final dataUserProfile = jsonDecode(response.body);
        setState(() {
          profileInfo = dataUserProfile;
        });
        print(profileInfo);
      } else {
        print(response.statusCode);
      }
    }
  }

  Future<void> GetUserById() async {
    final prefs = await SharedPreferences.getInstance();
    final user = prefs.getString('userLogin');
    if (user != null) {
      final Map<String, dynamic> userMap = jsonDecode(user);
      final userId = userMap['userId'];
      // final url = 'https://10.0.2.2:7194/Account/get/$userId';
      final url = 'https://mytutorlink.arisavinh.dev/Account/get/$userId';
      final uri = Uri.parse(url);
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final dataUserById = jsonDecode(response.body);
        print(dataUserById);
        context.go('/home/user-profile/update-profile', extra: {
          'dataUserById': dataUserById,
          'refreshProfile': _refreshProfile
        });
        //đưa dữ liệu datauserById hiển thị sẵn lên trang
      } else {
        print(response.statusCode);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Profile'),
        actions: [
          IconButton(
            onPressed: () {
              // Xử lý sự kiện khi người dùng nhấn vào biểu tượng sửa đổi
              GetUserById();
            },
            icon: Icon(Icons.edit),
          ),
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: profileInfo.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 70,
                      backgroundImage: NetworkImage(
                        profileInfo['avatarUrl'] ??
                            'https://i.pinimg.com/736x/95/e8/6b/95e86bcc378d6f9b32480833f73c485b.jpg', // URL của hình ảnh người dùng
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      profileInfo['fullname'], // Tên người dùng
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      profileInfo['email'], // Email người dùng
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 30),
                    Text(
                      'Thông tin cá nhân',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    DataTable(
                      columns: [
                        DataColumn(label: Text('Thuộc tính')),
                        DataColumn(label: Text('Giá trị')),
                      ],
                      rows: [
                        DataRow(cells: [
                          DataCell(Text('Tên người dùng')),
                          DataCell(Text(profileInfo['username'])),
                        ]),
                        DataRow(cells: [
                          DataCell(Text('Email')),
                          DataCell(Text(profileInfo['email'])),
                        ]),
                        DataRow(cells: [
                          DataCell(Text('Địa chỉ')),
                          DataCell(Text(profileInfo['address'])),
                        ]),
                        DataRow(cells: [
                          DataCell(Text('Giới tính')),
                          DataCell(
                              Text(getGenderString(profileInfo['gender']))),
                        ]),
                        // Thêm các dòng khác tương tự tại đây nếu cần
                      ],
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        // Xử lý sự kiện khi người dùng nhấn nút "Log out"
                        logoutHandle(context);
                      },
                      child: Text('Log out'),
                    ),
                  ],
                )
              : CircularProgressIndicator()),
      bottomNavigationBar: CustomNavbar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
