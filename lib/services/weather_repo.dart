import 'package:meta/meta.dart';
import 'package:simple_weather/services/weather_api.dart';
import 'package:simple_weather/models/weather.dart';

// this seems like a pointless abstraction?
class WeatherRepository {
  final WeatherApi weatherApiClient;

  WeatherRepository({@required this.weatherApiClient})
      : assert(weatherApiClient != null);

  Future<Weather> getWeather(String city) async {
    final int locationId = await weatherApiClient.getLocationId(city);
    return await weatherApiClient.getWeather(locationId);
  }
}
