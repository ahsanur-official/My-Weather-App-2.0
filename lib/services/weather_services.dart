import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myapp/models/weather_model.dart';

class WeatherServices {
  final String apiKey = '1695da0ffb036e82360dda8d7f0deb9c'; // Your OpenWeatherMap API key

  Future<Weather> fetchWeather(String cityName) async {
    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName&units=metric&appid=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Weather.fromJson(data);
    } else {
      final error = json.decode(response.body)['message'] ?? 'Unknown error';
      throw Exception('Failed to load weather: $error');
    }
  }

  Future<List<Weather>> fetch7DayForecast(double lat, double lon) async {
    final url =
        'https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$lon&exclude=current,minutely,hourly,alerts&units=metric&appid=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List dailyData = data['daily'];
      final List<Weather> forecast = [];

      for (int i = 0; i < 7 && i < dailyData.length; i++) {
        forecast.add(Weather.fromDailyJson(dailyData[i]));
      }

      return forecast;
    } else {
      final error = json.decode(response.body)['message'] ?? 'Unknown error';
      throw Exception('Failed to load forecast: $error');
    }
  }
}
