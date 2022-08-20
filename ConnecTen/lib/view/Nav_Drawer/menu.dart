import 'package:connecten/provider/sign_in_provider.dart';
import 'package:connecten/utils/colors.dart';
import 'package:connecten/view/Nav_Drawer/drawer_item.dart';
import 'package:connecten/view/connections.dart';
import 'package:connecten/view/login_screen.dart';
import 'package:connecten/view/nearby_connect.dart';
import 'package:connecten/view/nearby_test.dart';
import 'package:connecten/view/profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:get_storage/get_storage.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    final sp = context.read<SignInProvider>();
    return Drawer(
      child: Material(
        color: secbgcolor,
        child: Container(
          margin:
              EdgeInsets.fromLTRB(30, Get.height * 0.12, Get.width * 0.05, 0),
          child: Column(
            children: [
              headerWidget(),
              SizedBox(
                height: Get.height * 0.05,
              ),
              const Divider(
                thickness: 1,
                height: 10,
                color: Colors.grey,
              ),
              SizedBox(
                height: Get.height * 0.05,
              ),
              DrawerItem(
                name: 'Nearby Connects',
                icon: Icons.people_rounded,
                onPressed: () => onItemPressed(context, index: 0),
              ),
              SizedBox(
                height: Get.height * 0.03,
              ),
              DrawerItem(
                name: 'Connections',
                icon: Icons.people,
                onPressed: () => onItemPressed(context, index: 1),
              ),
              SizedBox(
                height: Get.height * 0.03,
              ),
              DrawerItem(
                  name: 'Profile',
                  icon: Icons.manage_accounts,
                  onPressed: () => onItemPressed(context, index: 2)),
              SizedBox(
                height: Get.height * 0.03,
              ),
              const Divider(
                thickness: 1,
                height: 10,
                color: Colors.grey,
              ),
              SizedBox(
                height: Get.height * 0.03,
              ),
              DrawerItem(
                  name: 'Setting',
                  icon: Icons.settings,
                  onPressed: () => onItemPressed(context, index: 3)),
              SizedBox(
                height: Get.height * 0.03,
              ),
              DrawerItem(
                  name: 'Log out',
                  icon: Icons.logout,
                  onPressed: () => onItemPressed(context, index: 4)),
            ],
          ),
        ),
      ),
    );
  }

  void onItemPressed(BuildContext context, {required int index}) {
    final sp = context.read<SignInProvider>();
    Navigator.pop(context);

    switch (index) {
      case 0:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const NearbyConnect()));
        break;
      case 1:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const Connections()));
        break;
      case 2:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const Profile()));
        break;

      // case 3:
      //   Navigator.push(
      //       context, MaterialPageRoute(builder: (context) => Nearby_test()));
      //   break;

      case 4:
        sp.userSignOut();
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
        break;
    }
  }

  Widget headerWidget() {
    final sp = context.read<SignInProvider>();
    final datacount = GetStorage();
    final fullname = datacount.read("fullname");
    final imageUrl = datacount.read("imageUrl");
    const url =
        'https://icon-library.com/images/avatar-icon-images/avatar-icon-images-4.jpg';
    return Container(
      child: Row(
        children: [
          CircleAvatar(
            radius: Get.height * 0.055,
            backgroundImage: NetworkImage(sp.imageUrl),
          ),
          SizedBox(
            width: Get.height * 0.03,
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(fullname,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black)),
                SizedBox(
                  height: 10,
                ),
                Text(sp.email!,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14, color: Colors.black))
              ],
            ),
          )
        ],
      ),
    );
  }
}

class People extends StatelessWidget {
  const People({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('People'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
    );
  }
}
