import 'dart:io';

import 'package:app/Component/app_bar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadFile extends StatefulWidget {
  const UploadFile({super.key});

  @override
  State<UploadFile> createState() => _UploadFileState();
}

class _UploadFileState extends State<UploadFile> {
  File? image;
  UploadTask? uploadTask;
  String avatarUrl = '';

  Future<void> uploadImageToFirebase() async {
    if (image == null) return;

    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference firebaseStorageRef = FirebaseStorage.instance.ref().child('mobile/$fileName');
    uploadTask = firebaseStorageRef.putFile(image!);
    
    await uploadTask!.whenComplete(() async {
      String imageUrl = await firebaseStorageRef.getDownloadURL();
      print(imageUrl);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  CustomAppBar(avatarUrl: avatarUrl,),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 75,
              backgroundColor: Colors.grey[200],
              backgroundImage: image != null ? FileImage(image!) : null,
              child: image == null
                  ? InkWell(
                      onTap: () async {
                        final picture = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                        if (picture != null) {
                          setState(() {
                            image = File(picture.path);
                          });
                        }
                      },
                      child: Center(
                        child: Icon(
                          Icons.camera_alt,
                          size: 50,
                          color: Colors.grey[800],
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {uploadImageToFirebase();},
              child: const Text('Upload Image'),
            ),
          ],
        ),
      ),
    );
  }
}

