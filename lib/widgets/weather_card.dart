import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';

class Weather {
  final String? city;
  final String? description;
  final double temperature;
  final int humidity;
  final double windSpeed;
  final int pressure;
  final int visibility;
  final DateTime? sunrise;
  final DateTime? sunset;

  Weather({
    this.city,
    this.description,
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.pressure,
    required this.visibility,
    this.sunrise,
    this.sunset,
  });
}

class WeatherCard extends StatelessWidget {
  final Weather weather;
  final String lottieAsset;

  const WeatherCard({
    super.key,
    required this.weather,
    required this.lottieAsset,
  });

  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) return '--:--';
    return DateFormat.jm().format(dateTime);
  }

  Widget _infoItem(String label, String value, IconData icon) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 150),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.18),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white70, size: 32, semanticLabel: label),
            const SizedBox(height: 10),
            Text(label,
                style: const TextStyle(color: Colors.white70, fontSize: 16)),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
      color: Colors.white.withOpacity(0.28),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset(
              lottieAsset,
              height: 160,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.error,
                size: 64,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              weather.city ?? 'Unknown City',
              style: GoogleFonts.roboto(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              weather.description ?? 'No description',
              style: const TextStyle(
                fontSize: 24,
                color: Colors.white70,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '${weather.temperature.toStringAsFixed(1)} °C',
              style: const TextStyle(
                fontSize: 64,
                color: Colors.white,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 40),
            Wrap(
              spacing: 20,
              runSpacing: 20,
              alignment: WrapAlignment.center,
              children: [
                _infoItem('Humidity', '${weather.humidity}%', Icons.water_drop),
                _infoItem('Wind', '${weather.windSpeed} m/s', Icons.air),
                _infoItem('Pressure', '${weather.pressure} hPa', Icons.speed),
                _infoItem('Visibility', '${weather.visibility} m',
                    Icons.remove_red_eye),
                _infoItem(
                    'Sunrise', _formatTime(weather.sunrise), Icons.wb_twilight),
                _infoItem('Sunset', _formatTime(weather.sunset),
                    Icons.nightlight_round),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
