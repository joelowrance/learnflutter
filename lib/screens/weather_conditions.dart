import 'package:flutter/material.dart';
import 'package:simple_weather/models/weather.dart' as models;

class WeatherConditions extends StatelessWidget {
  final models.WeatherCondition condition;

  WeatherConditions({Key key, @required this.condition})
      : assert(condition != null),
        super(key: key);

  @override
  Widget build(BuildContext context) => _mapConditionToImage(condition);

  Image _mapConditionToImage(models.WeatherCondition condition) {
    Image image;
    switch (condition) {
      case models.WeatherCondition.clear:
      case models.WeatherCondition.lightCloud:
        image = Image.asset('assets/clear.png');
        break;
      case models.WeatherCondition.hail:
      case models.WeatherCondition.snow:
      case models.WeatherCondition.sleet:
        image = Image.asset('assets/snow.png');
        break;
      case models.WeatherCondition.heavyCloud:
        image = Image.asset('assets/cloudy.png');
        break;
      case models.WeatherCondition.heavyRain:
      case models.WeatherCondition.lightRain:
      case models.WeatherCondition.showers:
        image = Image.asset('assets/rainy.png');
        break;
      case models.WeatherCondition.thunderstorm:
        image = Image.asset('assets/thunderstorm.png');
        break;
      case models.WeatherCondition.unknown:
        image = Image.asset('assets/clear.png');
        break;
    }
    return image;
  }
}
