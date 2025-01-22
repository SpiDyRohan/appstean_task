import 'dart:async';

import 'package:appstean_test/main.dart';
import 'package:appstean_test/module/home/bloc/home_page_bloc.dart';
import 'package:appstean_test/module/home/bloc/home_page_event.dart';
import 'package:appstean_test/module/home/bloc/home_page_state.dart';
import 'package:appstean_test/module/home/model/user_response.dart';
import 'package:appstean_test/module/home/widgets/home_page_items.dart';
import 'package:appstean_test/module/home_details/home_details.dart';
import 'package:appstean_test/module/login/login_screen.dart';
import 'package:appstean_test/utility/app_constant.dart';
import 'package:appstean_test/utility/shared_preference.dart';
import 'package:appstean_test/utility/widgets/app_bar_widget.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<UserResponse> userList = [];
  List<UserResponse> searchList = [];
  StreamSubscription<List<ConnectivityResult>>? subscription;
  bool isInternetConnected = true;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    getConnectionStatus();
    getUser();
    super.initState();
  }

  @override
  void dispose() {
    subscription?.cancel();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => HomePageBloc()..add(GetListEvent()),
        child: BlocBuilder<HomePageBloc, HomePageState>(
          builder: (context, state) {
            if (state is HomeInitialState) {}
            if (state is HomeLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is HomeFailureState) {
              return Center(child: Text(state.msg));
            }
            if (state is GetListSuccessState) {
              userList.clear();
              userList.addAll(state.response);
            }
            return Scaffold(
              appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(80),
                  child: AppBarWidget(
                    title: AppConstants.home,
                    showBackBtn: false,
                    bottom: PreferredSize(
                      preferredSize: const Size.fromHeight(40),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                isInternetConnected
                                    ? "You're online!"
                                    : "No internet connection",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isInternetConnected
                                      ? Colors.greenAccent
                                      : Colors.redAccent,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                await SharedPrefer.instance.clearAllData();
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => const LoginScreen()),
                                    (route) => false);
                              },
                              child: const Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  "Log Out",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )),
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 4),
                    child: TextFormField(
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: "Search Here",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.black)),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding:
                              const EdgeInsets.fromLTRB(16, 0, 0, 0)),
                      controller: searchController,
                      onChanged: (value) {
                        onSearchQuery(value.trim().toLowerCase());
                      },
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: searchController.text.isNotEmpty
                            ? searchList.length
                            : userList.length,
                        itemBuilder: (context, index) {
                          return searchList.isNotEmpty ||
                                  searchController.text.isNotEmpty
                              ? GestureDetector(
                                  onTap: () async {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => HomeDetails(
                                                  userDetails:
                                                      searchList[index],
                                                )));
                                  },
                                  child: HomePageItems(
                                      userList: searchList[index]))
                              : GestureDetector(
                                  onTap: () async {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => HomeDetails(
                                                  userDetails: userList[index],
                                                )));
                                  },
                                  child:
                                      HomePageItems(userList: userList[index]));
                        }),
                  ),
                ],
              ),
            );
          },
        ));
  }

  getUser() async {
    final List<Map<String, Object?>> queryResult = await dbHelper.getUser();
    debugPrint("QUERY-RESULT--->$queryResult");
  }

  getConnectionStatus() {
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) async {
      bool isConnected = await InternetConnection().hasInternetAccess;
      setState(() {
        isInternetConnected = isConnected;
      });
    });
  }

  onSearchQuery(txt) {
    searchList.clear();
    for (var element in userList) {
      if (element.name.toLowerCase().contains(txt) ||
          element.username.toLowerCase().contains(txt) ||
          element.email.toLowerCase().contains(txt)) {
        debugPrint("element:$element");
        searchList.add(element);
      }
    }
    setState(() {});
  }
}
