import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'views/login_page.dart';
import 'views/register.dart';
import 'views/home_page.dart';
import 'views/vehicle_page.dart';
import 'viewmodels/parking_duration_view_model.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ParkingDetailsViewModel()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ParkingApp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SignPage(),
        '/signup': (context) => registerPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/home') {
          final int userId = settings.arguments as int;
          return MaterialPageRoute(
            builder: (context) => HomePage(userId: userId),
          );
        }
        if (settings.name == '/vehicles') {
          final int userId = settings.arguments as int;
          return MaterialPageRoute(
            builder: (context) => VehiclePage(userId: userId),
          );
        }
        return null; // Let `MaterialApp` handle unknown routes
      },
    );
  }
}
