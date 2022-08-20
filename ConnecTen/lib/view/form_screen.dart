import 'package:connecten/view/profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/internet_provider.dart';
import '../provider/sign_in_provider.dart';
import '../utils/snack_bar.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({Key? key}) : super(key: key);

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  // Form key
  final _formKey = GlobalKey<FormState>();

  // Editing controller
  final TextEditingController nameController = new TextEditingController();
  final TextEditingController designationController =
      new TextEditingController();
  final TextEditingController bioController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final sp = context.read<SignInProvider>();

    // Name field
    final nameField = TextFormField(
      autofocus: false,
      controller: nameController,
      keyboardType: TextInputType.name,
      onSaved: (value) {
        nameController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.person),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Name",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    // Designation Field
    final designationField = TextFormField(
      autofocus: false,
      controller: designationController,
      keyboardType: TextInputType.text,
      onSaved: (value) {
        designationController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.work),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Designation",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    // Bio Field
    final bioField = TextFormField(
      autofocus: false,
      controller: bioController,
      keyboardType: TextInputType.text,
      onSaved: (value) {
        bioController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.school),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Bio",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    // Continue Button
    final continueButton = Material(
      elevation: 5,
      color: Color(0xff567DF4),
      borderRadius: BorderRadius.circular(30),
      child: MaterialButton(
        onPressed: () {
          handleForm(
            nameController.text,
            designationController.text,
            bioController.text,
          );
        },
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width * 0.5,
        child: Text(
          " Continue ",
          style: TextStyle(
            fontSize: 15,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 150,
                      child: sp.imageUrl == null
                          ? Image.asset("assets/animation.gif")
                          : CircleAvatar(
                              radius: 75,
                              backgroundImage: NetworkImage(sp.imageUrl),
                            ),
                    ),
                    SizedBox(
                      height: 45,
                    ),
                    nameField,
                    SizedBox(
                      height: 20,
                    ),
                    designationField,
                    SizedBox(
                      height: 20,
                    ),
                    bioField,
                    SizedBox(
                      height: 20,
                    ),
                    continueButton,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future handleForm(String name, String designation, String bio) async {
    final sp = context.read<SignInProvider>();
    final ip = context.read<InternetProvider>();
    await ip.checkInternetConnection();

    if (ip.hasInternet == false) {
      openSnackBar(
          context, "Check your Internet connection.", Colors.red.shade400);
    } else {
      await sp.setFormData(name, designation, bio).then((value) {
        sp.saveFormDataToFirestore().then((value) {
          sp.setFormDone().then((value) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Profile()));
          });
        });
      });
    }
  }
}
