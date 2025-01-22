import 'package:appstean_test/module/home/model/user_response.dart';
import 'package:appstean_test/utility/widgets/app_bar_widget.dart';
import 'package:flutter/material.dart';

class HomeDetails extends StatelessWidget {
  final UserResponse userDetails;

  const HomeDetails({super.key, required this.userDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: AppBarWidget(title: "Home Detail", showBackBtn: true)),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
                border: Border.all(color: Colors.black)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                userDetailWidget(userdetail: "Name: ${userDetails.name}"),
                userDetailWidget(
                    userdetail: "User Name: ${userDetails.username}"),
                userDetailWidget(userdetail: "Email: ${userDetails.email}"),
                userDetailWidget(userdetail: "Phone: ${userDetails.phone}"),
                userDetailWidget(userdetail: "Website: ${userDetails.email}"),
                Row(
                  children: [
                    Expanded(
                        child: userDetailWidget(
                            userdetail:
                                "Address: ${userDetails.address.suite} ${userDetails.address.street} ${userDetails.address.city}")),
                  ],
                ),
                userDetailWidget(
                    userdetail: "Zipcode: ${userDetails.address.zipcode}"),
                userDetailWidget(
                    userdetail: "Company: ${userDetails.company.name}"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget userDetailWidget({required String userdetail}) {
    return Text(userdetail);
  }
}
