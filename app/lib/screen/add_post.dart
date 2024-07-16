import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:app/Component/app_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({super.key});

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _scheduleController = TextEditingController();
  final TextEditingController _preferredTimeController =
      TextEditingController();
  final TextEditingController _requestSkillController = TextEditingController();

  int _gender = 1;
  int _status = 1;
  int _mode = 1;

  @override
  void dispose() {
    _descriptionController.dispose();
    _locationController.dispose();
    _scheduleController.dispose();
    _preferredTimeController.dispose();
    _requestSkillController.dispose();
    super.dispose();
  }

  Future<void> AddPostPageRequest() async {
    if (_formKey.currentState!.validate()) {
      // Lấy giá trị từ các TextEditingController
      final data = {
        "description": _descriptionController.text,
        "location": _locationController.text,
        "schedule": _scheduleController.text,
        "preferredTime": _preferredTimeController.text,
        "mode": _status,
        "gender": _gender,
        "status": _status,
        "requestSkill": _requestSkillController.text,
        "createdDate": DateTime.now().toIso8601String()
      };
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');
      const url =
          // "https://10.0.2.2:7194/PostRequest/add-post-request";
      "https://mytutorlink.arisavinh.dev/PostRequest/add-post-request";

      final uri = Uri.parse(url);
      final response = await http.post(uri, body: jsonEncode(data), headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $token',
      });
      if (response.statusCode == 200) {
        //sẽ xuất ra thông báo dialog thêm thành công
        Fluttertoast.showToast(
          msg: "Add post successful",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        context.go("/home");
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
        title: Text('Create Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Center(
                child: Text(
                  'Add New Post',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Id is auto random',
                          enabled: false,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _locationController,
                        decoration: InputDecoration(
                          labelText: 'Location',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _scheduleController,
                        decoration: InputDecoration(
                          labelText: 'Schedule',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _preferredTimeController,
                        decoration: InputDecoration(
                          labelText: 'Preferred Time',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      DropdownButtonFormField<int>(
                        value: _gender,
                        decoration: InputDecoration(
                          labelText: 'Gender',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        items: [
                          DropdownMenuItem(value: 1, child: Text('Male')),
                          DropdownMenuItem(value: 2, child: Text('Female')),
                          DropdownMenuItem(value: 3, child: Text('Other')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _gender = value!;
                          });
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _requestSkillController,
                        decoration: InputDecoration(
                          labelText: 'Request Skill',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: AddPostPageRequest,
                        child: Text('Submit'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
