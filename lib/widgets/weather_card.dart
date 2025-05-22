import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:myapp/models/weather_model.dart';

class WeatherCard extends StatelessWidget {
  final Weather weather;
  const WeatherCard({super.key, required this.weather});

  // Format DateTime into readable time string
  String formatTime(DateTime time) => DateFormat('hh:mm a').format(time);

  // Select Lottie animation based on weather description
  String getLottieAsset(String description) {
    final desc = description.toLowerCase();
    if (desc.contains('rain')) return 'assets/rain.json';
    if (desc.contains('clear')) return 'assets/sunny.json';
    if (desc.contains('cloud')) return 'assets/cloudy.json';
    if (desc.contains('snow')) return 'assets/snowfall.json';
    return 'assets/cloudy.json';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(
          0.2,
        ), // Adjust for better contrast if needed
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Lottie.asset(
            getLottieAsset(weather.description),
            height: 150,
            width: 150,
            fit: BoxFit.cover,
          ),
          Text(
            '${weather.cityName}, ${weather.country}',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '${weather.temperature.toStringAsFixed(1)}°C',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            'Feels like: ${weather.feelsLike.toStringAsFixed(1)}°C',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 10),
          Text(
            weather.description[0].toUpperCase() +
                weather.description.substring(1),
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _infoTile(
                'Humidity',
                '${weather.humidity}%',
                Icons.water_drop,
                Colors.cyanAccent,
              ),
              _infoTile(
                'Wind',
                '${weather.windSpeed} m/s',
                Icons.air,
                Colors.lightBlueAccent,
              ),
              _infoTile(
                'Pressure',
                '${weather.pressure} hPa',
                Icons.compress,
                Colors.orangeAccent,
              ),
            ],
          ),
          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _infoTile(
                'Sunrise',
                formatTime(weather.sunrise),
                Icons.wb_sunny,
                Colors.amber,
              ),
              _infoTile(
                'Sunset',
                formatTime(weather.sunset),
                Icons.nightlight_round,
                Colors.deepPurpleAccent,
              ),
            ],
          ),
          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.visibility, color: Colors.white70),
              const SizedBox(width: 8),
              Text(
                'Visibility: ${weather.visibility ~/ 1000} km',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoTile(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white70)),
        Text(value, style: const TextStyle(color: Colors.white)),
      ],
    );
  }
}
