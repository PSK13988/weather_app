import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:weather_sample_app/features/weather/api/weather_api.dart';
import 'package:weather_sample_app/features/weather/location/location_manger.dart';

import '../models/daily_weather.dart';
import '../models/weather.dart';

class WeatherProvider with ChangeNotifier {
  WeatherProvider(this._weatherApi, this._locationManager);
  final WeatherApi _weatherApi;
  final LocationManager _locationManager;

  LatLng? currentLocation;
  Weather? weather;
  DailyWeather currentWeather = DailyWeather();
  List<DailyWeather> hourlyWeather = [];
  List<DailyWeather> hourly24Weather = [];
  List<DailyWeather> fiveDayWeather = [];
  List<DailyWeather> sevenDayWeather = [];
  bool isLoading = false;
  bool isRequestError = false;
  bool isLocationError = false;

  Future<void> getWeatherData(
    BuildContext context, {
    bool isRefresh = false,
  }) async {
    isLoading = true;
    isRequestError = false;
    isLocationError = false;
    if (isRefresh) notifyListeners();

    Position? locData = await _locationManager.requestLocation(context);
    if (locData == null) {
      isLocationError = true;
      notifyListeners();
      return;
    }

    try {
      currentLocation = LatLng(locData.latitude, locData.longitude);
      await getCurrentWeather(currentLocation!);
      await getDailyWeather(currentLocation!);
    } catch (e) {
      debugPrint(e.toString());
      isLocationError = true;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getCurrentWeather(LatLng location) async {
    try {
      final response = await _weatherApi.getCurrentWeather(location);
      weather = response.$2;
    } catch (error) {
      debugPrint(error.toString());
      isLoading = false;
      isRequestError = true;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getDailyWeather(LatLng location) async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await _weatherApi.getDailyWeather(location);
      final dailyData = response.$2;
      currentWeather = DailyWeather.fromJson(dailyData!);
      List items = dailyData['daily'];
      List itemsHourly = dailyData['hourly'];
      hourlyWeather = itemsHourly
          .map((item) => DailyWeather.fromHourlyJson(item))
          .toList()
          .skip(1)
          .take(3)
          .toList();
      hourly24Weather = itemsHourly
          .map((item) => DailyWeather.fromHourlyJson(item))
          .toList()
          .skip(1)
          .take(24)
          .toList();
      sevenDayWeather = items
          .map((item) => DailyWeather.fromDailyJson(item))
          .toList()
          .skip(1)
          .take(7)
          .toList();
    } catch (error) {
      debugPrint(error.toString());
      isRequestError = true;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchWeatherWithLocation(String location) async {
    try {
      final response = await _weatherApi.searchWeatherWithLocation(location);
      weather = response.$2;
    } catch (error) {
      debugPrint(error.toString());
      isRequestError = true;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchWeather(String location) async {
    isLoading = true;
    notifyListeners();
    isRequestError = false;
    isLocationError = false;
    await searchWeatherWithLocation(location);
    if (weather == null) {
      isRequestError = true;
      notifyListeners();
      return;
    }
    await getDailyWeather(LatLng(weather!.lat, weather!.long));
  }
}
