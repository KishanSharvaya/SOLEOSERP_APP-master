import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soleoserp/blocs/other/firstscreen/first_screen_bloc.dart';
import 'package:soleoserp/models/Request/paginationRequest.dart';
import 'package:soleoserp/models/Response/paginationResponse.dart';
import 'package:soleoserp/ui/res/color_resources.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';

class PaginationListScreen extends BaseStatefulWidget {
  static const routeName = '/PaginationListScreen';

  @override
  _PaginationListScreenState createState() => _PaginationListScreenState();
}

class _PaginationListScreenState extends BaseState<PaginationListScreen>
    with BasicScreen, WidgetsBindingObserver {
  FirstScreenBloc _firstScreenBloc;

  List<Data> ItemsList = [];

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
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _firstScreenBloc
        ..add(FirstScreenCallEvent(PaginationRequest(page: "1", perPage: "5"))),
      child: BlocConsumer<FirstScreenBloc, FirstScreenStates>(
        builder: (BuildContext context, FirstScreenStates state) {
          //handle states
          if (state is FirstScreenResponseState) {
            _onFirstScreenCallSuccess(state);
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

  @override
  Widget buildBody(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () {
          _firstScreenBloc
            ..add(FirstScreenCallEvent(
                PaginationRequest(page: "1", perPage: "5")));
        },
        child: Container(
          child: GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 5.0,
              mainAxisSpacing: 5.0,
              childAspectRatio: (200 / 200),

              ///200,300
            ),
            itemCount: ItemsList.length,
            itemBuilder: (context, index) {
              return Container(
                child: Center(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      verticalDirection: VerticalDirection.down,
                      children: <Widget>[
                        Center(
                          child: Image.network(
                            ItemsList[index].featuredImage.toString(),
                            frameBuilder: (context, child, frame,
                                wasSynchronouslyLoaded) {
                              return child;
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              } else {
                                return CircularProgressIndicator();
                              }
                            },
                            errorBuilder: (BuildContext context,
                                Object exception, StackTrace stackTrace) {
                              return Icon(Icons.error);
                            },
                            height: 35,
                            fit: BoxFit.fill,
                            width: 35,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Container(
                          alignment: Alignment.center,
                          child: Text(ItemsList[index].title,
                              softWrap: true,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 12.0, color: colorPrimary)),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  _onFirstScreenCallSuccess(FirstScreenResponseState state) {
    print("DataFromAPI123" + state.paginationResponse.message);
    ItemsList.clear();
    for (int i = 0; i < state.paginationResponse.data.length; i++) {
      print("DataFromAPI" + state.paginationResponse.data[i].featuredImage);

      Data data = Data();
      data.title = state.paginationResponse.data[i].title;

      data.price = state.paginationResponse.data[i].price;
      data.slug = state.paginationResponse.data[i].slug;

      ItemsList.add(data);
    }
  }
}
