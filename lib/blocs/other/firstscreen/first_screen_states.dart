part of 'first_screen_bloc.dart';

abstract class FirstScreenStates extends BaseStates {
  const FirstScreenStates();
}

///all states of AuthenticationStates

class FirstScreenInitialState extends FirstScreenStates {}

class FirstScreenResponseState extends FirstScreenStates {
  //declare and pass request as below
  final PaginationResponse paginationResponse;
  FirstScreenResponseState(this.paginationResponse);
}
