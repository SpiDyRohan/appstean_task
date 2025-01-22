import 'package:appstean_test/main.dart';
import 'package:appstean_test/utility/app_constant.dart';
import 'package:appstean_test/utility/widgets/app_bar_widget.dart';
import 'package:appstean_test/utility/widgets/custom_button.dart';
import 'package:appstean_test/utility/widgets/custom_field.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController nameController = TextEditingController();

  TextEditingController userNameController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: AppBarWidget(
            title: AppConstants.signUp,
            showBackBtn: true,
          )),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            AppConstants.appName,
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: CustomField(
              controller: nameController,
              keyboardType: TextInputType.text,
              hintTxt: AppConstants.enterName,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: CustomField(
              controller: userNameController,
              keyboardType: TextInputType.text,
              hintTxt: AppConstants.enterUserName,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: CustomField(
              controller: passwordController,
              keyboardType: TextInputType.visiblePassword,
              hintTxt: AppConstants.enterPassword,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  txt: AppConstants.signUp,
                  onPress: () {
                    onSignUp();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  onSignUp() async {
    if (nameController.text.trim().isEmpty) {
      return showErrorMsg("Alert!", "Please Enter Valid Name");
    }

    if (userNameController.text.trim().isEmpty) {
      return showErrorMsg("Alert!", "Please Enter Valid User Name");
    }

    if (passwordController.text.trim().isEmpty) {
      return showErrorMsg("Alert!", "Please Enter Valid Password");
    }

    Map<String, dynamic> input = {
      "userName": userNameController.text.trim(),
      "password": passwordController.text.trim()
    };
    var result =
        await dbHelper.checkExistingUser(userNameController.text.trim());
    if (result) {
      showErrorMsg("Alert", "User Already Exists!");
    } else {
      await dbHelper.saveUser(input).whenComplete(() => Navigator.pop(context));
    }
  }

  showErrorMsg(title, message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
