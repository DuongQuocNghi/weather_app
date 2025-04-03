import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/core/errors/exceptions.dart';

void main() {
  group('ServerException', () {
    test('hai đối tượng có cùng message thì bằng nhau', () {
      // Arrange
      const exception1 = ServerException(message: 'Lỗi server');
      const exception2 = ServerException(message: 'Lỗi server');

      // Assert
      expect(exception1, equals(exception2));
    });

    test('hai đối tượng có message khác nhau thì không bằng nhau', () {
      // Arrange
      const exception1 = ServerException(message: 'Lỗi server');
      const exception2 = ServerException(message: 'Lỗi kết nối');

      // Assert
      expect(exception1, isNot(equals(exception2)));
    });

    test('toString trả về message của exception', () {
      // Arrange
      const message = 'Lỗi server';
      const exception = ServerException(message: message);

      // Assert
      expect(exception.toString(), contains(message));
    });
  });

  group('LocationException', () {
    test('hai đối tượng có cùng message thì bằng nhau', () {
      // Arrange
      const exception1 = LocationException(message: 'Lỗi vị trí');
      const exception2 = LocationException(message: 'Lỗi vị trí');

      // Assert
      expect(exception1, equals(exception2));
    });

    test('hai đối tượng có message khác nhau thì không bằng nhau', () {
      // Arrange
      const exception1 = LocationException(message: 'Lỗi vị trí');
      const exception2 = LocationException(message: 'Không thể lấy vị trí');

      // Assert
      expect(exception1, isNot(equals(exception2)));
    });

    test('toString trả về message của exception', () {
      // Arrange
      const message = 'Lỗi vị trí';
      const exception = LocationException(message: message);

      // Assert
      expect(exception.toString(), contains(message));
    });
  });
}
