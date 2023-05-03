import 'package:budget_bud/misc/widgetSize.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../components/my_button.dart';
import '../../misc/colors.dart';
import '../../misc/txtStyles.dart';
import 'components/profile_page_details.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = FirebaseAuth.instance.currentUser!;



  //sign out
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }


  getProfilePic() {
    return user.photoURL != null
        ? NetworkImage(user.photoURL!)
        : AssetImage('assets/user.png');
  }

  String getDisplayName(User? user) {
    if (user == null) {
      return '';
    }

    if (user.displayName != null) {
      return user.email!.replaceAll("@gmail.com", "");
    } else {
      return '${user.displayName}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        bottomOpacity: 0.0,
        elevation: 0.0,
        title: Text(
          'Profile',
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.settings))
        ],
      ),
      body: Container(
        width: double.infinity,
        color: AppColors.mainColorOne,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: Adaptive.w(100),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CircleAvatar(
                        radius: 50, backgroundImage: getProfilePic()),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: StreamBuilder<User?>(
                        stream: FirebaseAuth.instance.authStateChanges(),
                        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }

                          if (!snapshot.hasData) {
                            // User is not logged in
                            return Text('Not logged in');
                          }
                          final user = snapshot.data!;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(getDisplayName(user),
                                style: ThemeText.subHeaderWhite1,
                              ),
                              Text(
                                user.email!,
                                //  user Email
                                style: ThemeText.paragraphWhite,
                              ),
                            ],
                          );
                        },
                      )
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  shadowColor: Colors.transparent,
                  elevation: 0.0,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  backgroundColor:
                      AppColors.mainColorFour, // background (button) color
                  foregroundColor: Colors.black87, // foreground (text) color
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.wallet),
                    Text(
                      'Wallet',
                      style: ThemeText.paragraph,
                    ),
                    Icon(Icons.arrow_forward_ios_outlined),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadiusDirectional.only(
                      topStart: Radius.circular(25),
                      topEnd: Radius.circular(25),
                    )),
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Details',
                              style: ThemeText.textHeader3,
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.edit_note,
                                size: 30,
                              ),
                              onPressed: () {
                                //to be made
                              },
                            ),
                          ],
                        ),
                      ),
                      ProfilePageDetailTile(),
                      addVerticalSpace(Adaptive.h(4)),
                      MyButton(
                        btn: "Sign Out",
                        onTap: signUserOut,
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}


