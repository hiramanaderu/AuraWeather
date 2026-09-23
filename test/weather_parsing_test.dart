import 'package:flutter_test/flutter_test.dart';
import 'package:weather_assistant/utils/weather_parsing.dart';

void main() {
  test('current temperature rejects ranges and missing values', () {
    expect(parseWeatherTemperature('-5.5℃'), -5.5);
    expect(parseWeatherTemperature('20~15'), isNull);
    expect(parseWeatherTemperature('暂无'), isNull);
  });
  test('forecast ranges preserve negative temperatures', () {
    expect(parseWeatherTemperatureRange('-5~-10'), [-5, -10]);
    expect(parseWeatherTemperatureRange('20℃-15℃'), [20, 15]);
    expect(parseWeatherTemperatureRange('15/20'), [20, 15]);
    expect(parseWeatherTemperatureRange('-5--10'), [-5, -10]);
    expect(parseWeatherTemperatureRange('未知'), isNull);
  });
}
