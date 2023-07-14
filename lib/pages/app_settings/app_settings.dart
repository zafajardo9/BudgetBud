import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../misc/const.dart';
import '../on_working_feature/progress_alert.dart';

class AppSettings extends StatelessWidget {
  Future<Map<String, String>> _getApplicationVersion() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final String appName = packageInfo.appName;
    final String packageName = packageInfo.packageName;
    final String version = packageInfo.version;
    final String buildNumber = packageInfo.buildNumber;

    return {
      'appName': appName,
      'packageName': packageName,
      'version': version,
      'buildNumber': buildNumber,
    };
  }

  const AppSettings({Key? key});

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

  @override
  Widget build(BuildContext context) {
    Future<void> deleteUserData(BuildContext context) async {
      String collectionName = 'Transactions';
      final FirebaseAuth auth = FirebaseAuth.instance;
      final User? user = auth.currentUser;
      final String? email = user?.email;

      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      try {
        final QuerySnapshot snapshot = await firestore
            .collection(collectionName)
            .where('UserEmail', isEqualTo: email)
            .get();

        final List<DocumentSnapshot> documents = snapshot.docs;

        for (DocumentSnapshot document in documents) {
          await document.reference.delete();
        }
        showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('Data deleted successfully.'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } catch (error) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('An error occurred while deleting data.'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }

    return FutureBuilder<Map<String, String>>(
      future: _getApplicationVersion(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while retrieving the application version
          return CircularProgressIndicator();
        } else if (snapshot.hasData) {
          final Map<String, String> appData = snapshot.data!;
          final String appName = appData['appName']!;
          final String packageName = appData['packageName']!;
          final String version = appData['version']!;
          final String buildNumber = appData['buildNumber']!;
          return Scaffold(
            appBar: AppBar(
              title: Text('BudgetBud'),
            ),
            body: ListView(
              children: [
                ListTile(
                  title: Text('Notifications'),
                  leading: Icon(Icons.notifications),
                  onTap: () {
                    WorkInProgressAlert.show(context);
                  },
                ),
                Divider(),
                ListTile(
                  title: Text('Licenses'),
                  leading: Icon(Icons.lock),
                  onTap: () => showLicensePage(
                    context: context,
                    applicationName: appName,
                    applicationLegalese: version,
                    applicationIcon: Image.asset(
                      'assets/bbLogo.png',
                      width: 50,
                    ),
                  ),
                ),
                Divider(),
                ListTile(
                  title: Text('About'),
                  leading: Icon(Icons.info),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('About Us'),
                          content: SingleChildScrollView(
                            child: Column(
                              children: [
                                Text(appName),
                                Image.asset(
                                  'assets/bbLogo.png',
                                  fit: BoxFit.contain,
                                ),
                                Text(packageName),
                                Text(version),
                                Wrap(
                                  children: [
                                    Text(
                                      aboutUseDescription,
                                      style: TextStyle(fontSize: 15.sp),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              child: Text('Close'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                Divider(),
                ListTile(
                  title: Text('Delete my Data'),
                  leading: Icon(Icons.delete_forever_rounded),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Are you really sure?'),
                          content: SingleChildScrollView(
                            child: Column(
                              children: [
                                Image.asset(
                                  'assets/bbLogo.png',
                                  fit: BoxFit.contain,
                                ),
                                Wrap(
                                  children: [
                                    Text(
                                      "There's no turning back after reformatting or deleting your transaction",
                                      style: TextStyle(fontSize: 15.sp),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          actions: [
                            ElevatedButton(
                              child: Text('No'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Text('Yes'),
                              onPressed: () {
                                deleteUserData(context);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          );
        } else {
          // Show an error message if the application version couldn't be retrieved
          return Scaffold(
            appBar: AppBar(
              title: Text('BudgetBud'),
            ),
            body: Center(
              child: Text('Error retrieving application version.'),
            ),
          );
        }
      },
    );
  }
}
