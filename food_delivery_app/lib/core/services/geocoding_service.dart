import 'dart:math' as math;
import 'package:dio/dio.dart';

/// Geocoding Service - Handles address validation and geocoding
class GeocodingService {
  static final GeocodingService instance = GeocodingService._internal();
  factory GeocodingService() => instance;
  GeocodingService._internal();

  final Dio _dio = Dio();

  // TODO: Replace with your Google Maps API key
  String _googleMapsApiKey = 'YOUR_GOOGLE_MAPS_API_KEY';

  /// Initialize with API key
  void initialize(String apiKey) {
    _googleMapsApiKey = apiKey;
  }

  /// Validate and geocode address
  Future<GeocodingResult> validateAddress(String address) async {
    try {
      final response = await _dio.get(
        'https://maps.googleapis.com/maps/api/geocode/json',
        queryParameters: {
          'address': address,
          'key': _googleMapsApiKey,
        },
      );

      if (response.data['status'] == 'OK') {
        final results = response.data['results'] as List;
        if (results.isNotEmpty) {
          final result = results.first as Map<String, dynamic>;
          final geometry = result['geometry'] as Map<String, dynamic>;
          final location = geometry['location'] as Map<String, dynamic>;

          return GeocodingResult(
            formattedAddress: result['formatted_address'] as String,
            latitude: location['lat'] as double,
            longitude: location['lng'] as double,
            placeId: result['place_id'] as String,
            isValid: true,
            addressComponents: _parseAddressComponents(
              result['address_components'] as List,
            ),
          );
        }
      }

      return const GeocodingResult(
        formattedAddress: '',
        latitude: 0.0,
        longitude: 0.0,
        placeId: '',
        isValid: false,
      );
    } catch (e) {
      throw GeocodingException('Failed to validate address: $e');
    }
  }

  /// Reverse geocode (get address from coordinates)
  Future<GeocodingResult> reverseGeocode({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final response = await _dio.get(
        'https://maps.googleapis.com/maps/api/geocode/json',
        queryParameters: {
          'latlng': '$latitude,$longitude',
          'key': _googleMapsApiKey,
        },
      );

      if (response.data['status'] == 'OK') {
        final results = response.data['results'] as List;
        if (results.isNotEmpty) {
          final result = results.first as Map<String, dynamic>;

          return GeocodingResult(
            formattedAddress: result['formatted_address'] as String,
            latitude: latitude,
            longitude: longitude,
            placeId: result['place_id'] as String,
            isValid: true,
            addressComponents: _parseAddressComponents(
              result['address_components'] as List,
            ),
          );
        }
      }

      return const GeocodingResult(
        formattedAddress: '',
        latitude: 0.0,
        longitude: 0.0,
        placeId: '',
        isValid: false,
      );
    } catch (e) {
      throw GeocodingException('Failed to reverse geocode: $e');
    }
  }

  /// Get place details
  Future<PlaceDetails> getPlaceDetails(String placeId) async {
    try {
      final response = await _dio.get(
        'https://maps.googleapis.com/maps/api/place/details/json',
        queryParameters: {
          'place_id': placeId,
          'key': _googleMapsApiKey,
        },
      );

      if (response.data['status'] == 'OK') {
        final result = response.data['result'] as Map<String, dynamic>;
        final geometry = result['geometry'] as Map<String, dynamic>;
        final location = geometry['location'] as Map<String, dynamic>;

        return PlaceDetails(
          placeId: placeId,
          name: result['name'] as String?,
          formattedAddress: result['formatted_address'] as String,
          latitude: location['lat'] as double,
          longitude: location['lng'] as double,
          phoneNumber: result['formatted_phone_number'] as String?,
          website: result['website'] as String?,
        );
      }

      throw GeocodingException('Place not found');
    } catch (e) {
      throw GeocodingException('Failed to get place details: $e');
    }
  }

  /// Calculate distance between two coordinates (in kilometers)
  /// Using Haversine formula
  double calculateDistance({
    required double lat1,
    required double lon1,
    required double lat2,
    required double lon2,
  }) {
    const double earthRadius = 6371; // km

    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);

    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRadians(lat1)) *
            math.cos(_toRadians(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return earthRadius * c;
  }

  /// Parse address components
  Map<String, String> _parseAddressComponents(List components) {
    final Map<String, String> result = {};

    for (final component in components) {
      final types = component['types'] as List;
      final longName = component['long_name'] as String;

      if (types.contains('street_number')) {
        result['streetNumber'] = longName;
      } else if (types.contains('route')) {
        result['street'] = longName;
      } else if (types.contains('locality')) {
        result['city'] = longName;
      } else if (types.contains('administrative_area_level_1')) {
        result['state'] = longName;
      } else if (types.contains('country')) {
        result['country'] = longName;
      } else if (types.contains('postal_code')) {
        result['zipCode'] = longName;
      }
    }

    return result;
  }

  // Math helpers
  double _toRadians(double degrees) => degrees * (math.pi / 180);
}

/// Geocoding Result
class GeocodingResult {
  final String formattedAddress;
  final double latitude;
  final double longitude;
  final String placeId;
  final bool isValid;
  final Map<String, String>? addressComponents;

  const GeocodingResult({
    required this.formattedAddress,
    required this.latitude,
    required this.longitude,
    required this.placeId,
    required this.isValid,
    this.addressComponents,
  });
}

/// Place Details
class PlaceDetails {
  final String placeId;
  final String? name;
  final String formattedAddress;
  final double latitude;
  final double longitude;
  final String? phoneNumber;
  final String? website;

  const PlaceDetails({
    required this.placeId,
    this.name,
    required this.formattedAddress,
    required this.latitude,
    required this.longitude,
    this.phoneNumber,
    this.website,
  });
}

/// Geocoding Exception
class GeocodingException implements Exception {
  final String message;
  GeocodingException(this.message);

  @override
  String toString() => message;
}
