import 'package:connecten/provider/connection_provider.dart';
import 'package:connecten/utils/colors.dart';
import 'package:connecten/view/Nav_Drawer/menu.dart';
import 'package:connecten/view/profile_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../provider/sign_in_provider.dart';
import 'package:provider/provider.dart';

class NearbyConnect extends StatefulWidget {
  const NearbyConnect({Key? key}) : super(key: key);

  @override
  State<NearbyConnect> createState() => _NearbyConnectState();
}

class _NearbyConnectState extends State<NearbyConnect> {
  List<Map<String, String?>> allUserData = [];
  bool isDone = false;

  Future<Map<String, String?>> fetchUserData(String uid) async {
    var userData = new Map<String, String?>();
    List<String?> connectedList = [];

    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get()
        .then((DocumentSnapshot snapshot) async {
      userData["uid"] = snapshot["uid"];
      userData["fullname"] = snapshot["fullname"];
      userData["designation"] = snapshot["designation"];
      userData["bio"] = snapshot["bio"];
      userData["imageUrl"] = snapshot["imageUrl"];
      userData["linkedIn"] = snapshot["linkedIn"];
      userData["github"] = snapshot["github"];
      userData["portfolio"] = snapshot["portfolio"];
      userData["twitter"] = snapshot["twitter"];
      // userData["connectedList"] = snapshot["connectedList"];
      var connectedData = snapshot["connectedList"];
      connectedList= List<String?>.from(connectedData);
    });

    return userData;
  }

  void getallData(List<String> uidList) async {
    List<Map<String, String?>> allData = [];

    for (var uid in uidList) {
      // Get.snackbar("Uid", uid);
      final alphanumeric = RegExp(r'^[a-zA-Z0-9_]*$');
      print("Before if "+ uid);
      if(alphanumeric.hasMatch(uid) == true){
        print(uid);
        await fetchUserData(uid).then((value) {
          // "^[a-zA-Z0-9_]*$"

          allData.add(value);
        });
      }
      //print(uid);

    }
    setState(() {
      isDone = true;
      allUserData = allData;
    });
  }

  @override
  void initState() {
    final cp = context.read<ConnectionProvider>();
    if (isDone == false) {
      getallData(cp.connections);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    print("Outside check -> ");
    print(allUserData.length);
    return Scaffold(
        drawer: const Menu(),
        appBar: AppBar(
          toolbarHeight: Get.height * 0.12,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          shadowColor: primarybgcolor,
          elevation: 0.0,
          leading: Builder(
            builder: (context) => IconButton(
              splashRadius: 1,
              padding: const EdgeInsets.fromLTRB(30, 40, 0, 25),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: FaIcon(
                FontAwesomeIcons.bars,
                color: arrowcolor,
              ),
              alignment: Alignment.centerLeft,
            ),
          ),
        ),
        body: Container(
          margin: EdgeInsets.fromLTRB(30, 0, 30, 25),
          child: Column(
            children: [
              Text(
                "Nearby Connections",
                style: TextStyle(
                  letterSpacing: 1,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: Get.height * .02),
              SingleChildScrollView(
                child: Container(
                    height: Get.height * 0.6,
                    //height: Get.height*0.5,
                    child: ListView.builder(
                        itemCount: allUserData.length,
                        itemBuilder: (context, i) {
                          //return Connect(userdata["fullname"], userdata["designation"]);

                          return Connect(allUserData[i], allUserData[i]["fullname"], allUserData[i]["designation"]);
                        })),
              ),
            ],
          ),
        ));
  }

  Widget Connect(allUserData, name, designation) {
    final sp = context.read<SignInProvider>();
    return InkWell(
      onTap: (){ProfileDialog(allUserData, context);},
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
        margin: EdgeInsets.only(bottom: 20),
        height: Get.height * 0.15,
        decoration: BoxDecoration(
          color: Color(0xffEEF7FE),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  name,
                  //textAlign: TextAlign.start,
                  style: TextStyle(
                    letterSpacing: 1,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.01,
                ),
                Text(
                  designation,
                  //textAlign: TextAlign.start,
                  style: TextStyle(
                    letterSpacing: 1,
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () async{
                      await sp.addConnection(allUserData["uid"]);
                      Get.snackbar("Connection Added", allUserData["fullname"]);
                    },
                    icon: FaIcon(
                      FontAwesomeIcons.userPlus,
                      color: arrowcolor,
                    ),
                  ),
                )
              ],
            )
          ],
        )));
  }
}
