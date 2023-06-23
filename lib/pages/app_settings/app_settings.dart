import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../misc/const.dart';

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

  @override
  Widget build(BuildContext context) {
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
                    // Handle notification settings
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
