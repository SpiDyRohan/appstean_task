import 'package:appstean_test/database/my_db_helper.dart';
import 'package:appstean_test/module/splash/splash_screen.dart';
import 'package:appstean_test/repository/api_repository.dart';
import 'package:appstean_test/utility/shared_preference.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

ApiRepository repository = ApiRepository();
MyDBHelper dbHelper = MyDBHelper.instance;
BaseOptions options = BaseOptions(
  baseUrl: 'https://jsonplaceholder.typicode.com',
  connectTimeout: const Duration(seconds: 30),
  receiveTimeout: const Duration(seconds: 30),
  headers: {
    'Accept': 'application/json',
  },
);

Dio dio = Dio(options);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  dio.interceptors.add(PrettyDioLogger());
  await SharedPrefer.instance.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: false,
      ),
      home: const SplashScreen(),
    );
  }
}
