/// Parse a single observed temperature without inventing missing values.
double? parseWeatherTemperature(String text) {
  final match = RegExp(r'^\s*(-?\d+(?:\.\d+)?)\s*(?:℃|°C|°)?\s*$').firstMatch(text);
  return match == null ? null : double.tryParse(match.group(1)!);
}

/// Return [maximum, minimum], preserving signs for subzero forecasts.
List<double>? parseWeatherTemperatureRange(String text) {
  final match = RegExp(r'^\s*(-?\d+(?:\.\d+)?)\s*(?:℃|°C|°)?\s*(?:~|～|至|到|/|,|-)\s*(-?\d+(?:\.\d+)?)\s*(?:℃|°C|°)?\s*$').firstMatch(text);
  if (match == null) return null;
  final a = double.parse(match.group(1)!);
  final b = double.parse(match.group(2)!);
  return a >= b ? [a, b] : [b, a];
}
