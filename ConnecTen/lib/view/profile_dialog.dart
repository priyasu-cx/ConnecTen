import 'package:connecten/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:url_launcher/url_launcher.dart';

Future ProfileDialog(allUserData, context) => showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          //title: Text(uid+" Link"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                CircleAvatar(
                  radius: Get.width * 0.1,
                  backgroundColor: primarybgcolor,
                  backgroundImage: AssetImage("assets/Avatar.png"),
                  foregroundImage: NetworkImage(allUserData["imageUrl"]),
                  //foregroundImage: sp.imageUrl == null ? AssetImage("assets/Avatar.png") : NetworkImage(sp.imageUrl),
                  //foregroundImage: NetworkImage(sp.imageUrl!),
                ),
                SizedBox(
                  height: Get.height * 0.01,
                ),
                Text(
                  "Social Links",
                  style: TextStyle(
                    letterSpacing: 1,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.left,
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      social_link(context, 1, "assets/linkedin.png", "Linkedin",
                          allUserData["linkedIn"]),
                      social_link(context, 2, "assets/github.png", "Github",
                          allUserData["github"]),
                      social_link(context, 3, "assets/website.png", "Portfolio",
                          allUserData["portfolio"]),
                      social_link(context, 4, "assets/twitter.png", "Twitter",
                          allUserData["twitter"]),
                      // Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //     children: [
                      //       social_link(context, 1, "assets/linkedin.png", "Linkedin", "link"),
                      //       social_link(context, 2, "assets/github.png", "Github", "link"),
                      //     ]),
                      // Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //     children: [
                      //       social_link(context,3, "assets/website.png", "Portfolio", "link"),
                      //       social_link(context,4, "assets/twitter.png", "Twitter", "link"),
                      //     ]),
                    ],
                  ),
                )
              ],
            ),
          ));
    });
Widget social_link(context, index, image, text, link) {
  return Container(
    width: Get.width * 0.3,
    padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
    margin: EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Color(0xffeef7fe),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Stack(
      alignment: Alignment.center,
      children: [
        // Container(
        //   alignment: Alignment.topRight,
        //   child: IconButton(
        //     alignment: Alignment.topRight,
        //     onPressed: () {
        //       openDialog(image, text);
        //     },
        //     icon: FaIcon(
        //       FontAwesomeIcons.penToSquare,
        //       color: arrowcolor,
        //     ),
        //     iconSize: 15,
        //   ),
        // ),
        GestureDetector(
          onTap: () async {
            if (link == "") {
              Get.snackbar("Oops", "No link found");
            } else {
              var url = Uri.parse(link);

              if (await canLaunchUrl(url)) {
                // LaunchMode.externalApplication;
                await launchUrl(url, mode: LaunchMode.externalApplication);
              } else {
                throw 'Could not launch $url';
              }
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                image,
                height: 25,
                width: 25,
              ),
              SizedBox(height: Get.height * 0.01),
              Text(
                text,
                //textAlign: TextAlign.start,
                style: TextStyle(
                  letterSpacing: 1,
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        )
      ],
    ),
  );
}
