import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;

class UpdateProfile extends StatefulWidget {
  final Map<String, dynamic>? userData;
  final VoidCallback refreshProfile;

  const UpdateProfile({super.key, required this.userData, required this.refreshProfile});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  File? _image;
  final _picker = ImagePicker();
  String? _avatarUrl;
  UploadTask? uploadTask;
  bool _isPasswordVisible = false;
  bool _isLoading = false; // Loading state

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;
  late final TextEditingController _fullnameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  int? _gender;

  @override
  void initState() {
    super.initState();

    _usernameController =
        TextEditingController(text: widget.userData?['username']);
    _passwordController =
        TextEditingController(text: widget.userData?['password']);
    _fullnameController =
        TextEditingController(text: widget.userData?['fullname']);
    _emailController = TextEditingController(text: widget.userData?['email']);
    _phoneController = TextEditingController(text: widget.userData?['phone']);
    _addressController =
        TextEditingController(text: widget.userData?['address']);
    _gender = widget.userData?['gender'];
    _avatarUrl = widget.userData?['avatarUrl'];
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _fullnameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> handleUpdate() async {
     setState(() {
      _isLoading = true;
    });

    String? newAvatarUrl = _avatarUrl;

    // Upload the image to Firebase if a new image is selected
    if (_image != null) {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child('avatars/$fileName');
      uploadTask = firebaseStorageRef.putFile(_image!);
      TaskSnapshot taskSnapshot = await uploadTask!.whenComplete(() {});
      newAvatarUrl = await taskSnapshot.ref.getDownloadURL();
    }

    // Construct the updated profile object
    final updatedProfileForm = {
      "username": _usernameController.text,
      "password": _passwordController.text,
      "fullname": _fullnameController.text,
      "email": _emailController.text,
      "phone": _phoneController.text,
      "address": _addressController.text,
      "avatarUrl": newAvatarUrl,
      "gender": _gender
    };

    final userId = widget.userData?['accountId'];
    // final url = 'https://10.0.2.2:7194/Account/update/$userId';
    final url = 'https://mytutorlink.arisavinh.dev/Account/update/$userId';
    final uri = Uri.parse(url);
    final res = await http.put(uri,
        body: jsonEncode(updatedProfileForm),
        headers: {'content-type': 'application/json'});
    setState(() {
      _isLoading = false;
    });
    if (res.statusCode == 200) {
      Fluttertoast.showToast(
        msg: "Update successful!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      context.pop('/home/user-profile');
      widget.refreshProfile();
    } else {
      Fluttertoast.showToast(
        msg: "Update failed!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }

    // Optionally, you can send this data to your server or handle it further as needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Edit Profile'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: <Widget>[
                Center(
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey,
                      backgroundImage: _image != null
                          ? FileImage(_image!)
                          : (_avatarUrl != null ? NetworkImage(_avatarUrl!) : null) as ImageProvider?,
                      child: _image == null && _avatarUrl == null ? Icon(Icons.camera_alt, size: 50) : null,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  obscureText: !_isPasswordVisible,
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _fullnameController,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: 'Address',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                DropdownButtonFormField<int>(
                  value: _gender,
                  decoration: InputDecoration(
                    labelText: 'Gender',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: 1,
                      child: Text('Male'),
                    ),
                    DropdownMenuItem(
                      value: 2,
                      child: Text('Female'),
                    ),
                  ],
                  onChanged: (newValue) {
                    setState(() {
                      _gender = newValue;
                    });
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: handleUpdate,
                  child: Text('Update Profile'),
                ),
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}

