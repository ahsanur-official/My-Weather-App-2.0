class Weather {
  final String cityName;
  final String country;
  final double temperature;
  final double feelsLike;
  final String description;
  final String iconCode;
  final int humidity;
  final int pressure;
  final double windSpeed;
  final int visibility;
  final DateTime sunrise;
  final DateTime sunset;
  final double latitude;
  final double longitude;

  // For forecast daily
  final int dateTimestamp;

  Weather({
    required this.cityName,
    required this.country,
    required this.temperature,
    required this.feelsLike,
    required this.description,
    required this.iconCode,
    required this.humidity,
    required this.pressure,
    required this.windSpeed,
    required this.visibility,
    required this.sunrise,
    required this.sunset,
    required this.latitude,
    required this.longitude,
    this.dateTimestamp = 0,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'] ?? '',
      country: json['sys'] != null ? json['sys']['country'] ?? '' : '',
      temperature: (json['main']['temp'] as num).toDouble(),
      feelsLike: (json['main']['feels_like'] as num).toDouble(),
      description: (json['weather'] != null && json['weather'].isNotEmpty)
          ? json['weather'][0]['description']
          : '',
      iconCode: (json['weather'] != null && json['weather'].isNotEmpty)
          ? json['weather'][0]['icon']
          : '',
      humidity: json['main']['humidity'],
      pressure: json['main']['pressure'],
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      visibility: json['visibility'] ?? 0,
      sunrise: DateTime.fromMillisecondsSinceEpoch(
              json['sys']['sunrise'] * 1000,
              isUtc: true)
          .toLocal(),
      sunset: DateTime.fromMillisecondsSinceEpoch(json['sys']['sunset'] * 1000,
              isUtc: true)
          .toLocal(),
      latitude: (json['coord']['lat'] as num).toDouble(),
      longitude: (json['coord']['lon'] as num).toDouble(),
      dateTimestamp: 0, // For current weather, no dateTimestamp
    );
  }

  factory Weather.fromDailyJson(Map<String, dynamic> json) {
    return Weather(
      cityName: '',
      country: '',
      temperature: (json['temp']['day'] as num).toDouble(),
      feelsLike: 0,
      description: json['weather'][0]['description'],
      iconCode: json['weather'][0]['icon'],
      humidity: json['humidity'],
      pressure: json['pressure'],
      windSpeed: (json['wind_speed'] as num).toDouble(),
      visibility: 0,
      sunrise: DateTime.fromMillisecondsSinceEpoch(json['sunrise'] * 1000),
      sunset: DateTime.fromMillisecondsSinceEpoch(json['sunset'] * 1000),
      latitude: 0,
      longitude: 0,
      dateTimestamp: json['dt'],
    );
  }

  String get iconUrl => "https://openweathermap.org/img/wn/$iconCode@2x.png";

  String formatTime(DateTime time) {
    return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
  }
}
