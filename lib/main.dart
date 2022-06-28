import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:soleoserp/ui/res/localizations/app_localizations.dart';
import 'package:soleoserp/ui/res/style_resources.dart';
import 'package:soleoserp/ui/screens/PaginationScreen/pagination_list_screen.dart';
import 'package:soleoserp/ui/screens/authentication/first_screen.dart';
import 'package:soleoserp/utils/general_utils.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();

  ///handles screen transaction based on route name
  static MaterialPageRoute globalGenerateRoute(RouteSettings settings) {
    //if screen have no argument to pass data in next screen while transiting
    if (settings.name == FirstScreen.routeName) {
      return getMaterialPageRoute(FirstScreen());
    }
    if (settings.name == PaginationListScreen.routeName) {
      return getMaterialPageRoute(PaginationListScreen());
    }

    //if screen have arguments to pass data in next screen while transiting
    /*   if (settings.name == ScreenName.routeName) {
      return getMaterialPageRoute(settings.arguments);
    }*/
    return null;
  }
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        onGenerateRoute: MyApp.globalGenerateRoute,
        debugShowCheckedModeBanner: false,
        supportedLocales: [
          Locale('en', 'US'),
        ],
        localizationsDelegates: [
          // A class which loads the translations from JSON files
          AppLocalizations.delegate,
          // Built-in localization of basic text for Material widgets
          GlobalMaterialLocalizations.delegate,
          // Built-in localization for text direction LTR/RTL
          GlobalWidgetsLocalizations.delegate,
        ],
        // Returns a locale which will be used by the app
        localeResolutionCallback: (locale, supportedLocales) {
          // Check if the current device locale is supported
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.languageCode &&
                supportedLocale.countryCode == locale.countryCode) {
              return supportedLocale;
            }
          }
          // If the locale of the device is not supported, use the first one
          // from the list (English, in this case).
          return supportedLocales.first;
        },
        title: "Flutter base app",
        theme: buildAppTheme(),
        initialRoute: getInitialRoute());
  }

  ///returns initial route based on condition of logged in/out
  String getInitialRoute() {
    return PaginationListScreen.routeName;
  }
}
