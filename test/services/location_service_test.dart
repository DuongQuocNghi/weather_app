import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/core/errors/exceptions.dart';
import 'package:weather_app/services/location_service.dart';

// Tạo một wrapper để mock các phương thức tĩnh của Geolocator
class GeolocatorWrapper {
  Future<bool> isLocationServiceEnabled() async {
    return Geolocator.isLocationServiceEnabled();
  }

  Future<LocationPermission> checkPermission() async {
    return Geolocator.checkPermission();
  }

  Future<LocationPermission> requestPermission() async {
    return Geolocator.requestPermission();
  }

  Future<Position> getCurrentPosition({
    LocationAccuracy? accuracy,
    Duration? timeLimit,
  }) async {
    return Geolocator.getCurrentPosition();
  }
}

class MockGeolocatorWrapper extends Mock implements GeolocatorWrapper {}

// Tạo một lớp LocationService mới để test sử dụng GeolocatorWrapper
class TestableLocationService extends DefaultLocationService {
  final GeolocatorWrapper geolocatorWrapper;

  TestableLocationService({
    required this.geolocatorWrapper,
    BuildContext? context,
  }) : super(context: context);

  @override
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Kiểm tra xem dịch vụ định vị có được bật không
    serviceEnabled = await geolocatorWrapper.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw LocationException(
        message: 'Location services are disabled. Please enable them.',
      );
    }

    // Kiểm tra quyền truy cập vị trí
    permission = await geolocatorWrapper.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await geolocatorWrapper.requestPermission();
      if (permission == LocationPermission.denied) {
        throw LocationException(message: 'Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw LocationException(
        message:
            'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    // Lấy vị trí hiện tại
    try {
      return await geolocatorWrapper.getCurrentPosition();
    } catch (e) {
      throw LocationException(message: e.toString());
    }
  }
}

void main() {
  late TestableLocationService locationService;
  late MockGeolocatorWrapper mockGeolocatorWrapper;

  setUp(() {
    mockGeolocatorWrapper = MockGeolocatorWrapper();
    locationService = TestableLocationService(
      geolocatorWrapper: mockGeolocatorWrapper,
    );
  });

  group('getCurrentLocation', () {
    final tPosition = Position(
      latitude: 10.823099,
      longitude: 106.629662,
      timestamp: DateTime.now(),
      accuracy: 0.0,
      altitude: 0.0,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
      altitudeAccuracy: 0.0,
      headingAccuracy: 0.0,
    );

    test(
      'trả về vị trí hiện tại khi dịch vụ định vị được bật và có quyền truy cập',
      () async {
        // Arrange
        when(
          () => mockGeolocatorWrapper.isLocationServiceEnabled(),
        ).thenAnswer((_) async => true);
        when(
          () => mockGeolocatorWrapper.checkPermission(),
        ).thenAnswer((_) async => LocationPermission.whileInUse);
        when(
          () => mockGeolocatorWrapper.getCurrentPosition(),
        ).thenAnswer((_) async => tPosition);

        // Act
        final position = await locationService.getCurrentLocation();

        // Assert
        expect(position, equals(tPosition));

        // Kiểm tra các phương thức được gọi
        verify(() => mockGeolocatorWrapper.isLocationServiceEnabled());
        verify(() => mockGeolocatorWrapper.checkPermission());
        verify(() => mockGeolocatorWrapper.getCurrentPosition());
      },
    );

    test('ném LocationException khi dịch vụ định vị bị tắt', () async {
      // Arrange
      when(
        () => mockGeolocatorWrapper.isLocationServiceEnabled(),
      ).thenAnswer((_) async => false);

      // Act & Assert
      await expectLater(
        () => locationService.getCurrentLocation(),
        throwsA(isA<LocationException>()),
      );

      // Kiểm tra các phương thức được gọi
      verify(() => mockGeolocatorWrapper.isLocationServiceEnabled());
      verifyNever(() => mockGeolocatorWrapper.checkPermission());
      verifyNever(() => mockGeolocatorWrapper.getCurrentPosition());
    });

    test(
      'ném LocationException khi quyền truy cập vị trí bị từ chối',
      () async {
        // Arrange
        when(
          () => mockGeolocatorWrapper.isLocationServiceEnabled(),
        ).thenAnswer((_) async => true);
        when(
          () => mockGeolocatorWrapper.checkPermission(),
        ).thenAnswer((_) async => LocationPermission.denied);
        when(
          () => mockGeolocatorWrapper.requestPermission(),
        ).thenAnswer((_) async => LocationPermission.denied);

        // Act & Assert
        await expectLater(
          () => locationService.getCurrentLocation(),
          throwsA(isA<LocationException>()),
        );

        // Kiểm tra các phương thức được gọi
        verify(() => mockGeolocatorWrapper.isLocationServiceEnabled());
        verify(() => mockGeolocatorWrapper.checkPermission());
        verify(() => mockGeolocatorWrapper.requestPermission());
        verifyNever(() => mockGeolocatorWrapper.getCurrentPosition());
      },
    );

    test(
      'ném LocationException khi quyền truy cập vị trí bị từ chối vĩnh viễn',
      () async {
        // Arrange
        when(
          () => mockGeolocatorWrapper.isLocationServiceEnabled(),
        ).thenAnswer((_) async => true);
        when(
          () => mockGeolocatorWrapper.checkPermission(),
        ).thenAnswer((_) async => LocationPermission.deniedForever);

        // Act & Assert
        await expectLater(
          () => locationService.getCurrentLocation(),
          throwsA(isA<LocationException>()),
        );

        // Kiểm tra các phương thức được gọi
        verify(() => mockGeolocatorWrapper.isLocationServiceEnabled());
        verify(() => mockGeolocatorWrapper.checkPermission());
        verifyNever(() => mockGeolocatorWrapper.requestPermission());
        verifyNever(() => mockGeolocatorWrapper.getCurrentPosition());
      },
    );
  });
}
