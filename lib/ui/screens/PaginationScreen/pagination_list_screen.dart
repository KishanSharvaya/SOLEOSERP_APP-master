import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:soleoserp/blocs/other/firstscreen/first_screen_bloc.dart';
import 'package:soleoserp/models/DB_Models/productdetails.dart';
import 'package:soleoserp/models/Request/paginationRequest.dart';
import 'package:soleoserp/models/Response/paginationResponse.dart';
import 'package:soleoserp/ui/res/color_resources.dart';
import 'package:soleoserp/ui/res/image_resources.dart';
import 'package:soleoserp/ui/screens/Cart/cart_list_screen.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';
import 'package:soleoserp/ui/widgets/item_counter_widget.dart';
import 'package:soleoserp/utils/general_utils.dart';
import 'package:soleoserp/utils/offline_db_helper.dart';

class PaginationListScreen extends BaseStatefulWidget {
  static const routeName = '/PaginationListScreen';

  @override
  _PaginationListScreenState createState() => _PaginationListScreenState();
}

class _PaginationListScreenState extends BaseState<PaginationListScreen>
    with BasicScreen, WidgetsBindingObserver {
  FirstScreenBloc _firstScreenBloc;

  List<Data> ItemsList = [];
  FToast fToast;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
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
    int amount = 1;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorWhite,
        title: Text(
          "Product List",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              navigateTo(context, DynamicCartScreen.routeName,
                  clearAllStack: true);
            },
            child: Container(
                height: 48,
                width: 48,
                child: Icon(
                  Icons.shopping_cart,
                  color: Colors.black,
                )),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _firstScreenBloc.add(
              FirstScreenCallEvent(PaginationRequest(page: "1", perPage: "5")));
        },
        child: Container(
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 5.0,
              mainAxisSpacing: 5.0,
              childAspectRatio: (200 / 300),

              ///200,300
            ),
            itemCount: ItemsList.length,
            itemBuilder: (context, index) {
              return Card(
                child: Container(
                  child: Center(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                } else {
                                  return CircularProgressIndicator();
                                }
                              },
                              errorBuilder: (BuildContext context,
                                  Object exception, StackTrace stackTrace) {
                                return Image.asset(
                                  NO_IMAGE_FOUND,
                                  height: 80,
                                  width: 80,
                                );
                              },
                              height: 35,
                              fit: BoxFit.fill,
                              width: 35,
                            ),
                          ),
                          SizedBox(height: 5.0),
                          Container(
                            alignment: Alignment.center,
                            child: Text(ItemsList[index].title,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 12.0, color: colorBlack)),
                          ),
                          SizedBox(height: 5.0),
                          Align(
                            alignment: Alignment.center,
                            child: ItemCounterWidgetForCart(
                              onAmountChanged: (newAmount) async {
                                amount = newAmount;
                              },
                            ),
                          ),
                          SizedBox(height: 5.0),
                          Container(
                            child: Text(
                                "Rs. " + ItemsList[index].price.toString(),
                                softWrap: true,
                                style: TextStyle(
                                    fontSize: 12.0, color: colorPrimary)),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          InkWell(
                            onTap: () {
                              PushDataToCart(ItemsList[index], amount);
                            },
                            child: Container(
                              margin: EdgeInsets.only(left: 10, right: 10),
                              child: Card(
                                color: Colors.blue,
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  alignment: Alignment.center,
                                  child: Text("Add To Cart",
                                      softWrap: true,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 12.0, color: colorWhite)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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

  void PushDataToCart(Data itemsList, int qty) async {
    int ProductID = itemsList.id;
    double Quantity = double.parse(qty.toString());
    double Amount = double.parse(itemsList.price.toString());
    double NetAmount = Quantity * Amount;
    String ProductName = itemsList.title;
    String ProductImage = itemsList.featuredImage;

    ProductCartModel productCartModel = new ProductCartModel(
        ProductID, Quantity, Amount, NetAmount, ProductName, ProductImage);

    await OfflineDbHelper.getInstance().insertProductToCart(productCartModel);

    fToast = FToast();
    fToast.init(context);
    fToast.showToast(
      child: showCustomToast(Title: "Item Added To Cart"),
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
  }

  Widget showCustomToast({String Title}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.black,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check, color: Colors.white),
          SizedBox(
            width: 12.0,
          ),
          Text(
            Title,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
