import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

Map<String, dynamic> locationItems = {};

Future<Position> getUserCurrentLocation() async {
  LocationPermission locationPermission;
  Position position;

  try {
    if (!(await Geolocator.isLocationServiceEnabled())) {
      return Future.error(
          "Location service is disabled. Open settings and enable it");
    }

    locationPermission = await Geolocator.checkPermission();

    if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();
      if (locationPermission == LocationPermission.denied) {
        return Future.error('Permission denied');
      }
    }
    if (locationPermission == LocationPermission.deniedForever) {
      throw Exception(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    position = await Geolocator.getCurrentPosition();

    return position;
  } catch (e) {
    rethrow;
  }
}

Future<String> getPlaceName(Position position) async {
  try {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    locationItems['lat'] = position.latitude;
    locationItems['lng'] = position.longitude;

    Placemark place = placemarks[0];
    return "${place.name}, ${place.locality}, ${place.country}";
  } catch (e) {
    return "Unable to get place name";
  }
}

Future<Map> getLocation() async {
  String currentLocation;

  try {
    Position position = await getUserCurrentLocation();
    String place = await getPlaceName(position);
    currentLocation = place;
  } catch (e) {
    currentLocation = "";
  }
  locationItems['loc'] = currentLocation;

  return locationItems;
}
