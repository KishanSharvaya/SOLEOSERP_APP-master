class PaginationRequest {
  String page;
  String perPage;
  PaginationRequest({this.page, this.perPage});

  PaginationRequest.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    perPage = json['perPage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page'] = this.page;
    data['perPage'] = this.perPage;

    return data;
  }
}
