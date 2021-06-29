class GeneralResponse {
  String message;
  int status;

  GeneralResponse({ this.message, this.status});

  factory GeneralResponse.fromJson(Map<String, dynamic> json) {
    return GeneralResponse(
      message: json['message'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}