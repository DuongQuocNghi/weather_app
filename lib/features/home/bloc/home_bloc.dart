import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/core/utils/throttle_droppable.dart';
import 'package:weather_app/features/home/bloc/home_event.dart';
import 'package:weather_app/features/home/bloc/home_state.dart';


class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState()) {
    on<HomeInitial>(
      _onHomeInitial,
      transformer: throttleDroppable(throttleDuration),
    );
    on<HomeFetch>(
      _onHomeFetched,
      transformer: throttleDroppable(throttleDuration),
    );

  }

  Future<void> _onHomeInitial(
      HomeInitial event,
      Emitter<HomeState> emit,
      ) async {
    try {
      // final data = await _fetchHomes(id: '');
      return emit(state.copyWith(
          status: HomeStatus.success,
      ));
    } catch (_) {
      emit(state.copyWith(status: HomeStatus.failure));
    }
  }

  Future<void> _onHomeFetched(
      HomeFetch event,
      Emitter<HomeState> emit,
      ) async {
    // if (!state.hasNextPage) return;
    try {
      // final data = await _fetchProjectLists(
      //   page: state.page+1,
      //   search: state.search,
      //   inputdata: state.dataFilter.getInputDataFilterGetListRealEstateProjects(),
      //   sort: state.sort,
      // );
      // return emit(state.copyWith(
      //     status: ProjectListStatus.success,
      //     projectLists: List.of(state.projectLists)..addAll(data.items ?? []),
      //     total: data.total,
      //     hasNextPage: data.hasNextPage,
      //     page: data.page
      // ));
    } catch (_) {
      emit(state.copyWith(status: HomeStatus.failure));
    }
  }
}