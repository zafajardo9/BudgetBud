import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

Future<int> sendEmail() async {
  final user = FirebaseAuth.instance.currentUser!;
  final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
  const serviceId = 'service_yldc4gd';
  const templateId = 'template_3xbvfyl';
  const userId = 'tlZKejJBjNv2mYWrC';
  const private = 'oDLXhmWZ1rX1C0mOe-gQj';

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      'service_id': serviceId,
      'template_id': templateId,
      'user_id': userId,
      'accessToken': private,
      'template_params': {
        'name': user.email,
        'message': 'Hello, this is a test',
        'user_email': user.email,
      },
    }),
  );

  return response.statusCode;
}
