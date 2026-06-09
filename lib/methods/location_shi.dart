import 'dart:math';
import 'package:geolocator/geolocator.dart';

Map<String, double>? parseLatLng(String url) {
  final regex = RegExp(r'/@([0-9\.\-]+),([0-9\.\-]+),');
  final match = regex.firstMatch(url);
  if (match != null) {
    return {
      'lat': double.parse(match.group(1)!),
      'lng': double.parse(match.group(2)!),
    };
  }
  return null;
}

// distance calc
double distanceKm(lat1, lon1, lat2, lon2) {
  const R = 6371;
  final dLat = (lat2 - lat1) * (pi / 180);
  final dLon = (lon2 - lon1) * (pi / 180);
  final a =
      sin(dLat / 2) * sin(dLat / 2) +
      cos(lat1 * (pi / 180)) *
          cos(lat2 * (pi / 180)) *
          sin(dLon / 2) *
          sin(dLon / 2);
  return R * 2 * atan2(sqrt(a), sqrt(1 - a));
}

class devLocation {
  Future getDevLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;

      // return ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: AutoSizeText('Location services are disabled')),
      // );
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: AutoSizeText('Please allow Location Services')),
        // );
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return false;

      // return ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: AutoSizeText('Allow location services to search')),
      // );
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );
  }
}
