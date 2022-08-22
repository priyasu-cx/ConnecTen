import 'package:connecten/provider/sign_in_provider.dart';
import 'package:connecten/utils/colors.dart';
import 'package:connecten/view/Nav_Drawer/menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../provider/sign_in_provider.dart';
import 'package:provider/provider.dart';

class UpEvents extends StatefulWidget {
  const UpEvents({Key? key}) : super(key: key);

  @override
  State<UpEvents> createState() => _UpEventsState();
}

class _UpEventsState extends State<UpEvents> {
  @override
  Widget build(BuildContext context) {
    final sp = context.read<SignInProvider>();
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
                "Upcoming Events",
                style: TextStyle(
                  letterSpacing: 1,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: Get.height * .02),
              SingleChildScrollView(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("events")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    } else if (snapshot.hasData || snapshot.data != null) {
                      return ListView.builder(
                        reverse: true,
                        shrinkWrap: true,
                        itemBuilder: (context, index) =>
                            Event_card(index, snapshot),
                        itemCount: snapshot.data?.docs.length,
                      );
                    } else {
                      return Text('Something went wrong');
                    }
                  },
                )
              ),
            ],
          ),
        )
    );
  }

  Widget Event_card(index, snapshot) {
    final sp = context.read<SignInProvider>();
    QueryDocumentSnapshot<Object?>? documentSnapshot =
    snapshot.data?.docs[index];
    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: GestureDetector(
        onTap: (){
          showModalBottomSheet(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40.0),
              ),
              context: context,
              elevation: 1,
              builder: (BuildContext context){return Event_details(index,snapshot);}
          );
        },
      child: Container(
        //height: Get.height*0.1,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: Get.width * 0.03),
          decoration: BoxDecoration(
            color: cardcolor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                        (documentSnapshot != null) ? (documentSnapshot["Name"]) : "",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                        textAlign: TextAlign.justify,
                      ),
                        Text(
                          (documentSnapshot != null) ? (documentSnapshot["Location"]) : "",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w300),
                          textAlign: TextAlign.justify,
                        ),
                        SizedBox(height: Get.height*0.01,),
                        Text(
                          (documentSnapshot != null) ? (documentSnapshot["Date"]) : "",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w300),
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),

                    Column(
                      children: [

                        IconButton(onPressed: (){
                          print(index+1);
                          sp.addToEvent((index+1).toString());},
                            icon: Icon(Icons.event_seat_rounded)
                        )
                      ],
                    )
                  ],
                )


              ],
            )
          )),)
    );

  }
  List<Map<String, String?>> allUserData = [];
  List<String?> connectedList = [];
  bool isDone = false;

  Future<List<String?>> getAttendeeList(String? index) async {
    //final datacount = GetStorage();
    List<String?> data = [];
    final DocumentReference ref =
    FirebaseFirestore.instance.collection("events").doc(index);
    await ref.get().then((DocumentSnapshot snapshot) {
      var attendeeData = snapshot["Attendees"];
      data = List<String?>.from(attendeeData);
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

  getallData(index) async {
    List<Map<String, String?>> allData = [];
    List<String?> uidList = [];
    uidList = await getAttendeeList(index.toString());
    print(uidList.length);
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
    //final cp = context.read<ConnectionProvider>();
    final sp = context.read<SignInProvider>();
    // final datacount = GetStorage();

    if (isDone == false) {
      //getallData(sp.uid!);
    }
    super.initState();
  }


  Widget Event_details(index,snapshot) {
    getallData(index+1);
    print("***************************************************" + allUserData.length.toString());
    QueryDocumentSnapshot<Object?>? documentSnapshot =
    snapshot.data?.docs[index];
    return Container(
      // decoration: BoxDecoration(
      //     gradient: LinearGradient(
      //       begin: Alignment.topRight,
      //       end: Alignment.bottomLeft,
      //       colors: [
      //         Colors.blue,
      //         Colors.red,
      //       ],
      //     )
      // ),
      margin: EdgeInsets.fromLTRB(30, 30, 30, 25),
      //padding: ,
      child: Column(
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            (documentSnapshot != null) ? (documentSnapshot["Name"]) : "",
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: Get.height*0.01,),
          Text(
            (documentSnapshot != null) ? (documentSnapshot["Location"]) : "",
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w300),
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: Get.height*0.01,),
          Text(
            (documentSnapshot != null) ? (documentSnapshot["Date"]) : "",
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w300),
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: Get.height*0.01,),


          Text(
            (documentSnapshot != null) ? (documentSnapshot["About"]) : "",
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w300),
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: Get.height*0.02,),
          const Divider(
            thickness: 1,
            height: 10,
            color: Colors.grey,
          ),
          SizedBox(height: Get.height*0.02,),
          Text(
            "{ Attendees }",
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w500),
            textAlign: TextAlign.justify,
          ),SizedBox(height: Get.height*0.02,),
          const Divider(
            thickness: 1,
            height: 10,
            color: Colors.grey,
          ),SizedBox(height: Get.height*0.02,),
          SingleChildScrollView(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: allUserData.length,
              itemBuilder: (context, i) {
                return ListTile(
                  visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                  dense: true,
                  selectedTileColor: Colors.blue,
                  title: Container(
                    padding: EdgeInsets.all(10),
                    width: 100,
                    decoration: BoxDecoration(
                      color: cardcolor,
                      border: Border(),
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: Text(
                      allUserData[i]["fullname"]!,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w300),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                );
              },
            )
          )

        ]

      ),
    );
  }
}
