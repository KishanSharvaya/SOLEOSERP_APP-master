import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:soleoserp/models/Request/paginationRequest.dart';
import 'package:soleoserp/models/Response/paginationResponse.dart';
import 'package:soleoserp/utils/shared_pref_helper.dart';

import 'api_client.dart';
import 'error_response_exception.dart';

// will be user for user related api calling and data processing
class Repository {
  SharedPrefHelper prefs = SharedPrefHelper.instance;
  final ApiClient apiClient;

  Repository({@required this.apiClient});

  static Repository getInstance() {
    return Repository(apiClient: ApiClient(httpClient: http.Client()));
  }

  ///add your functions of api calls as below
  Future<PaginationResponse> paginationAPI(
      PaginationRequest paginationRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT, paginationRequest.toJson());
      PaginationResponse paginationResponse = PaginationResponse.fromJson(json);
      return paginationResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }
}
