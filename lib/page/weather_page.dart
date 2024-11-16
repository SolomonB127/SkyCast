import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sky_cast/models/weather_model.dart';
import 'package:sky_cast/services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // api key
  final _weatherService = WeatherService("1e1d08c33476f2743f8403b30a7401ea");
  Weather? _weather;

  // fetch weather
  _fetchWeather() async {
    // get the current city
    String cityName = await _weatherService.getLocation();

    // get weather for city
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  // weather animations
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return "assets/sunny.json"; // sunny as default

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'dust':
      case 'fog':
      case 'haze':
      case 'smoke':
        return "assets/cloud.json";
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return "assets/rain.json";
      case 'thunder storm':
        return "assets/thunder.json";
      case 'clear':
        return "assets/sunny.json";
      default:
        return "assets/sunny.json";
    }
  }

  // init state
  @override
  void initState() {
    super.initState();

    //fetch wether on startup
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // city name
            Text(_weather?.cityName ?? "Loading city..."),

            // animations
            LottieBuilder.asset(getWeatherAnimation(_weather?.mainCondition)),

            // temperature
            Text("${_weather?.temperature.round()}"),

            // weather condition
            Text(_weather?.mainCondition ?? "")
          ]),
    ));
  }
}
