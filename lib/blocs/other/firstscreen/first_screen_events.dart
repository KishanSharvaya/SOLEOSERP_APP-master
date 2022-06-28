part of 'first_screen_bloc.dart';

@immutable
abstract class FirstScreenEvents {}

///all events of AuthenticationEvents

class FirstScreenCallEvent extends FirstScreenEvents {
  //declare and pass request as below
  final PaginationRequest paginationRequest;
  FirstScreenCallEvent(this.paginationRequest);
}
