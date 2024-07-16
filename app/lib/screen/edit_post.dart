import 'dart:convert';

import 'package:app/Component/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EditPostPage extends StatefulWidget {
  final Map<String, dynamic> postData;
  const EditPostPage({super.key, required this.postData});

  @override
  State<EditPostPage> createState() => _EditPostPageState();
}

class _EditPostPageState extends State<EditPostPage> {
  late TextEditingController _postIdController;
  late TextEditingController _descriptionController;
  late TextEditingController _locationController;
  late TextEditingController _scheduleController;
  late TextEditingController _preferredTimeController;
  late TextEditingController _requestSkillController;

  int _gender = 1;

  @override
  void initState() {
    super.initState();
    _postIdController = TextEditingController(text: widget.postData['postId']);
    _descriptionController =
        TextEditingController(text: widget.postData['description']);
    _locationController =
        TextEditingController(text: widget.postData['location']);
    _scheduleController =
        TextEditingController(text: widget.postData['schedule']);
    _preferredTimeController =
        TextEditingController(text: widget.postData['preferredTime']);
    _requestSkillController =
        TextEditingController(text: widget.postData['requestSkill']);
    _gender = widget.postData['gender'];
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _locationController.dispose();
    _scheduleController.dispose();
    _preferredTimeController.dispose();
    _requestSkillController.dispose();
    super.dispose();
  }

  Future<void> updatePostById() async {
    if (_formKey.currentState!.validate()) {
      final data = {
        "description": _descriptionController.text,
        "location": _locationController.text,
        "schedule": _scheduleController.text,
        "preferredTime": _preferredTimeController.text,
        "mode": 1,
        "gender": _gender,
        "status": 1,
        "requestSkill": _requestSkillController.text,
        "createdDate": DateTime.now().toIso8601String()
      };
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');
      final id = widget.postData['postId'];
      // final url = 'https://10.0.2.2:7194/PostRequest/update-post-request/$id';
      final url = 'https://mytutorlink.arisavinh.dev/PostRequest/update-post-request/$id';
      final uri = Uri.parse(url);
      final response = await http.put(uri, body: jsonEncode(data), headers: {
        'content-type': 'application/json',
        'Authorization': 'Bearer $token'
      });
      if (response.statusCode == 200) {
        Fluttertoast.showToast(
        msg: "Update post success",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
        //quay về trang home
        context.go("/home");
      } else {}
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Edit Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Center(
                child: Text(
                  'Update Post',
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
                        controller: _postIdController,
                        decoration: InputDecoration(
                          labelText: 'Id',
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
                          // DropdownMenuItem(value: 0, child: Text('Other')),
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
                        onPressed: updatePostById,
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
