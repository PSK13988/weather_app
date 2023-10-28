import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../provider/weather_provider.dart';
import '../widgets/weather_info.dart';
import '../widgets/fade_in.dart';
import '../widgets/hourly_forecast.dart';
import '../widgets/location_error.dart';
import '../widgets/main_weather.dart';
import '../widgets/request_error.dart';
import '../widgets/search_app_bar.dart';
import '../widgets/weather_detail.dart';
import '../widgets/seven_day_forecast.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/homeScreen';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  Future<void> _getData() async {
    _isLoading = true;
    final weatherData = Provider.of<WeatherProvider>(context, listen: false);
    weatherData.getWeatherData(context);
    _isLoading = false;
  }

  Future<void> _refreshData(BuildContext context) async {
    await Provider.of<WeatherProvider>(context, listen: false)
        .getWeatherData(context, isRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    final themeContext = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Consumer<WeatherProvider>(
          builder: (context, weatherProv, _) {
            if (weatherProv.isRequestError) return const RequestError();
            if (weatherProv.isLocationError) return const LocationError();
            return Column(
              children: [
                const SearchAppBar(),
                Center(
                  child: SmoothPageIndicator(
                    controller: _pageController,
                    count: 2,
                    effect: ExpandingDotsEffect(
                      activeDotColor: themeContext.primaryColor,
                      dotHeight: 6,
                      dotWidth: 6,
                    ),
                  ),
                ),
                _isLoading || weatherProv.isLoading
                    ? Expanded(
                        child: Center(
                          child: CircularProgressIndicator(
                            backgroundColor: themeContext.primaryColor,
                            color: Colors.white,
                          ),
                        ),
                      )
                    : Expanded(
                        child: PageView(
                          physics: const BouncingScrollPhysics(),
                          controller: _pageController,
                          children: [
                            // First Page of the Page View
                            RefreshIndicator(
                              onRefresh: () async => _refreshData(context),
                              child: ListView(
                                padding: const EdgeInsets.all(10),
                                shrinkWrap: true,
                                children: [
                                  FadeIn(
                                    curve: Curves.easeIn,
                                    duration: const Duration(milliseconds: 250),
                                    child: MainWeather(),
                                  ),
                                  const FadeIn(
                                    curve: Curves.easeIn,
                                    duration: Duration(milliseconds: 500),
                                    child: WeatherInfo(),
                                  ),
                                  const FadeIn(
                                    curve: Curves.easeIn,
                                    duration: Duration(milliseconds: 750),
                                    child: HourlyForecast(),
                                  ),
                                ],
                              ),
                            ),
                            // Second Page of the Page View
                            ListView(
                              padding: const EdgeInsets.all(10),
                              children: const [
                                FadeIn(
                                  curve: Curves.easeIn,
                                  duration: Duration(milliseconds: 250),
                                  child: SevenDayForecast(),
                                ),
                                SizedBox(height: 16.0),
                                FadeIn(
                                  curve: Curves.easeIn,
                                  duration: Duration(milliseconds: 500),
                                  child: WeatherDetail(),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
              ],
            );
          },
        ),
      ),
    );
  }
}
