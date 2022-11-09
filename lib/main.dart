import 'package:betagram/Provider/user_provider.dart';
import 'package:betagram/responsive/responsive_layout_screen.dart';
import 'package:betagram/screens/login_screen.dart';
import 'package:betagram/screens/signup_screen.dart';
import 'package:betagram/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './responsive/responsive_layout_screen.dart';
import './responsive/mobile_screen_layout.dart';
import './responsive/web_screen_layout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyAK9Ys1RtUKO3aJTAR8NGF8kuqSWBLh4vQ",
        projectId: "betagram-7ca01",
        messagingSenderId: "372234750025",
        appId: "1:372234750025:web:20e6f50437d651961e5798",
        storageBucket: "betagram-7ca01.appspot.com",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => UserProvider(),
          ),
        ],
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Betagram',
            theme: ThemeData.dark().copyWith(
              scaffoldBackgroundColor: mobileBackgroundColor,
            ),
            // home: ResposiveLayout(
            //     mobileScreenLayout: MobileScreenLayout(),
            //     webScreenLayout: webScreenLayout())));
            home: StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      return const ResposiveLayout(
                          mobileScreenLayout: MobileScreenLayout(),
                          webScreenLayout: webScreenLayout());
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Bhratashree error!!!!!'),
                      );
                    }
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(color: primaryColor),
                    );
                  }
                  return const LoginScreen();
                })));
  }
}


// home: ResposiveLayout(
//                 mobileScreenLayout: MobileScreenLayout(),
//                 webScreenLayout: webScreenLayout())));