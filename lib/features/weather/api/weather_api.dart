import 'dart:convert';
import 'dart:developer';

import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:weather_sample_app/features/weather/api/api_key.dart';

import '../models/weather.dart';

class WeatherApi {
  static const String baseURL = 'api.openweathermap.org';
  static const String getWeatherByLatLong = 'data/2.5/weather';
  static const String getForecasting = 'data/2.5/onecall';
  static const String apiKey = ApiKey.apiKey;

  Future<(String?, Weather?)> getCurrentWeather(LatLng location) async {
    Map<String, String> params = {
      'lat': location.latitude.toString(),
      'lon': location.longitude.toString(),
      'appid': apiKey,
      'units': 'metric'
    };

    try {
      final response =
          await http.get(Uri.https(baseURL, getWeatherByLatLong, params));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      return (null, Weather.fromJson(extractedData));
    } catch (error) {
      return (error.toString(), null);
    }
  }

  Future<(String?, Map<String, dynamic>?)> getDailyWeather(
      LatLng location) async {
    Map<String, String> params = {
      'lat': location.latitude.toString(),
      'lon': location.longitude.toString(),
      'appid': apiKey,
      'units': 'metric',
      'exclude': 'minutely,current',
    };

    try {
      final response =
          await http.get(Uri.https(baseURL, getForecasting, params));
      inspect(response.body);
      final dailyData = json.decode(response.body) as Map<String, dynamic>;
      return (null, dailyData);
    } catch (error) {
      return (error.toString(), null);
    }
  }

  Future<(String?, Weather?)> searchWeatherWithLocation(String location) async {
    Map<String, String> params = {
      'q': location,
      'appid': apiKey,
      'units': 'metric',
    };

    try {
      final response =
          await http.get(Uri.https(baseURL, getWeatherByLatLong, params));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      return (null, Weather.fromJson(extractedData));
    } catch (error) {
      return (error.toString(), null);
    }
  }
}
