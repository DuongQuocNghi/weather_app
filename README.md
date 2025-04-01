# Weather App

Flutter SDK: 3.29.1

## Giới thiệu
Ứng dụng thời tiết là một ứng dụng Flutter hiện đại giúp người dùng theo dõi thông tin thời tiết. Ứng dụng hỗ trợ đa ngôn ngữ (Tiếng Anh, Tiếng Việt) và được tổ chức theo kiến trúc BLoC pattern.

## Cấu trúc dự án

### Cấu trúc thư mục chính
```
lib/
├── app/            # Cấu hình ứng dụng
├── core/           # Các thành phần cốt lõi
│   ├── assets/     # Tài nguyên ứng dụng
│   ├── constants/  # Các hằng số 
│   ├── errors/     # Xử lý lỗi
│   ├── network/    # Cấu hình mạng
│   ├── utils/      # Tiện ích
│   └── widgets/    # Widget dùng chung
├── features/       # Các tính năng của ứng dụng
│   ├── home/       # Màn hình chính
│   └── demo/       # Màn hình demo
├── i18n/           # Đa ngôn ngữ
├── repositories/   # Repository pattern
├── services/       # Service pattern
└── src/            # Mã nguồn khác
```

### Gói thư viện chính
- **flutter_bloc**: Quản lý trạng thái ứng dụng
- **go_router**: Điều hướng và xử lý deeplink
- **shared_preferences**: Lưu trữ cục bộ
- **intl & flutter_localizations**: Hỗ trợ đa ngôn ngữ 
- **equatable**: So sánh đối tượng
- **fluttertoast**: Hiển thị thông báo

## Kiến trúc
Ứng dụng được xây dựng theo kiến trúc clean architecture với các lớp:
- **Presentation**: UI, widgets và quản lý trạng thái (sử dụng BLoC pattern)
- **Domain**: Logic nghiệp vụ
- **Data**: Repository pattern và service pattern để truy cập dữ liệu

## Tính năng
- Đa ngôn ngữ (Tiếng Anh, Tiếng Việt)
- Điều hướng bằng Go Router, hỗ trợ deeplink
- Quản lý trạng thái với BLoC pattern

## Cài đặt & Chạy
```bash
# Clone dự án
git clone <repository_url>

# Cài đặt các dependency
flutter pub get

# Chạy ứng dụng
flutter run
```

## Đóng góp
Vui lòng tuân thủ các quy tắc sau khi đóng góp vào dự án:
- Sử dụng BLoC pattern cho quản lý trạng thái
- Tuân thủ quy tắc đặt tên và cấu trúc thư mục hiện tại
- Viết test cho các tính năng mới