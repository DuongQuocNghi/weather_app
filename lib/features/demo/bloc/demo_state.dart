import 'package:equatable/equatable.dart';

enum DemoStatus { initial, success, failure, loading }

class DemoState extends Equatable {
  const DemoState({
    this.status = DemoStatus.initial,
    // List load more
    // this.total = 0,
    // this.hasNextPage = true,
    // this.page = 1,
  });

  final DemoStatus status;
  // List load more
  // final int total;
  // final bool hasNextPage;
  // final int page;

  DemoState copyWith({
    DemoStatus? status,
    // List load more
    // int? total,
    // bool? hasNextPage,
    // int? page,
  }) {
    return DemoState(
      status: status ?? this.status,
      // List load more
      // total: total ?? this.total,
      // hasNextPage: hasNextPage ?? this.hasNextPage,
      // page: page ?? this.page,
    );
  }

  @override
  String toString() {
    return '';
  }

  // props nếu không khai báo đầy đủ các biến thì khi emit các biến bị thiếu sẽ ko dc cập nhật data
  @override
  List<Object?> get props => [status]; // , total, hasNextPage, page]; List load more
}
