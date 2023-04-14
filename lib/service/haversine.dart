import 'dart:math' show sin, asin, sqrt, pi, cos;
import 'package:latlng/latlng.dart';

class HaversineService {
  double deg2Rad(d) {
    return (d * pi / 180.0);
  }

  double haversineFormula(LatLng origin, LatLng destination) {
    double R = 6371.0;

    double deltaLang = deg2Rad(destination.longitude - origin.longitude);
    double deltaLat = deg2Rad(destination.latitude - origin.latitude);

    double a = sin(deltaLat / 2) * sin(deltaLat / 2) +
        cos(deg2Rad(origin.latitude)) *
            cos(deg2Rad(destination.latitude)) *
            sin(deltaLang / 2) *
            sin(deltaLang / 2);
    double c = 2 * asin(sqrt(a));
    double d = c * R;

    return d;
  }
}
