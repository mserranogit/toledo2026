import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

/// Utilidad para la gestión de rutas y navegación con OpenStreetMap (OSM)
/// tomando la ubicación GPS del móvil como origen.
class MapLauncher {
  /// Obtiene la posición GPS actual del terminal móvil (origen de la ruta).
  static Future<Position?> getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        debugPrint('GPS desactivado en el dispositivo');
        return null;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          debugPrint('Permiso de ubicación denegado por el usuario');
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        debugPrint('Permisos de ubicación denegados permanentemente');
        return null;
      }

      // Intentar obtener primero la última ubicación conocida para mayor rapidez
      final lastKnown = await Geolocator.getLastKnownPosition();
      if (lastKnown != null) {
        return lastKnown;
      }

      // Obtener posición actual si no hay última ubicación guardada
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 6),
        ),
      );
    } catch (e) {
      debugPrint('Error al obtener la posición GPS: $e');
      return null;
    }
  }

  /// Navega hacia las coordenadas [destLat], [destLng] en OpenStreetMap (OSM).
  /// Utiliza la situación GPS del terminal como punto ORIGEN de la ruta.
  static Future<void> openOsmRoute({
    required double destLat,
    required double destLng,
    String? title,
  }) async {
    final Position? userPos = await getCurrentLocation();

    final String url;
    if (userPos != null) {
      // Formato oficial de ruta en OpenStreetMap (origen GPS -> destino)
      final String routeParam =
          '${userPos.latitude}%2C${userPos.longitude}%3B$destLat%2C$destLng';
      url =
          'https://www.openstreetmap.org/directions?engine=fossgis_osrm_foot&route=$routeParam';
    } else {
      // Si no hay GPS disponible o es denegado, enfocar punto de destino en OSM
      url =
          'https://www.openstreetmap.org/?mlat=$destLat&mlon=$destLng#map=17/$destLat/$destLng';
    }

    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  /// Navega hacia una dirección dada [address] en OpenStreetMap (OSM).
  /// Utiliza la posición GPS como ORIGEN de la ruta si está disponible.
  static Future<void> openOsmRouteByAddress({
    required String address,
    double? fallbackLat,
    double? fallbackLng,
  }) async {
    if (fallbackLat != null &&
        fallbackLng != null &&
        fallbackLat != 0.0 &&
        fallbackLng != 0.0) {
      return openOsmRoute(destLat: fallbackLat, destLng: fallbackLng, title: address);
    }

    final Position? userPos = await getCurrentLocation();

    final String url;
    if (userPos != null) {
      url =
          'https://www.openstreetmap.org/directions?from=${userPos.latitude}%2C${userPos.longitude}&to=${Uri.encodeComponent(address)}';
    } else {
      url =
          'https://www.openstreetmap.org/?query=${Uri.encodeComponent(address)}';
    }

    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
