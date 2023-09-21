import 'package:weather/weather.dart';

class WeatherService {
  static final String apiKey = "xxx";

  WeatherService.I() {
    weatherStation = new WeatherFactory(apiKey);
  }

  late WeatherFactory weatherStation;

  Future<WeatherInfo> getWeather(double lat, double lon) async {
    Weather weather = await weatherStation.currentWeatherByLocation(lat, lon);
    return WeatherInfo(weather.weatherIcon, weather.temperature?.celsius);
  }
}

class WeatherInfo {
  String? weatherIcon;
  double? temperature;

  WeatherInfo(String? weatherIcon, this.temperature) {
    this.weatherIcon = translateIcon(weatherIcon);
  }

  String translateIcon(String? weatherIcon) {
    switch(weatherIcon) {
      case '01d': return 'wi-day-sunny';
      case '01n': return 'wi-night-clear';
      case '02d': return 'wi-day-cloudy';
      case '02n': return 'wi-night-alt-cloudy';
      case '03d': return 'wi-day-cloudy';
      case '03n': return 'wi-night-alt-cloudy';
      case '04d': return 'wi-day-cloudy';
      case '04n': return 'wi-night-alt-cloudy';
      case '05d': return 'wi-day-cloudy';
      case '05n': return 'wi-night-alt-cloudy';
      case '09d': return 'wi-day-rain';
      case '09n': return 'wi-night-alt-rain';
      case '10d': return 'wi-day-rain';
      case '10n': return 'wi-night-alt-rain';
      case '11d': return 'wi-day-thunderstorm';
      case '11n': return 'wi-night-alt-thunderstorm';
      case '13d': return 'wi-day-snow';
      case '13n': return 'wi-night-alt-snow';
      case '50d': return 'wi-day-fog';
      case '50n': return 'wi-night-fog';
      default: print(weatherIcon); return 'wi-na';
    }
  }

}

