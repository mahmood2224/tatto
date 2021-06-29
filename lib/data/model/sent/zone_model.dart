class ZonesResponse {
    List<Zone> data;
    String message;
    int status;

    ZonesResponse({this.data, this.message, this.status});

    factory ZonesResponse.fromJson(Map<String, dynamic> json) {
        return ZonesResponse(
            data: json['data'] != null ? (json['data'] as List).map((i) => Zone.fromJson(i)).toList() : null,
            message: json['message'], 
            status: json['status'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['message'] = this.message;
        data['status'] = this.status;
        if (this.data != null) {
            data['data'] = this.data.map((v) => v.toJson()).toList();
        }
        return data;
    }
}

class Zone {
    String created_at;
    int id;
    String shipping_price;
    String updated_at;
    String zone_code;
    String zone_name;
    bool open ;

    Zone({this.created_at, this.open, this.id, this.shipping_price, this.updated_at, this.zone_code, this.zone_name});

    factory Zone.fromJson(Map<String, dynamic> json) {
        return Zone(
            created_at: json['created_at'], 
            id: json['id'], 
            shipping_price: json['shipping_price'], 
            updated_at: json['updated_at'], 
            zone_code: json['zone_code'], 
            zone_name: json['zone_name'], 
            open:int.parse("${ json['open']??0}") == 1 ,
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['created_at'] = this.created_at;
        data['id'] = this.id;
        data['shipping_price'] = this.shipping_price;
        data['updated_at'] = this.updated_at;
        data['zone_code'] = this.zone_code;
        data['zone_name'] = this.zone_name;
        return data;
    }
}