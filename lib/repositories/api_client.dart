import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:soleoserp/utils/date_time_extensions.dart';
import 'package:soleoserp/utils/shared_pref_helper.dart';

import 'custom_exception.dart';

class ApiClient {
  ///set apis' base url here
  static const BASE_URL = 'http://205.134.254.135/';

  ///add end point of your apis as below
  //static const END_POINT_API_NAME = 'add end point of api';

  static const END_POINT = "~mobile/MtProject/public/api/product_list.php";

  final http.Client httpClient;

  ApiClient({this.httpClient});

  ///GET api call
  Future<dynamic> apiCallGet(String url, {String query = ""}) async {
    var responseJson;
    var getUrl;

    if (query.isNotEmpty) {
      getUrl = '$BASE_URL$url?$query';
    } else {
      getUrl = '$BASE_URL$url';
    }

    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    print("Api request url : $getUrl");
    String authToken =
        "eyJhdWQiOiI1IiwianRpIjoiMDg4MmFiYjlmNGU1MjIyY2MyNjc4Y2FiYTQwOGY2MjU4Yzk5YTllN2ZkYzI0NWQ4NDMxMTQ4ZWMz";
    //SharedPrefHelper.instance.getString(SharedPrefHelper.AUTH_TOKEN_STRING);
    if (authToken != null && authToken.isNotEmpty) {
      headers['token'] = "$authToken";
    }

    try {
      String timeZone = await getCurrentTimeZone();
      if (timeZone != null && timeZone.isNotEmpty) {
        headers['timeZone'] = timeZone;
      }
    } catch (e) {}
    print("Api request url : $getUrl\nHeaders - $headers");

    try {
      final response = await httpClient
          .get(Uri.parse(getUrl), headers: headers)
          .timeout(const Duration(seconds: 60));
      responseJson = await _response(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  ///POST api call
  Future<dynamic> apiCallPost(
    String url,
    Map<String, dynamic> requestJsonMap, {
    String baseUrl = BASE_URL,
    bool showSuccessDialog = false,
  }) async {
    var responseJson;
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    /*  String authToken =
        SharedPrefHelper.instance.getString(SharedPrefHelper.AUTH_TOKEN_STRING);*/

    String authToken =
        "eyJhdWQiOiI1IiwianRpIjoiMDg4MmFiYjlmNGU1MjIyY2MyNjc4Y2FiYTQwOGY2MjU4Yzk5YTllN2ZkYzI0NWQ4NDMxMTQ4ZWMz";
    if (authToken != null && authToken.isNotEmpty) {
      headers['token'] = "$authToken";
    }

    try {
      String timeZone = await getCurrentTimeZone();
      if (timeZone != null && timeZone.isNotEmpty) {
        headers['timeZone'] = timeZone;
      }
    } catch (e) {}
    print("Headers - $headers");
    print(
        "Api request url : $baseUrl$url\nHeaders - $headers\nApi request params : $requestJsonMap");
    try {
      final response = await httpClient
          .post(Uri.parse("$baseUrl$url"),
              headers: headers,
              body:
                  (requestJsonMap == null) ? null : json.encode(requestJsonMap))
          .timeout(const Duration(seconds: 60));

      responseJson =
          await _response(response, showSuccessDialog: showSuccessDialog);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw FetchDataException('Request time out');
    }
    return responseJson;
  }

  ///PUT api call with multipart and single image
  Future<dynamic> apiCallPutMultipart(
      String url, Map<String, String> requestJsonMap,
      {File imageFileToUpload, String baseUrl = BASE_URL}) async {
    var responseJson;
    print("$baseUrl$url\n$requestJsonMap");
    Map<String, String> headers = {};
    String authToken =
        SharedPrefHelper.instance.getString(SharedPrefHelper.AUTH_TOKEN_STRING);
    if (authToken != null && authToken.isNotEmpty) {
      headers['access-token'] = "$authToken";
    }

    try {
      String timeZone = await getCurrentTimeZone();
      if (timeZone != null && timeZone.isNotEmpty) {
        headers['timeZone'] = timeZone;
      }
    } catch (e) {}
    print(
        "Api request url : $baseUrl$url\nHeaders - $headers\nApi request params : $requestJsonMap");

    final request = http.MultipartRequest("PUT", Uri.parse("$baseUrl$url"));
    request.fields.addAll(requestJsonMap);
    request.headers.addAll(headers);

    if (imageFileToUpload != null) {
      var pic =
          await http.MultipartFile.fromPath("image", imageFileToUpload.path);
      request.files.add(pic);
    }

    try {
      final streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      responseJson = await _response(response);
      return responseJson;
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw FetchDataException('Request time out');
    }
    return responseJson;
  }

  ///PUT api call with multipart and single image
  ///AWS api call
  Future<void> awsApiCallPut(
    String url,
    Map<String, String> requestJsonMap, {
    @required File imageFileToUpload,
  }) async {
    print("$url\n$requestJsonMap");
    print("Api request url : $url\nApi request params : $requestJsonMap");
    try {
      Uint8List bytes = imageFileToUpload.readAsBytesSync();

      var responseJson = await http.put(Uri.parse(url), body: bytes, headers: {
        "Content-Type":
            "image/${path.extension(imageFileToUpload.path).substring(1)}"
      });
      if (responseJson.statusCode == 200) {
        //uploaded successfully
        print("Response - ${responseJson.body}");
      } else {
        //uploading failed
        throw BadRequestException(
            "Uploading file operation failed, please try again later");
      }
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw FetchDataException('Request time out');
    } catch (e) {
      print("exception e - $e");
      throw e;
    }
  }

  ///POST api call with multipart and multiple image
  Future<dynamic> apiCallPostMultipart(
      String url, Map<String, String> requestJsonMap,
      {List<File> imageFilesToUpload,
      String baseUrl = BASE_URL,
      String imageFieldKey = "image",
      bool showSuccessDialog: false}) async {
    var responseJson;
    print("$baseUrl$url\n$requestJsonMap");
    Map<String, String> headers = {};
    String authToken =
        SharedPrefHelper.instance.getString(SharedPrefHelper.AUTH_TOKEN_STRING);
    if (authToken != null && authToken.isNotEmpty) {
      headers['access-token'] = "$authToken";
    }

    try {
      String timeZone = await getCurrentTimeZone();
      if (timeZone != null && timeZone.isNotEmpty) {
        headers['timeZone'] = timeZone;
      }
    } catch (e) {}
    print(
        "Api request url : $baseUrl$url\nHeaders - $headers\nApi request params : $requestJsonMap");

    final request = http.MultipartRequest("POST", Uri.parse("$baseUrl$url"));
    if (requestJsonMap != null) {
      request.fields.addAll(requestJsonMap);
    }
    request.headers.addAll(headers);

    if (imageFilesToUpload != null) {
      imageFilesToUpload.forEach((element) async {
        if (element != null) {
          var pic =
              await http.MultipartFile.fromPath(imageFieldKey, element.path);
          request.files.add(pic);
        }
      });
    }

    try {
      final streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      responseJson =
          await _response(response, showSuccessDialog: showSuccessDialog);
      return responseJson;
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw FetchDataException('Request time out');
    }
    return responseJson;
  }

  ///PUT api call
  Future<dynamic> apiCallPut(String url, Map<String, dynamic> requestJsonMap,
      {String baseUrl = BASE_URL, bool showSuccessDialog = false}) async {
    var responseJson;
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    String authToken =
        SharedPrefHelper.instance.getString(SharedPrefHelper.AUTH_TOKEN_STRING);
    if (authToken != null && authToken.isNotEmpty) {
      headers['access-token'] = "$authToken";
    }

    try {
      String timeZone = await getCurrentTimeZone();
      if (timeZone != null && timeZone.isNotEmpty) {
        headers['timeZone'] = timeZone;
      }
    } catch (e) {}

    print(
        "Api request url : $baseUrl$url\nHeaders - $headers\nApi request params : $requestJsonMap");
    try {
      final response = await httpClient
          .put(Uri.parse("$baseUrl$url"),
              headers: headers,
              body:
                  (requestJsonMap == null) ? null : json.encode(requestJsonMap))
          .timeout(const Duration(seconds: 60));
      responseJson =
          await _response(response, showSuccessDialog: showSuccessDialog);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw FetchDataException('Request time out');
    }
    return responseJson;
  }

  ///DELETE api call
  Future<dynamic> apiCallDelete(String url, Map<String, dynamic> requestJsonMap,
      {String baseUrl = BASE_URL, bool showSuccessDialog = false}) async {
    var responseJson;
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    String authToken =
        SharedPrefHelper.instance.getString(SharedPrefHelper.AUTH_TOKEN_STRING);
    if (authToken != null && authToken.isNotEmpty) {
      headers['access-token'] = "$authToken";
    }
    print("$baseUrl$url");

    try {
      String timeZone = await getCurrentTimeZone();
      if (timeZone != null && timeZone.isNotEmpty) {
        headers['timeZone'] = timeZone;
      }
    } catch (e) {}
    print(
        "Api request url : $baseUrl$url\nHeaders - $headers\nApi request params : $requestJsonMap");

    try {
      final response = await httpClient
          .delete(Uri.parse("$baseUrl$url"),
              headers: headers,
              body:
                  (requestJsonMap == null) ? null : json.encode(requestJsonMap))
          .timeout(const Duration(seconds: 60));
      responseJson =
          await _response(response, showSuccessDialog: showSuccessDialog);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw FetchDataException('Request time out');
    }
    return responseJson;
  }

  ///handling whole response
  ///decrypts response and checks for all status code error
  ///returns "data" object response if status is success
  Future<dynamic> _response(http.Response response,
      {bool showSuccessDialog = false}) async {
    debugPrint("Api response\n${response.body}");
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body);

        return responseJson;
      /*final data = responseJson["data"];
        final message = responseJson["message"];

        if (responseJson["status"] == 1) {
          if (showSuccessDialog) {
            await showCommonDialogWithSingleOption(Globals.context, message,
                positiveButtonTitle: "OK");
          }
          return data;
        }
        if (data is Map<String, dynamic>) {
          throw ErrorResponseException(data, message);
        }
        throw ErrorResponseException(null, message);*/
      case 400:
        var responseJson = json.decode(response.body);
        final message = responseJson["message"];
        throw BadRequestException(message.toString());
      case 401:
        var responseJson = json.decode(response.body);
        final message = responseJson["message"];
        throw UnauthorisedException(message.toString());
      case 403:
        var responseJson = json.decode(response.body);
        final message = responseJson["message"];
        throw UnauthorisedException(message.toString());
      case 404:
        var responseJson = json.decode(response.body);
        final message = responseJson["message"];
        throw NotFoundException(message.toString());
      case 500:
        var responseJson = json.decode(response.body);
        final message = responseJson["message"];
        throw ServerErrorException(message.toString());
      default:
        throw FetchDataException(
            'Error occurred while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
