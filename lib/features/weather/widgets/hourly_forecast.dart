import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weather_sample_app/features/weather/Screens/hourly_screen.dart';
import 'package:weather_sample_app/features/weather/provider/weather_provider.dart';
import 'package:weather_sample_app/features/weather/utils/utils.dart';

class HourlyForecast extends StatelessWidget {
  const HourlyForecast({super.key});

  Widget hourlyWidget(dynamic weather, BuildContext context) {
    final currentTime = weather.date;
    final hours = DateFormat.Hm().format(currentTime);

    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    hours,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  MapString.mapStringToIcon(
                    '${weather.condition}',
                    50,
                  ),
                  SizedBox(
                    width: 80,
                    child: Text(
                      "${weather.dailyTemp.toStringAsFixed(1)}°C",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Next 3 Hours',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
              ),
              TextButton(
                child: const Text(
                  'See More',
                  style: TextStyle(color: Colors.blue),
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(HourlyScreen.routeName);
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        Consumer<WeatherProvider>(builder: (context, weatherProv, _) {
          return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: weatherProv.hourlyWeather
                  .map((item) => hourlyWidget(item, context))
                  .toList());
        }),
      ],
    );
  }
}
