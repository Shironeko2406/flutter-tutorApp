import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CreateAppointment extends StatefulWidget {
  final Map<String, dynamic> dataAppointment;
  const CreateAppointment({super.key, required this.dataAppointment});

  @override
  State<CreateAppointment> createState() => _CreateAppointmentState();
}

class _CreateAppointmentState extends State<CreateAppointment> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  void _selectTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _timeController.text = picked.format(context);
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();
      final user = prefs.getString('userLogin');
      if (user != null) {
        final Map<String, dynamic> userMap = jsonDecode(user);

        // Convert time to 24-hour format
        final timeOfDay = _timeController.text;
        final timeParts = timeOfDay.split(' ');
        final time = timeParts[0];
        final period = timeParts[1];
        final hourMinute = time.split(':');
        var hour = int.parse(hourMinute[0]);
        final minute = hourMinute[1];

        // Adjust hour for 24-hour format
        if (period == 'PM' && hour != 12) {
          hour += 12;
        } else if (period == 'AM' && hour == 12) {
          hour = 0;
        }

        final appointmentTime =
            '${_dateController.text}T${hour.toString().padLeft(2, '0')}:$minute:00.000Z';

        final appointmentForm = {
          'accountId': userMap['userId'],
          'tutorId': widget.dataAppointment['tutorId'],
          'postId': widget.dataAppointment['postId'],
          'appointmentTime': appointmentTime,
          'address': _addressController.text,
        };

        const url =
            // "https://10.0.2.2:7194/AppointmentFeedback/book-appointment";
        "https://mytutorlink.arisavinh.dev/AppointmentFeedback/book-appointment";

        final uri = Uri.parse(url);
        final response =
            await http.post(uri, body: jsonEncode(appointmentForm), headers: {
          'Content-type': 'application/json',
        });
        if (response.statusCode == 200) {
          Fluttertoast.showToast(
            msg: "Appointment booked successfully!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          context.go("/home");
        } else if (response.statusCode == 400) {
          Fluttertoast.showToast(
            msg: "Error: Appointment date cannot be earlier than today!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          print("Error: Appointment date cannot be earlier than today!");
        } else {
          Fluttertoast.showToast(
            msg: "Error: ${response.statusCode}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          print("Error: ${response.statusCode}");
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Create Appointment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: 'Appointment Date',
                  hintText: 'Select date',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: _selectDate,
                  ),
                ),
                readOnly: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a date';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _timeController,
                decoration: InputDecoration(
                  labelText: 'Appointment Time',
                  hintText: 'Select time',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.access_time),
                    onPressed: _selectTime,
                  ),
                ),
                readOnly: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a time';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Address',
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Create Appointment'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
