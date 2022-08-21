import 'package:connecten/utils/colors.dart';
import 'package:connecten/view/Nav_Drawer/menu.dart';
import 'package:connecten/view/profile_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../provider/connection_provider.dart';
import '../provider/sign_in_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Connections extends StatefulWidget {
  const Connections({Key? key}) : super(key: key);

  @override
  State<Connections> createState() => _ConnectionsState();
}

class _ConnectionsState extends State<Connections> {
  List<Map<String, String?>> allUserData = [];
  List<String?> connectedList = [];
  bool isDone = false;

  Future<List<String?>> getConnectionList(String? uid) async {
    final datacount = GetStorage();
    List<String?> data = [];
    final DocumentReference ref =
        FirebaseFirestore.instance.collection("users").doc(uid);
    await ref.get().then((DocumentSnapshot snapshot) {
      var connectedData = snapshot["connectedList"];
      data = List<String?>.from(connectedData);
      // print(data);
    });
    // datacount.write("connectedlist", data);
    print(data);
    return data;
  }

  Future<Map<String, String?>> fetchUserData(String uid) async {
    var userData = new Map<String, String?>();

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
      connectedList = List<String?>.from(connectedData);
    });

    return userData;
  }

  void getallData(String? uid) async {
    List<Map<String, String?>> allData = [];
    List<String?> uidList = [];
    uidList = await getConnectionList(uid!);

    for (var uid in uidList) {
      // Get.snackbar("Uid", uid);
      // print(uid);
      await fetchUserData(uid!).then((value) {
        allData.add(value);
      });
    }
    setState(() {
      isDone = true;
      allUserData = allData;
    });
  }

  @override
  void initState() {
    final cp = context.read<ConnectionProvider>();
    final sp = context.read<SignInProvider>();
    // final datacount = GetStorage();

    if (isDone == false) {
      getallData(sp.uid!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                "Connections",
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
                        return ConnectBox(
                            allUserData[i],
                            allUserData[i]["fullname"],
                            allUserData[i]["designation"]);
                      },
                    )),
              ),
            ],
          ),
        ));
  }

  Widget ConnectBox(allUserData, name, designation) {
    return InkWell(
      onTap: () {
        ProfileDialog(allUserData, context);
      },
      child: Container(
          alignment: Alignment.centerLeft,
          height: Get.height * 0.1,
          padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
          margin: EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: Color(0xffEEF7FE),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
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
          )),
    );
  }
}
