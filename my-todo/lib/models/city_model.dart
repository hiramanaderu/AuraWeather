import 'package:equatable/equatable.dart';

/// 城市数据模型
class City extends Equatable {
  final String code;
  final String name;
  final String province;
  final String? district;
  final double? longitude;
  final double? latitude;
  final bool isFavorite;
  final DateTime? addedTime;

  const City({
    required this.code,
    required this.name,
    required this.province,
    this.district,
    this.longitude,
    this.latitude,
    this.isFavorite = false,
    this.addedTime,
  });

  factory City.fromAmapJson(Map<String, dynamic> json) {
    return City(
      code: json['adcode'] ?? '',
      name: json['name'] ?? json['city'] ?? '',
      province: json['province'] ?? '',
      district: json['district'],
      longitude: json['longitude'] != null 
          ? double.tryParse(json['longitude'].toString()) 
          : null,
      latitude: json['latitude'] != null 
          ? double.tryParse(json['latitude'].toString()) 
          : null,
    );
  }

  factory City.fromQWeatherJson(Map<String, dynamic> json) {
    return City(
      code: json['id'] ?? '',
      name: json['name'] ?? '',
      province: json['adm1'] ?? '',
      district: json['adm2'],
      longitude: json['lon'] != null 
          ? double.tryParse(json['lon'].toString()) 
          : null,
      latitude: json['lat'] != null 
          ? double.tryParse(json['lat'].toString()) 
          : null,
    );
  }

  City copyWith({
    String? code,
    String? name,
    String? province,
    String? district,
    double? longitude,
    double? latitude,
    bool? isFavorite,
    DateTime? addedTime,
  }) => City(
    code: code ?? this.code,
    name: name ?? this.name,
    province: province ?? this.province,
    district: district ?? this.district,
    longitude: longitude ?? this.longitude,
    latitude: latitude ?? this.latitude,
    isFavorite: isFavorite ?? this.isFavorite,
    addedTime: addedTime ?? this.addedTime,
  );

  Map<String, dynamic> toJson() => {
    'code': code,
    'name': name,
    'province': province,
    'district': district,
    'longitude': longitude,
    'latitude': latitude,
    'isFavorite': isFavorite ? 1 : 0,
    'addedTime': addedTime?.millisecondsSinceEpoch,
  };

  factory City.fromJson(Map<String, dynamic> json) => City(
    code: json['code'] ?? '',
    name: json['name'] ?? '',
    province: json['province'] ?? '',
    district: json['district'],
    longitude: json['longitude'] != null 
        ? (json['longitude'] as num).toDouble() 
        : null,
    latitude: json['latitude'] != null 
        ? (json['latitude'] as num).toDouble() 
        : null,
    isFavorite: json['isFavorite'] == 1,
    addedTime: json['addedTime'] != null 
        ? DateTime.fromMillisecondsSinceEpoch(json['addedTime'] as int) 
        : null,
  );

  String get displayName => district != null ? '$name $district' : name;
  
  String get fullName => '$province $name';

  @override
  List<Object?> get props => [code, name, province, district, isFavorite];
}

/// 历史记录
class SearchHistory extends Equatable {
  final String cityCode;
  final String cityName;
  final DateTime searchTime;

  const SearchHistory({
    required this.cityCode,
    required this.cityName,
    required this.searchTime,
  });

  Map<String, dynamic> toJson() => {
    'cityCode': cityCode,
    'cityName': cityName,
    'searchTime': searchTime.millisecondsSinceEpoch,
  };

  factory SearchHistory.fromJson(Map<String, dynamic> json) => SearchHistory(
    cityCode: json['cityCode'] ?? '',
    cityName: json['cityName'] ?? '',
    searchTime: DateTime.fromMillisecondsSinceEpoch(json['searchTime'] as int),
  );

  @override
  List<Object?> get props => [cityCode, cityName, searchTime];
}
