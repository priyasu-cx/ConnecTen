import 'package:connecten/provider/internet_provider.dart';
import 'package:connecten/provider/sign_in_provider.dart';
import 'package:connecten/view/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'provider/connection_provider.dart';

void main() async {
  // Initialize the application
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SignInProvider()),
        ChangeNotifierProvider(create: (context) => InternetProvider()),
        ChangeNotifierProvider(create: (context) => ConnectionProvider()),
      ],
      child: GetMaterialApp(
        title: 'ConnecTen',
        theme: ThemeData(
            textTheme: GoogleFonts.robotoTextTheme(
          Theme.of(context).textTheme,
        )),
        debugShowCheckedModeBanner: false,
        home: LandingPage(),
      ),
    );
  }

  LandingPage() => SplashScreen();
}
