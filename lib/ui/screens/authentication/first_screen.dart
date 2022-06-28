import 'package:flutter/material.dart';
import 'package:soleoserp/blocs/other/firstscreen/first_screen_bloc.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';

class FirstScreen extends BaseStatefulWidget {
  static const routeName = '/firstScreen';

  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends BaseState<FirstScreen>
    with BasicScreen, WidgetsBindingObserver {
  FirstScreenBloc _firstScreenBloc;

  @override
  void initState() {
    super.initState();
    screenStatusBarColor = Colors.white;
    _firstScreenBloc = FirstScreenBloc(baseBloc);
  }

  ///listener to multiple states of bloc to handles api responses
  ///use only BlocListener if only need to listen to events
/*
  @override
  Widget build(BuildContext context) {
    return BlocListener<FirstScreenBloc, FirstScreenStates>(
      bloc: _authenticationBloc,
      listener: (BuildContext context, FirstScreenStates state) {
        if (state is FirstScreenResponseState) {
          _onFirstScreenCallSuccess(state.response);
        }
      },
      child: super.build(context),
    );
  }
*/

  ///listener and builder to multiple states of bloc to handles api responses
  ///use BlocProvider if need to listen and build
/*
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
      _homeBloc..add(FirstScreenCallEvent(yourRequest)),
      child: BlocConsumer<FirstScreenBloc, FirstScreenStates>(
        builder: (BuildContext context, FirstScreenStates state) {
          //handle states
          if (state is FirstScreenResponseState) {
          _onFirstScreenCallSuccess(state.response);
          }
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          //return true for state for which builder method should be called
          if (currentState is FirstScreenResponseState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, FirstScreenStates state) {
          //handle states
           },
        listenWhen: (oldState, currentState) {
         //return true for state for which listener method should be called
          return false;
        },
      ),
    );
  }
*/

  @override
  Widget buildBody(BuildContext context) {
    return Center(
      child: Text(localizations.appName),
    );
  }
}
