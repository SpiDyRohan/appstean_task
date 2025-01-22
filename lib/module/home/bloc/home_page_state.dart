import 'package:appstean_test/module/home/model/user_response.dart';
import 'package:equatable/equatable.dart';

abstract class HomePageState extends Equatable {}

class HomeInitialState extends HomePageState {
  @override
  List<Object> get props => [];
}

class HomeLoadingState extends HomePageState {
  @override
  List<Object> get props => [];
}

class GetListSuccessState extends HomePageState {
  final List<UserResponse> response;

  GetListSuccessState({required this.response});

  @override
  List<Object> get props => [response];
}

class HomeFailureState extends HomePageState {
  final String msg;

  HomeFailureState({required this.msg});

  @override
  List<Object> get props => [];
}
