import 'package:connecten/view/form_screen.dart';
import 'package:connecten/view/profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:connecten/provider/internet_provider.dart';
import 'package:connecten/provider/sign_in_provider.dart';
import 'package:connecten/utils/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_storage/get_storage.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        // mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            "assets/login.png",
            width: _width,
            // alignment: Alignment.topCenter,
            scale: 0.8,
          ),
          Container(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: _width * 0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    "Welcome to",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const Text(
                    "ConnecTen",
                    style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const Text(
                    "\nBest community connection platform \nfor all meetups and events to \nconnect hassle free.",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Text(
                    "\nJoin For Free.",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      // horizontal: _width * 0.11,
                      vertical: _height * 0.08,
                    ),
                    child: Material(
                      // color: Color(0xff567DF4),
                      color: Colors.red,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: InkWell(
                        onTap: () {
                          handleGoogleSignIn();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          alignment: Alignment.center,
                          height: _width * 0.12,
                          decoration: const BoxDecoration(
                            color: Colors.transparent,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset("assets/google.png"),
                              Padding(
                                padding:
                                    EdgeInsets.fromLTRB(_width * 0.05, 0, 0, 0),
                                child: const Text(
                                  "Sign in with Google",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // SizedBox(
                  //   height: _height * 0.05,
                  // )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Handling Google sign in
  Future handleGoogleSignIn() async {
    final sp = context.read<SignInProvider>();
    final ip = context.read<InternetProvider>();
    await ip.checkInternetConnection();

    if (ip.hasInternet == false) {
      openSnackBar(
          context, "Check your Internet connection.", Colors.red.shade400);
    } else {
      await sp.signInWithGoogle().then((value) {
        if (sp.hasError == true) {
          openSnackBar(context, sp.errorCode.toString(), Colors.red.shade400);
        } else {
          sp.chechUserExists().then((value) async {
            if (value == true) {
              //await GetStorage.init();
              sp.setSignIn();
              await sp.getUserDataFromFirestore().then((value) async{
                await sp.saveDataToSharedPreferences();
                await sp.readDataFromSharedPreferences();
                handleAfterSignIn();
              });


            } else {
              sp.saveDataToFirestore().then((value) {
                sp
                    .saveDataToSharedPreferences()
                    .then((value) => sp.setSignIn().then((value) {
                          handleNewSignIn();
                        }));
              });
            }
          });
        }
      });
    }
  }

  handleNewSignIn() {
    Future.delayed(Duration(seconds: 1)).then((value) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => FormScreen()));
    });
  }

  handleAfterSignIn() {
    final sp = context.read<SignInProvider>();
    if (sp.isFormDone == true) {
      Future.delayed(Duration(seconds: 1)).then((value) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Profile()));
      });
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => FormScreen()));
    }
  }
}
