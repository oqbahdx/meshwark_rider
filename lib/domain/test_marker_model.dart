import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class TestMarkerModel {
  List<Offices>? offices;
  List<Regions>? regions;

  TestMarkerModel({this.offices, this.regions});

  TestMarkerModel.fromJson(Map<String, dynamic> json) {
    if (json['offices'] != null) {
      offices = <Offices>[];
      json['offices'].forEach((v) {
        offices!.add(Offices.fromJson(v));
      });
    }
    if (json['regions'] != null) {
      regions = <Regions>[];
      json['regions'].forEach((v) {
        regions!.add(Regions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (offices != null) {
      data['offices'] = offices!.map((v) => v.toJson()).toList();
    }
    if (regions != null) {
      data['regions'] = regions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
Future<TestMarkerModel> getGoogleOffices() async {
  const googleLocationsURL = 'https://about.google/static/data/locations.json';
  // Retrieve the locations of Google offices
  final response = await http.get(Uri.parse(googleLocationsURL));
  if (response.statusCode == 200) {
    return TestMarkerModel.fromJson(json.decode(response.body));
  } else {
    throw HttpException(
        'Unexpected status code ${response.statusCode}:'
            ' ${response.reasonPhrase}',
        uri: Uri.parse(googleLocationsURL));
  }
}

class Offices {
  String? address;
  String? id;
  String? image;
  double? lat;
  double? lng;
  String? name;
  String? phone;
  String? region;

  Offices(
      {this.address,
        this.id,
        this.image,
        this.lat,
        this.lng,
        this.name,
        this.phone,
        this.region});

  Offices.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    id = json['id'];
    image = json['image'];
    lat = json['lat'];
    lng = json['lng'];
    name = json['name'];
    phone = json['phone'];
    region = json['region'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['address'] = address;
    data['id'] = id;
    data['image'] = image;
    data['lat'] = lat;
    data['lng'] = lng;
    data['name'] = name;
    data['phone'] = phone;
    data['region'] = region;
    return data;
  }
}

class Regions {
  Coords? coords;
  String? id;
  String? name;
  double? zoom;

  Regions({this.coords, this.id, this.name, this.zoom});

  Regions.fromJson(Map<String, dynamic> json) {
    coords =
    json['coords'] != null ? Coords.fromJson(json['coords']) : null;
    id = json['id'];
    name = json['name'];
    zoom = json['zoom'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (coords != null) {
      data['coords'] = coords!.toJson();
    }
    data['id'] = id;
    data['name'] = name;
    data['zoom'] = zoom;
    return data;
  }
}

class Coords {
  double? lat;
  double? lng;

  Coords({this.lat, this.lng});

  Coords.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lat'] = lat;
    data['lng'] = lng;
    return data;
  }
}
