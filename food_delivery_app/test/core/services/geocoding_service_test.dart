import 'package:flutter_test/flutter_test.dart';
import 'package:food_delivery_app/core/services/geocoding_service.dart';

void main() {
  group('GeocodingService Distance Calculation Tests', () {
    late GeocodingService service;

    setUp(() {
      service = GeocodingService.instance;
    });

    test('Should calculate distance between two points correctly', () {
      // New York to Los Angeles (approximately 3944 km)
      const lat1 = 40.7128; // New York
      const lon1 = -74.0060;
      const lat2 = 34.0522; // Los Angeles
      const lon2 = -118.2437;

      final distance = service.calculateDistance(
        lat1: lat1,
        lon1: lon1,
        lat2: lat2,
        lon2: lon2,
      );

      // Should be approximately 3944 km (±100 km tolerance)
      expect(distance, greaterThan(3800));
      expect(distance, lessThan(4100));
    });

    test('Distance between same point should be zero', () {
      const lat = 40.7128;
      const lon = -74.0060;

      final distance = service.calculateDistance(
        lat1: lat,
        lon1: lon,
        lat2: lat,
        lon2: lon,
      );

      expect(distance, closeTo(0, 0.001));
    });

    test('Should calculate short distance correctly', () {
      // Two points approximately 1 km apart
      const lat1 = 40.7128;
      const lon1 = -74.0060;
      const lat2 = 40.7218; // ~1 km north
      const lon2 = -74.0060;

      final distance = service.calculateDistance(
        lat1: lat1,
        lon1: lon1,
        lat2: lat2,
        lon2: lon2,
      );

      // Should be approximately 1 km
      expect(distance, greaterThan(0.9));
      expect(distance, lessThan(1.1));
    });

    test('Distance should be symmetric', () {
      const lat1 = 40.7128;
      const lon1 = -74.0060;
      const lat2 = 34.0522;
      const lon2 = -118.2437;

      final distance1 = service.calculateDistance(
        lat1: lat1,
        lon1: lon1,
        lat2: lat2,
        lon2: lon2,
      );

      final distance2 = service.calculateDistance(
        lat1: lat2,
        lon1: lon2,
        lat2: lat1,
        lon2: lon1,
      );

      expect(distance1, closeTo(distance2, 0.001));
    });
  });

  group('GeocodingResult Tests', () {
    test('GeocodingResult should be created correctly', () {
      const result = GeocodingResult(
        formattedAddress: '123 Main St, New York, NY 10001',
        latitude: 40.7128,
        longitude: -74.0060,
        placeId: 'place123',
        isValid: true,
        addressComponents: {
          'street': 'Main St',
          'city': 'New York',
          'state': 'NY',
          'zipCode': '10001',
        },
      );

      expect(result.formattedAddress, '123 Main St, New York, NY 10001');
      expect(result.latitude, 40.7128);
      expect(result.longitude, -74.0060);
      expect(result.isValid, true);
      expect(result.addressComponents?['city'], 'New York');
    });

    test('Invalid GeocodingResult should have isValid as false', () {
      const result = GeocodingResult(
        formattedAddress: '',
        latitude: 0.0,
        longitude: 0.0,
        placeId: '',
        isValid: false,
      );

      expect(result.isValid, false);
    });
  });

  group('PlaceDetails Tests', () {
    test('PlaceDetails should be created correctly', () {
      const placeDetails = PlaceDetails(
        placeId: 'place123',
        name: 'Pizza Palace',
        formattedAddress: '123 Main St, New York, NY',
        latitude: 40.7128,
        longitude: -74.0060,
        phoneNumber: '+1-555-0123',
        website: 'https://pizzapalace.com',
      );

      expect(placeDetails.name, 'Pizza Palace');
      expect(placeDetails.phoneNumber, '+1-555-0123');
      expect(placeDetails.website, 'https://pizzapalace.com');
    });
  });
}
