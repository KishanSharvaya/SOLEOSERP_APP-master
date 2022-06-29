import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:soleoserp/models/DB_Models/productdetails.dart';
import 'package:soleoserp/ui/res/color_resources.dart';
import 'package:soleoserp/ui/res/image_resources.dart';
import 'package:soleoserp/ui/screens/PaginationScreen/pagination_list_screen.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';
import 'package:soleoserp/utils/general_utils.dart';
import 'package:soleoserp/utils/offline_db_helper.dart';

class DynamicCartScreen extends BaseStatefulWidget {
  static const routeName = '/DynamicCartScreen';

  @override
  _DynamicCartScreenState createState() => _DynamicCartScreenState();
}

class _DynamicCartScreenState extends BaseState<DynamicCartScreen>
    with BasicScreen, WidgetsBindingObserver {
  List<ProductCartModel> getproductlistfromdb = [];
  int amount = 1;
  double TotalAmount = 0;
  double tot = 0.00;

  TextEditingController tot_amnt = TextEditingController();
  FToast fToast;

  List<ProductCartModel> arrCartAPIList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    tot_amnt.text = "";

    fToast = FToast();
    fToast.init(context);

    getproductlistfromdbMethod();
  }

  @override
  Widget buildBody(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        getproductlistfromdbMethod();
        navigateTo(context, PaginationListScreen.routeName,
            clearAllStack: true);
        return new Future(() => false);
      },
      child: Scaffold(
        backgroundColor: colorWhiteMix,
        appBar: AppBar(
          backgroundColor: colorWhite,
          leading: InkWell(
              onTap: () {
                navigateTo(context, PaginationListScreen.routeName,
                    clearAllStack: true);
              },
              child: Icon(
                Icons.keyboard_arrow_left,
                size: 35,
                color: colorBlack,
              )),
          title: Text(
            "My Cart",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: colorBlack,
            ),
          ),
          actions: [
            InkWell(
                onTap: () async {
                  showCommonDialogWithTwoOptions(
                    context,
                    "Do you want to Delete All Products?",
                    negativeButtonTitle: "No",
                    positiveButtonTitle: "Yes",
                    onTapOfPositiveButton: () async {
                      Navigator.pop(context);

                      await OfflineDbHelper.getInstance().deleteContactTable();
                      setState(() {
                        getproductlistfromdb.clear();
                        TotalAmount = 0.00;
                      });
                    },
                  );
                },
                child: getproductlistfromdb.length != 0
                    ? DeleteAll()
                    : Container())
          ],
        ),
        body: getproductlistfromdb.length != 0
            ? Container(
                padding: EdgeInsets.only(
                  left: 5 /*DEFAULT_SCREEN_LEFT_RIGHT_MARGIN2*/,
                  right: 5 /*DEFAULT_SCREEN_LEFT_RIGHT_MARGIN2*/,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 25,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (getproductlistfromdb.length != 0)
                              ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return _buildInquiryListItem(index);
                                },
                                shrinkWrap: true,
                                itemCount: getproductlistfromdb.length,
                              )
                            else
                              Center(
                                child: Text("Cart Is Empty"),
                              ),
                          ],
                        ),
                      ),
                    ),
                    getproductlistfromdb.length != 0
                        ? Align(
                            alignment: Alignment.bottomCenter,
                            child: Row(
                              children: [
                                Expanded(
                                    flex: 1, child: getButtonPriceWidget()),
                              ],
                            ))
                        : Container(),
                  ],
                ),
              )
            : Center(
                child: Text("Cart Is Empty"),
              ),
      ),
    );
  }

  Widget _buildInquiryListItem(int index) {
    ProductCartModel productCartModel = getproductlistfromdb[index];

    print('QTY4334' + productCartModel.ProductImage.toString());
    return Card(
      child: Container(
        child: Row(
          children: [
            Expanded(
              child: Image.network(
                productCartModel.ProductImage.toString(),
                frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                  return child;
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return CircularProgressIndicator();
                  }
                },
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace stackTrace) {
                  return Image.asset(
                    NO_IMAGE_FOUND,
                    height: 100,
                    width: 100,
                  );
                },
                width: 100,
                height: 100,
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    child: Container(
                      child: Text(
                        "${productCartModel.ProductName}",
                        style: TextStyle(
                            color: colorBlack,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Align(
                    child: Container(
                      child: Text(
                        "Price : Rs.${productCartModel.Amount}",
                        style: TextStyle(color: colorBlack, fontSize: 12),
                      ),
                    ),
                  ),
                  Align(
                    child: Container(
                      margin: EdgeInsets.only(right: 10),
                      child: Text(
                        "Quantity : Rs.${productCartModel.Quantity}",
                        style: TextStyle(color: colorBlack, fontSize: 12),

                        //"Price : Rs.${getPrice(productCartModel.Amount, productCartModel.Quantity, productCartModel, index).toStringAsFixed(2)}",
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () {
                  showCommonDialogWithTwoOptions(
                    context,
                    "Do you want to Delete This Product?",
                    negativeButtonTitle: "No",
                    positiveButtonTitle: "Yes",
                    onTapOfPositiveButton: () {
                      Navigator.pop(context);

                      _onTapOfDeleteContact(index);
                      fToast.showToast(
                        child: showCustomToast(Title: "Item Deleted !"),
                        gravity: ToastGravity.BOTTOM,
                        toastDuration: Duration(seconds: 2),
                      );
                    },
                  );
                },
                child: Icon(
                  Icons.delete,
                  color: colorBlack,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onTapOfDeleteContact(int index) async {
    await OfflineDbHelper.getInstance()
        .deleteContact(getproductlistfromdb[index].id);
    setState(() {
      getproductlistfromdb.removeAt(index);
      TotalAmount = 0.00;
      for (int i = 0; i < getproductlistfromdb.length; i++) {
        TotalAmount +=
            (getproductlistfromdb[i].Amount * getproductlistfromdb[i].Quantity);
      }
    });
  }

  Widget imageWidget(String imagePath) {
    return Container(
      width: 100,
      child: Image.asset(imagePath),
    );
  }

  getproductlistfromdbMethod() async {
    await getproductductdetails();
  }

  Future<void> getproductductdetails() async {
    arrCartAPIList.clear();
    getproductlistfromdb.clear();
    List<ProductCartModel> Tempgetproductlistfromdb =
        await OfflineDbHelper.getInstance().getProductCartList();
    getproductlistfromdb.addAll(Tempgetproductlistfromdb);
    for (int i = 0; i < getproductlistfromdb.length; i++) {
      TotalAmount +=
          (getproductlistfromdb[i].Amount * getproductlistfromdb[i].Quantity);
    }

    setState(() {});
  }

  Widget getButtonPriceWidget() {
    return Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          // color: Getirblue,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Container(
          padding: EdgeInsets.all(10),
          color: Colors.blue,
          child: Row(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Total Item : ",
                          style: TextStyle(
                            fontSize: 12,
                            color: colorWhite,
                          )),
                      Text(
                        getproductlistfromdb.length.toStringAsFixed(2),
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: colorWhite,
                            fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Grand Total : ",
                          style: TextStyle(
                            fontSize: 12,
                            color: colorWhite,
                          )),
                      Text(
                        "Rs." + TotalAmount.toStringAsFixed(2),
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: colorWhite,
                            fontSize: 15),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }

  Widget DeleteAll() {
    return Container(
      margin: EdgeInsets.only(right: 10, top: 10, bottom: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: colorBlack,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        "Delete All",
        style: TextStyle(fontSize: 10),
      ),
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
