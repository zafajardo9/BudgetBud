import 'package:budget_bud/misc/widgetSize.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../components/my_button.dart';
import '../../misc/colors.dart';
import '../../misc/txtStyles.dart';
import 'components/profile_page_details.dart';
import 'components/user_detail_header.dart';

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
    // if (user.photoURL != null) {
    //   String link = user.photoURL.toString();
    //   return NetworkImage(
    //     link,
    //   );
    // } else {
    //   return AssetImage('assets/user.png');
    // }

    //OPTIMIZED
    return user.photoURL != null
        ? NetworkImage(user.photoURL!)
        : AssetImage('assets/user.png');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          bottomOpacity: 0.0,
          elevation: 0.0,
          title: const Text(
            'Profile',
            style: ThemeText.appBarTitle,
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
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CircleAvatar(
                          radius: 50, backgroundImage: getProfilePic()),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.displayName != null
                                  ? user.email!.replaceFirst("@gmail.com", '')
                                  : '${user.displayName}',
                              style: ThemeText.subHeaderWhite1,
                            ),
                            Text(
                              user.email!,
                              //  user Email
                              style: ThemeText.paragraphWhite,
                            ),
                          ],
                        ),
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
                    children: const [
                      Icon(Icons.wallet),
                      Text('Wallet'),
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
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                      ProfilePageDetailTile(),
                      addVerticalSpace(60),
                      MyButton(
                        btn: "Sign Out",
                        onTap: signUserOut,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
