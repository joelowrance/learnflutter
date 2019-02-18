import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:simple_weather/models/weather.dart';
import 'package:simple_weather/services/weather_repo.dart';

abstract class WeatherEvent extends Equatable {
  WeatherEvent([List props = const []]) : super(props);
}

class FetchWeather extends WeatherEvent {
  final String city;

  FetchWeather({@required this.city})
      : assert(city != null),
        super([city]);
}

class RefreshWeather extends WeatherEvent {
  final String city;

  RefreshWeather({@required this.city})
      : assert(city != null),
        super([city]);
}

abstract class WeatherState extends Equatable {
  WeatherState([List props = const []]) : super(props);
}

class WeatherEmpty extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherLoaded extends WeatherState {
  final Weather weather;

  WeatherLoaded({@required this.weather})
      : assert(weather != null),
        super([weather]);
}

class WeatherError extends WeatherState {}

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository repo;

  WeatherBloc({@required this.repo}) : assert(repo != null);

  @override
  WeatherState get initialState => WeatherEmpty();

  @override
  Stream<WeatherState> mapEventToState(
      WeatherState currentState, WeatherEvent event) async* {
    if (event is FetchWeather) {
      yield WeatherLoading();
      try {
        final Weather w = await repo.getWeather(event.city);
        yield WeatherLoaded(weather: w);
      } catch (_) {
        yield WeatherError();
      }
    }

    if (event is RefreshWeather) {
      try {
        final w = await repo.getWeather(event.city);
        yield WeatherLoaded(weather: w);
      } catch (_) {
        yield WeatherError();
      }
    }
  }
}

class SimpleBlocDelegate extends BlocDelegate {
  @override
  onTransition(Transition transition) {
    print(transition);
  }
}
