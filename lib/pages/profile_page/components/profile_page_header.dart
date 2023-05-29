// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// import '../../user_wallet/wallet.dart';
//
// class UserProfileWidget extends StatelessWidget {
//   final User? user;
//   final Function? backgroundImage;
//
//   UserProfileWidget({this.user, required this.backgroundImage});
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           child: Container(
//             margin: EdgeInsets.only(top: 43),
//             width: double.infinity,
//             height: 100, // Set the desired height
//             decoration: BoxDecoration(
//               color: Colors.blue
//                   .withOpacity(.7), // Replace with your desired color
//               borderRadius: BorderRadius.circular(16.0),
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: StreamBuilder<User?>(
//                     stream: FirebaseAuth.instance.authStateChanges(),
//                     builder:
//                         (BuildContext context, AsyncSnapshot<User?> snapshot) {
//                       if (snapshot.connectionState == ConnectionState.waiting) {
//                         return const CircularProgressIndicator();
//                       }
//
//                       if (!snapshot.hasData) {
//                         // User is not logged in
//                         return Text('Not logged in');
//                       }
//
//                       final userName = user?.displayName ?? '';
//
//                       return SizedBox(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               '@$userName',
//                               // style: ThemeText.subHeader1, // Replace with your desired text style
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   child: ElevatedButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => UserWallet()),
//                       );
//                     },
//                     style: ElevatedButton.styleFrom(
//                       shadowColor: Colors.transparent,
//                       elevation: 0,
//                       padding:
//                           EdgeInsets.symmetric(vertical: 12, horizontal: 20),
//                       backgroundColor: Colors.green.withOpacity(
//                           .9), // Replace with your desired background color
//                       foregroundColor: Colors
//                           .black87, // Replace with your desired text color
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Icon(Icons.wallet),
//                         Text(
//                           'Wallet',
//                           // style: ThemeText.paragraph, // Replace with your desired text style
//                         ),
//                         Icon(Icons.arrow_forward_ios_outlined),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         Align(
//           alignment: Alignment.topCenter,
//           child: SizedBox(
//             child: CircleAvatar(
//               radius: 40.0,
//               backgroundColor: Colors.white,
//               child: CircleAvatar(
//                 radius: 50,
//                 backgroundImage: backgroundImage!(),
//                 backgroundColor: Colors.grey.withOpacity(.5),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
