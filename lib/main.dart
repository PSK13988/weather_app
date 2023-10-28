import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_sample_app/features/weather/Screens/home_screen.dart';
import 'package:weather_sample_app/features/weather/Screens/hourly_screen.dart';
import 'package:weather_sample_app/features/weather/Screens/weekly_screen.dart';
import 'package:weather_sample_app/features/weather/api/weather_api.dart';
import 'package:weather_sample_app/features/weather/location/location_manger.dart';
import 'package:weather_sample_app/features/weather/provider/weather_provider.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WeatherProvider(WeatherApi(), LocationManager()),
      child: MaterialApp(
        title: 'Flutter Weather',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            iconTheme: IconThemeData(
              color: Colors.blue,
            ),
            elevation: 0,
          ),
          scaffoldBackgroundColor: Colors.white,
          primaryColor: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          colorScheme:
              ColorScheme.fromSwatch().copyWith(secondary: Colors.white),
        ),
        home: const HomeScreen(),
        routes: {
          WeeklyScreen.routeName: (context) => const WeeklyScreen(),
          HourlyScreen.routeName: (context) => const HourlyScreen(),
        },
      ),
    );
  }
}
