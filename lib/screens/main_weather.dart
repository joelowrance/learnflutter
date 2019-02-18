import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_weather/bloc/theme_bloc.dart';
import 'package:simple_weather/bloc/weather_bloc.dart';
import 'package:simple_weather/screens/city_selection.dart';
import 'package:simple_weather/screens/gradient.dart';
import 'package:simple_weather/screens/last_updated.dart';
import 'package:simple_weather/screens/location.dart';
import 'package:simple_weather/screens/weather_temp.dart';
import 'package:simple_weather/services/weather_repo.dart';

class Weather extends StatefulWidget {
  final WeatherRepository repo;

  Weather({Key key, @required this.repo})
      : assert(repo != null),
        super(key: key);

  State<Weather> createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {
  WeatherBloc _weatherBloc;
  Completer<void> _refreshCompleter;

  @override
  void initState() {
    super.initState();
    _weatherBloc = WeatherBloc(repo: widget.repo);
    _refreshCompleter = Completer<void>();
  }

  @override
  Widget build(BuildContext cx) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Simple Weather"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () async {
                final city = await Navigator.push(context, MaterialPageRoute(builder: (cx) => CitySelection()));

                if (city != null) {
                  _weatherBloc.dispatch(FetchWeather(city: city));
                }
              },
            )
          ],
        ),
        body: Center(
            child: BlocBuilder(
          bloc: _weatherBloc,
          builder: (_, WeatherState state) {
            if (state is WeatherEmpty) {
              return Center(child: Text('Select a location'));
            }
            if (state is WeatherLoading) {
              return Center(child: CircularProgressIndicator());
            }

            if (state is WeatherError) {
              return Text('Ooops!', style: TextStyle(color: Colors.red));
            }
            if (state is WeatherLoaded) {
              final weather = state.weather;
              final themeBloc = BlocProvider.of<ThemeBloc>(context);
              themeBloc.dispatch(WeatherChanged(condition: weather.condition));

              _refreshCompleter?.complete();
              _refreshCompleter = Completer();

              return BlocBuilder(
                  bloc: themeBloc,
                  builder: (_, ThemeState themeState) {
                    return GradientContainer(
                        color: themeState.color,
                        child: RefreshIndicator(
                            onRefresh: () {
                              _weatherBloc.dispatch(RefreshWeather(city: state.weather.location));
                              return _refreshCompleter.future;
                            },
                            child: ListView(children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.only(top: 100),
                                  child: Center(child: Location(location: weather.location))),
                              Center(child: LastUpdated(dateTime: weather.lastUpdated)),
                              Padding(
                                  padding: EdgeInsets.symmetric(vertical: 50),
                                  child: Center(child: CombinedWeatherTemp(weather: weather)))
                            ])));
                  });
            }
          },
        )));
  }
}
