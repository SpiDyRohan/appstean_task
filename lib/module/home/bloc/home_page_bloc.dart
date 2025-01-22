import 'dart:async';

import 'package:appstean_test/main.dart';
import 'package:appstean_test/module/home/bloc/home_page_event.dart';
import 'package:appstean_test/module/home/bloc/home_page_state.dart';
import 'package:appstean_test/module/home/model/user_response.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  HomePageBloc() : super(HomeInitialState()) {
    on(getListApi);
  }

  FutureOr<void> getListApi(
      GetListEvent event, Emitter<HomePageState> emit) async {
    emit(HomeLoadingState());
    List<UserResponse> response = await repository.getUsersList();
    emit(GetListSuccessState(response: response));
  }
}
