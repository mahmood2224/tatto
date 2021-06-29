class CountsResponse {
    Count data;
    String message;
    int status;

    CountsResponse({this.data, this.message, this.status});

    factory CountsResponse.fromJson(Map<String, dynamic> json) {
        return CountsResponse(
            data: json['data'] != null ? Count.fromJson(json['data']) : null,
            message: json['message'], 
            status: json['status'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['message'] = this.message;
        data['status'] = this.status;
        if (this.data != null) {
            data['data'] = this.data.toJson();
        }
        return data;
    }
}

class Count {
    int count;
    double total_price;
    String currency ;


    Count({this.count, this.total_price , this.currency});

    factory Count.fromJson(Map<String, dynamic> json) {
        return Count(
            count: int.parse("${json['count']??0}"),
            total_price: double.parse("${json['total_price']??0}"),
            currency: json['currency']
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['count'] = this.count;
        data['total_price'] = this.total_price;
        return data;
    }
}