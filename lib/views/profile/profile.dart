import 'package:dio/dio.dart';
import 'package:discounttour/api/account.dart';
import 'package:discounttour/model/User.dart';
import 'package:discounttour/views/auth/welcome.dart';
import 'package:discounttour/views/profile/about.dart';
import 'package:flutter/material.dart';

import '../../widget/profile-menu.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile-screen';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User user;

  @override
  void initState() {
    super.initState();
    fetchLoggedUser();
  }

  fetchLoggedUser() async {
    Response<dynamic> response = await Account().fetchAccount();
    if (response.statusCode == 200) {
      Map<String, dynamic> userData =
          response.data; // Assuming response.data contains user data
      setState(() {
        user = User.fromJson(userData);
      });
    } else {
      // Handle error scenario
      print("Error fetching user data: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfffafafa),
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.black, size: 24)),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 100),
          child: Column(
            children: [
              /// -- IMAGE
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: const Image(
                            image: AssetImage('assets/user-icon.png'))),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.amber),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text('${user?.firstName ?? ''} ${user?.lastName ?? ''}',
                  style: Theme.of(context).textTheme.headline4),
              Text('${user?.email ?? ''}',
                  style: Theme.of(context).textTheme.bodyText2),
              const SizedBox(height: 20),

              /// -- BUTTON
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () => {},
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      side: BorderSide.none,
                      shape: const StadiumBorder()),
                  child: const Text('Editare',
                      style: TextStyle(color: Colors.black)),
                ),
              ),
              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 10),

              /// -- MENU
              ProfileMenuWidget(
                  title: "Setări", icon: Icons.settings, onPress: () {}),
              // ProfileMenuWidget(
              //     title: "Billing Details", icon: Icons.wallet, onPress: () {}),
              // ProfileMenuWidget(
              //     title: "User Management",
              //     icon: Icons.verified_user,
              //     onPress: () {}),
              const Divider(),
              const SizedBox(height: 10),
              ProfileMenuWidget(
                title: "Despre",
                icon: Icons.info,
                onPress: () {
                  Navigator.of(context).pushNamed(AboutScreen.routeName);
                },
              ),
              ProfileMenuWidget(
                  title: "Ieșire",
                  icon: Icons.logout,
                  textColor: Colors.red,
                  endIcon: false,
                  onPress: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Ieșire sistem"),
                            // titleStyle: const TextStyle(fontSize: 20),
                            content: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 15.0),
                              child: Text(
                                  "Sunteți sigur că doriți să ieșiți din sistem ?"),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Account().logout();
                                  // Handle logout action here
                                  Navigator.of(context)
                                      .pop(); //  Close the dialog
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      WelcomeScreen.routeName, (_) => false);
                                },
                                child: Text("Da"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                },
                                child: Text("Nu"),
                              ),
                            ],
                            // confirm: Expanded(
                            //   child: ElevatedButton(
                            //     onPressed: () => {},
                            //     style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, side: BorderSide.none),
                            //     child: const Text("Yes"),
                            //   ),
                            // cancel: OutlinedButton(onPressed: () => Get.back(), child: const Text("No")),
                          );
                        });
                  }),
            ],
          ),
        ),
      ),
    );
    // return Scaffold(
    //   body: Center(
    //     child: user != null // Check if user is not null
    //         ? Text(user.login) // If user is not null, display user's login
    //         : CircularProgressIndicator(), // If user is null, display a loading indicator
    //   ),
    // );
  }
}
