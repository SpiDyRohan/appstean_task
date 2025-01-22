import 'package:equatable/equatable.dart';

abstract class HomePageEvent extends Equatable {}

class GetListEvent extends HomePageEvent {
  @override
  List<Object> get props => [];
}
