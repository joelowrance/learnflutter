import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import '../models/weather.dart';

class WeatherApi {
  static const baseUrl = "https://www.metaweather.com";
  final http.Client httpClient;

  WeatherApi({@required this.httpClient}) : assert(httpClient != null);

  Future<int> getLocationId(String city) async {
    final url = '$baseUrl/api/location/search?query=$city';
    final response = await this.httpClient.get(url);

    if (response.statusCode != 200) {
      throw Exception('error getting info: ${response.statusCode}');
    }

    final json = jsonDecode(response.body) as List;
    return (json.first)['woeid'];
  }

  Future<Weather> getWeather(int locationId) async {
    final url = '$baseUrl/api/location/$locationId';
    final response = await this.httpClient.get(url);

    if (response.statusCode != 200) {
      throw Exception('error getting for locaiton: ${response.statusCode}');
    }

    final json = jsonDecode(response.body);
    return Weather.fromJson(json);
  }
}
