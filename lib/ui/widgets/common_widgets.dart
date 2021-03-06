import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:soleoserp/models/common/custom_text_editing_controller.dart';
import 'package:soleoserp/ui/res/color_resources.dart';
import 'package:soleoserp/ui/res/dimen_resources.dart';
import 'package:soleoserp/ui/res/image_resources.dart';

Widget getCommonTextFormField(BuildContext context, ThemeData baseTheme,
    {String title: "",
    TextInputAction textInputAction: TextInputAction.next,
    bool obscureText: false,
    EdgeInsetsGeometry contentPadding:
        const EdgeInsets.only(top: 0, bottom: 10),
    int maxLength: 1000,
    TextAlign textAlign: TextAlign.left,
    TextEditingController controller,
    TextInputType keyboardType,
    FormFieldValidator<String> validator,
    int maxLines: 1,
    Function(String) onSubmitted,
    Function(String) onTextChanged,
    TextStyle titleTextStyle,
    TextCapitalization textCapitalization = TextCapitalization.none,
    TextStyle inputTextStyle,
    List<TextInputFormatter> inputFormatter,
    bool readOnly: false,
    Widget suffixIcon}) {
  if (titleTextStyle == null) {
    titleTextStyle = baseTheme.textTheme.subtitle2;
  }
  if (inputTextStyle == null) {
    inputTextStyle = baseTheme.textTheme.bodyText2;
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      title.isNotEmpty
          ? Text(
              title,
              style: titleTextStyle,
            )
          : Container(),
      TextFormField(
        textCapitalization: textCapitalization,
        inputFormatters: inputFormatter,
        keyboardType: keyboardType,
        style: inputTextStyle,
        textAlign: textAlign,
        maxLines: maxLines,
        cursorColor: colorPrimaryLight,
        textInputAction: textInputAction,
        obscureText: obscureText,
        readOnly: readOnly,
        maxLength: maxLength,
        controller: controller,
        obscuringCharacter: "*",
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.only(bottom: 5),
          suffixIcon: suffixIcon,
          counterText: "",
          errorStyle: baseTheme.textTheme.subtitle1.copyWith(
              color: Colors.red, fontSize: CAPTION_SMALLER_TEXT_FONT_SIZE),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: colorGrayDark, width: 0.4),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: colorPrimaryLight, width: 1),
          ),
        ),
        validator: validator,
        onChanged: onTextChanged,
        onFieldSubmitted: onSubmitted,
      )
    ],
  );
}

Widget getCommonTextFormFieldFloating(BuildContext context, ThemeData baseTheme,
    {String title: "",
    TextInputAction textInputAction: TextInputAction.next,
    bool obscureText: false,
    EdgeInsetsGeometry contentPadding:
        const EdgeInsets.only(top: 0, bottom: 14),
    int maxLength: 1000,
    TextEditingController controller,
    TextInputType keyboardType,
    FormFieldValidator<String> validator,
    int maxLines: 1,
    Function(String) onSubmitted,
    Function(String) onTextChanged,
    EdgeInsetsGeometry margin: const EdgeInsets.only(top: 30),
    TextStyle titleTextStyle,
    TextCapitalization textCapitalization = TextCapitalization.none,
    TextStyle inputTextStyle,
    List<TextInputFormatter> inputFormatters,
    bool readOnly: false,
    double labelHeight: 0.4,
    Widget suffixIcon}) {
  if (titleTextStyle == null) {
    titleTextStyle =
        baseTheme.textTheme.bodyText2.copyWith(height: labelHeight);
  }
  if (inputTextStyle == null) {
    inputTextStyle = baseTheme.textTheme.bodyText1;
  }
  if (onSubmitted == null && textInputAction == TextInputAction.next) {
    onSubmitted = (value) {
      FocusScope.of(context).nextFocus();
    };
  }
  return Container(
    margin: margin,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: TextFormField(
            textCapitalization: textCapitalization,
            inputFormatters: inputFormatters,
            cursorColor: colorPrimaryLight,
            keyboardType: keyboardType,
            style: inputTextStyle,
            maxLines: maxLines,
            textInputAction: textInputAction,
            obscureText: obscureText,
            readOnly: readOnly,
            maxLength: maxLength,
            controller: controller,
            obscuringCharacter: "*",
            decoration: InputDecoration(
              labelText: title,
              hintStyle: titleTextStyle,
              labelStyle: titleTextStyle,
              suffixIcon: suffixIcon,
              counterText: "",
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              contentPadding: contentPadding,
              errorStyle: baseTheme.textTheme.subtitle1.copyWith(
                  color: Colors.red, fontSize: CAPTION_SMALLER_TEXT_FONT_SIZE),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: colorTextTitleGray, width: 0.4),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: colorPrimaryLight, width: 1),
              ),
            ),
            validator: validator,
            onChanged: onTextChanged,
          ),
          margin: EdgeInsets.only(top: 0),
        )
      ],
    ),
  );
}

Widget getCommonTextFormFieldFloatingWithCustomError(
    BuildContext context, ThemeData baseTheme,
    {String title: "",
    TextInputAction textInputAction: TextInputAction.next,
    bool obscureText: false,
    EdgeInsetsGeometry contentPadding:
        const EdgeInsets.only(top: 0, bottom: 14),
    int maxLength: 1000,
    CustomTextEditingController customController,
    TextInputType keyboardType,
    GestureTapCallback onTap,
    Function validator,
    int maxLines: 1,
    Function(String) onSubmitted,
    Function(String) onTextChanged,
    FocusNode focusNode,
    EdgeInsetsGeometry margin: const EdgeInsets.only(top: 30),
    TextStyle titleTextStyle,
    TextCapitalization textCapitalization = TextCapitalization.none,
    TextStyle inputTextStyle,
    List<TextInputFormatter> inputFormatters,
    bool readOnly: false,
    double labelHeight: 0.4,
    Widget suffixIcon}) {
  if (titleTextStyle == null) {
    titleTextStyle =
        baseTheme.textTheme.bodyText2.copyWith(height: labelHeight);
  }
  if (inputTextStyle == null) {
    inputTextStyle = baseTheme.textTheme.bodyText1;
  }

  final Widget widget = StatefulBuilder(
      builder: (BuildContext context, StateSetter updateWidget) {
    return Container(
      margin: margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: TextFormField(
              textCapitalization: textCapitalization,
              inputFormatters: inputFormatters,
              cursorColor: colorPrimaryLight,
              focusNode: focusNode,
              keyboardType: keyboardType,
              style: inputTextStyle,
              maxLines: maxLines,
              textInputAction: textInputAction,
              obscureText: obscureText,
              readOnly: readOnly,
              onFieldSubmitted: onSubmitted,
              onSaved: onSubmitted,
              maxLength: maxLength,
              onTap: onTap,
              controller: customController.controller,
              obscuringCharacter: "*",
              decoration: InputDecoration(
                labelText: title,
                hintStyle: titleTextStyle,
                labelStyle: titleTextStyle,
                suffixIcon: (suffixIcon != null || customController.showError)
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          suffixIcon == null
                              ? Container()
                              : Container(
                                  margin: EdgeInsets.only(left: 15),
                                  child: suffixIcon),
                          SizedBox(
                            width: customController.showError ? 5 : 0,
                          ),
                          customController.showError
                              ? Container(
                                  width: TEXT_FORM_FIELD_SUFFIX_ICON,
                                  child: Image.asset(
                                    IC_ERROR,
                                    width: TEXT_FORM_FIELD_SUFFIX_ICON,
                                    height: TEXT_FORM_FIELD_SUFFIX_ICON,
                                  ))
                              : Container(),
                        ],
                      )
                    : null,
                counterText: "",
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                contentPadding: contentPadding,
                errorStyle: baseTheme.textTheme.subtitle1.copyWith(
                    color: Colors.red,
                    fontSize: CAPTION_SMALLER_TEXT_FONT_SIZE),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: colorTextTitleGray, width: 0.4),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: colorPrimaryLight, width: 1),
                ),
              ),
              validator: (value) {
                updateWidget(() {
                  if (validator(value) != null) {
                    customController.showError = true;
                  } else {
                    customController.showError = false;
                  }
                });
                return validator(value);
              },
              onChanged: onTextChanged,
            ),
            margin: EdgeInsets.only(top: 0),
          )
        ],
      ),
    );
  });
  return widget;
}

Widget getCommonBoxTextFormField(
  ThemeData baseTheme, {
  String title: "",
  TextInputAction textInputAction: TextInputAction.next,
  bool obscureText: false,
  EdgeInsetsGeometry contentPadding: const EdgeInsets.all(5),
  int maxLength: 1000,
  double spaceBetweenTitleBox: 0,
  TextEditingController controller,
  TextInputType keyboardType,
  FormFieldValidator<String> validator,
  Function(String) onSubmitted,
  Function(String) onTextChanged,
  EdgeInsetsGeometry margin: const EdgeInsets.only(top: 30),
  TextStyle titleTextStyle,
  TextCapitalization textCapitalization = TextCapitalization.none,
  TextStyle inputTextStyle,
  int maxLines: 3,
  Color enabledBorderColor: colorGrayDark,
  Color focusedBorderColor: colorPrimaryDark,
  double boxRadius: 0,
  TextAlign textAlign = TextAlign.start,
  List<TextInputFormatter> inputFormatters,
}) {
  if (titleTextStyle == null) {
    titleTextStyle = baseTheme.textTheme.subtitle2;
  }
  if (inputTextStyle == null) {
    inputTextStyle = baseTheme.textTheme.bodyText2;
  }

  return Container(
    margin: margin,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title.isEmpty
            ? Container()
            : Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Text(
                  title,
                  style: titleTextStyle,
                ),
              ),
        Container(
          margin: EdgeInsets.only(top: spaceBetweenTitleBox),
          child: TextFormField(
            textCapitalization: textCapitalization,
            inputFormatters: inputFormatters,
            keyboardType: keyboardType,
            style: inputTextStyle,
            textInputAction: textInputAction,
            obscureText: obscureText,
            maxLength: maxLength,
            textAlign: textAlign,
            controller: controller,
            obscuringCharacter: "*",
            maxLines: maxLines,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              counterText: "",
              errorStyle: baseTheme.textTheme.subtitle1.copyWith(
                  color: Colors.red, fontSize: CAPTION_SMALLER_TEXT_FONT_SIZE),
              contentPadding: contentPadding,
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: enabledBorderColor, width: 0.4),
                  borderRadius: BorderRadius.circular(boxRadius)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: focusedBorderColor, width: 1),
                  borderRadius: BorderRadius.circular(boxRadius)),
            ),
            validator: validator,
            onChanged: onTextChanged,
            onFieldSubmitted: onSubmitted,
          ),
        )
      ],
    ),
  );
}

Widget getCommonBottomSheetTitleView({
  @required ThemeData baseTheme,
  @required BuildContext context,
  @required String title,
  String actionTitle = "",
  GestureTapCallback onActionButtonTap,
}) {
  return Container(
    height: 35,
    margin: const EdgeInsets.only(top: 5),
    child: Stack(
      alignment: Alignment.centerLeft,
      children: <Widget>[
        Container(
          width: double.maxFinite,
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: baseTheme.textTheme.bodyText1,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Image.asset(IC_CLOSE),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            InkWell(
              onTap: onActionButtonTap,
              child: Container(
                margin: const EdgeInsets.only(left: 20, right: 20),
                child: Text(
                  actionTitle,
                  style: baseTheme.textTheme.caption,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget getCircleImage(String url, double radius,
    {String errorPlaceHolderImage = IC_USER_IMAGE_PLACEHOLDER,
    Widget loader,
    Color errorPlaceHolderBackgroundColor: Colors.transparent,
    File imageFile,
    Color loaderColor: colorPrimaryDark}) {
  if (url == null) {
    url = "";
  }
  return ClipRRect(
    borderRadius: BorderRadius.circular(radius),
    child: imageFile == null
        ? Image.network(
            url,
            width: radius,
            height: radius,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Center(
                  child: Container(
                height: radius,
                width: radius,
                decoration: BoxDecoration(
                    color: errorPlaceHolderBackgroundColor,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(
                          errorPlaceHolderImage,
                        ))),
              ));
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return loader == null
                  ? Container(
                      width: radius,
                      height: radius,
                      child: Stack(
                        children: [
                          Center(
                              child: Container(
                            height: radius,
                            width: radius,
                            decoration: BoxDecoration(
                                color: errorPlaceHolderBackgroundColor,
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage(
                                      errorPlaceHolderImage,
                                    ))),
                          )),
                          Center(
                            child: Container(
                              width: radius / 2,
                              height: radius / 2,
                              child: Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      loaderColor),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : loader;
            },
          )
        : Image.file(
            imageFile,
            fit: BoxFit.cover,
            width: radius,
            height: radius,
          ),
  );
}

Widget getSquareImage(String url, double width, double height,
    {String errorPlaceHolderImage = IC_USER_IMAGE_PLACEHOLDER,
    Widget loader,
    Color errorPlaceHolderBackgroundColor = Colors.transparent,
    Color loaderColor: colorPrimaryDark}) {
  if (url == null) {
    url = "";
  }
  return Container(
    width: width,
    height: height,
    color: errorPlaceHolderBackgroundColor,
    child: Image.network(
      url,
      width: width,
      height: height,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Center(
            child: Container(
          height: width,
          width: height,
          decoration: BoxDecoration(
              color: errorPlaceHolderBackgroundColor,
              shape: BoxShape.circle,
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(
                    errorPlaceHolderImage,
                  ))),
        ));
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return loader == null
            ? Container(
                width: width,
                height: height,
                child: Stack(
                  children: [
                    Center(
                        child: Image.asset(
                      errorPlaceHolderImage,
                      height: width,
                      color: errorPlaceHolderBackgroundColor,
                      fit: BoxFit.cover,
                      width: width,
                    )),
                    Center(
                      child: Container(
                        width: width / 2,
                        height: height / 2,
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(loaderColor),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : loader;
      },
    ),
  );
}

Widget getCommonImage(String path,
    {double width: double.maxFinite,
    double height,
    BoxFit fit: BoxFit.fitWidth,
    Widget errorWidget}) {
  return Image.network(
    path,
    width: width,
    height: height,
    fit: fit,
    errorBuilder: (context, error, stackTrace) {
      print("Error loading image - $path\n$error");
      if (errorWidget != null) {
        return errorWidget;
      }
      return Container();
    },
  );
}

Widget getCommonEmptyView({message: "No data found"}) {
  return Center(
    child: Text(
      message,
      style: TextStyle(fontSize: 16),
    ),
  );
}

Widget getCommonDivider({double thickness, double width: double.maxFinite}) {
  if (thickness == null) {
    thickness = COMMON_DIVIDER_THICKNESS;
  }
  return Container(
    height: thickness,
    color: colorGray,
    width: width,
  );
}

Widget getCommonVerticalDivider(
    {double thickness, double height: double.maxFinite}) {
  if (thickness == null) {
    thickness = COMMON_DIVIDER_THICKNESS;
  }
  return Container(
    width: thickness,
    color: colorGray,
    height: height,
  );
}

///add here common header if app have in each screen
Widget getCommonHeaderLogo() {
  //TODO
}

Widget getCommonButtonWithImage(
    ThemeData baseTheme, Function onPressed, String text, String image,
    {Color textColor: colorWhite,
    Color backGroundColor: colorPrimary,
    double elevation: 5.0,
    double radius: COMMON_BUTTON_RADIUS}) {
  return Container(
    height: 50,
    child: RaisedButton(
      onPressed: onPressed,
      padding: EdgeInsets.only(left: 20.0, right: 10),
      color: backGroundColor,
      shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.all(Radius.circular(COMMON_BUTTON_RADIUS))),
      elevation: elevation,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Image.asset(
              image,
              height: 22,
              fit: BoxFit.fitHeight,
            ),
          ),
          Text(
            text,
            style: baseTheme.textTheme.button.copyWith(color: textColor),
          ),
        ],
      ),
    ),
  );
}

Widget getCommonButton(ThemeData baseTheme, Function onPressed, String text,
    {Color textColor: colorWhite,
    Color backGroundColor: colorPrimary,
    double elevation: 0.0,
    bool showOnlyBorder: false,
    Color borderColor: colorPrimary,
    double textSize: BUTTON_TEXT_FONT_SIZE,
    double width: double.maxFinite,
    double height: COMMON_BUTTON_HEIGHT,
    double radius: COMMON_BUTTON_RADIUS}) {
  if (!showOnlyBorder) {
    borderColor = backGroundColor;
  }
  return Container(
    width: width,
    height: height,
    child: RaisedButton(
      onPressed: onPressed,
      color: backGroundColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(radius)),
          side: BorderSide(width: showOnlyBorder ? 2 : 0, color: borderColor)),
      elevation: elevation,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: baseTheme.textTheme.button
            .copyWith(color: textColor, fontSize: textSize),
      ),
    ),
  );
}

Widget getCommonAppBar(
  BuildContext context,
  ThemeData baseTheme,
  String title, {
  Function onTapOfBack,
  bool showBack: true,
}) {
  return Container(
    height: DEFAULT_APP_BAR_HEIGHT,
    padding: EdgeInsets.only(
        left: DEFAULT2_LEFT_MARGIN,
        right: DEFAULT_APPBAR_NOTIFICATION_RIGHT_MARGIN,
        bottom: DEFAULT_APPBAR_BOTTOM_MARGIN),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            margin: EdgeInsets.only(top: DEFAULT_APPBAR_TOP_MARGIN),
            child: Row(
              children: [
                showBack
                    ? InkWell(
                        onTap: () {
                          if (onTapOfBack == null) {
                            Navigator.of(context).pop();
                          } else {
                            onTapOfBack();
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                              top: 12, right: 20, bottom: 10, left: 10),
                          child: Image.asset(
                            IC_BACK,
                            width: 18,
                            height: 18,
                            color: colorWhite,
                          ),
                        ),
                      )
                    : Container(),
                Expanded(
                  child: Text(
                    title,
                    style: baseTheme.textTheme.headline4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Container getDropDown(List<String> data, String selected, BuildContext context,
    ThemeData baseTheme, Function f) {
  return Container(
    height: 50,
    width: MediaQuery.of(context).size.width,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5),
    ),
    child: Row(
      children: [
        Expanded(
          child: Container(
            margin: EdgeInsets.only(left: 12, right: 20),
            child: DropdownButton(
                underline: Container(),
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                icon: Container(
                  child: RotationTransition(
                    turns: AlwaysStoppedAnimation(0 / 360),
                    child: Center(
                      child: Image.asset(
                        IC_DROP_DOWN_ARROW,
                        width: 20,
                        height: 20,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                isExpanded: true,
                value: selected,
                items: data
                    .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e, style: baseTheme.textTheme.bodyText1)))
                    .toList(),
                onChanged: f),
          ),
        ),
      ],
    ),
  );
}

class CustomAnimatedPadding extends StatelessWidget {
  final Widget child;

  CustomAnimatedPadding({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return new AnimatedContainer(
        padding: mediaQuery.viewInsets,
        duration: const Duration(milliseconds: 300),
        child: child);
  }
}
