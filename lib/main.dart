import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:simple_weather/bloc/theme_bloc.dart';
import 'package:simple_weather/bloc/weather_bloc.dart';
import 'package:simple_weather/screens/main_weather.dart';
import 'package:simple_weather/services/weather_api.dart';
import 'package:simple_weather/services/weather_repo.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  BlocSupervisor().delegate = SimpleBlocDelegate();
  final repo = WeatherRepository(weatherApiClient: WeatherApi(httpClient: http.Client()));

  runApp(App(repo: repo));
}

class App extends StatefulWidget {
  final WeatherRepository repo;

  App({Key key, @required this.repo})
      : assert(repo != null),
        super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  ThemeBloc _themeBloc = ThemeBloc();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: _themeBloc,
      child: BlocBuilder(
        bloc: _themeBloc,
        builder: (_, ThemeState themeState) {
          return MaterialApp(
            title: 'Simple Weather',
            theme: themeState.theme,
            home: Weather(
              repo: widget.repo,
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _themeBloc.dispose();
    super.dispose();
  }
}
