import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soleoserp/blocs/base/base_bloc.dart';
import 'package:soleoserp/models/Request/paginationRequest.dart';
import 'package:soleoserp/models/Response/paginationResponse.dart';
import 'package:soleoserp/repositories/repository.dart';

part 'first_screen_events.dart';
part 'first_screen_states.dart';

class FirstScreenBloc extends Bloc<FirstScreenEvents, FirstScreenStates> {
  Repository userRepository = Repository.getInstance();
  BaseBloc baseBloc;

  FirstScreenBloc(this.baseBloc) : super(FirstScreenInitialState());

  @override
  Stream<FirstScreenStates> mapEventToState(FirstScreenEvents event) async* {
    /// sets state based on events
    if (event is FirstScreenCallEvent) {
      yield* _mapFirstScreenCallEventToState(event);
    }
  }

  ///event functions to states implementation
  Stream<FirstScreenStates> _mapFirstScreenCallEventToState(
      FirstScreenCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      //call your api as follows
      PaginationResponse loginResponse =
          await userRepository.paginationAPI(event.paginationRequest);
      yield FirstScreenResponseState(loginResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }
}
