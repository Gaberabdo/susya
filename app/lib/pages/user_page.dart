import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:susya/authentication/Screens/Login/login_screen.dart';
import 'package:susya/authentication/auth_class.dart';
import 'package:susya/camera/camera_page.dart';
import 'package:susya/widgets/login_button.dart';
import '../main.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({Key? key, required User user})
      : _user = user,
        super(key: key);

  final User _user;

  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  late User _user;
  bool _isSigningOut = false;

  @override
  void initState() {
    super.initState();
    _user = widget._user; // Initialize user data
  }

  Route _routeToSignInScreen() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => MyApp(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(-1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.green,
        title: Text("Welcome ${_user.displayName ?? _user.email}"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildProfilePicture(),
              const SizedBox(height: 16.0),
              _buildEmailText(),
              const SizedBox(height: 24.0),
              _buildSignInMessage(),
              const SizedBox(height: 15),
              _buildScanCropButton(),
              const SizedBox(height: 16.0),
              _buildSignOutButton(),
            ],
          ),
        ),
      ),
    );
  }

  // Builds the user's profile picture
  Widget _buildProfilePicture() {
    return ClipOval(
      child: Material(
        color: Colors.blue,
        child: _user.photoURL != null
            ? Image.network(
                _user.photoURL!,
                fit: BoxFit.cover,
                height: 60,
                width: 60,
              )
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Icon(
                  Icons.person,
                  size: 60,
                  color: Colors.grey,
                ),
              ),
      ),
    );
  }

  // Builds the user's email display
  Widget _buildEmailText() {
    return Text(
      '(${_user.email!})',
      style: const TextStyle(
        color: Colors.green,
        fontSize: 20,
        letterSpacing: 0.5,
      ),
    );
  }

  // Builds the sign-in message
  Widget _buildSignInMessage() {
    return Text(
      'You are now signed in using your Google account. To sign out of your account, click the "Sign Out" button below.',
      style: const TextStyle(
        color: Colors.grey,
        fontSize: 14,
        letterSpacing: 0.2,
      ),
      textAlign: TextAlign.center,
    );
  }

  // Builds the scan crop button
  Widget _buildScanCropButton() {
    return LoginButton(
      title: "Scan Crop",
      onTap: () => Get.to(() => CameraPage()),
    );
  }

  // Builds the sign-out button
  Widget _buildSignOutButton() {
    return _isSigningOut
        ? const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          )
        : ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.redAccent),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26),
                ),
              ),
            ),
            onPressed: _signOut,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Sign Out',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
            ),
          );
  }

  // Handles sign-out logic
  Future<void> _signOut() async {
    setState(() {
      _isSigningOut = true;
    });
    await Authentication.signOut(context: context);
    setState(() {
      _isSigningOut = false;
    });
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
      (route) => false,
    );
  }
}
