import 'package:flutter/material.dart';

const int COLLECTION = 2 ;
const int DELIVERY = 1 ;
const int PLACE = 3 ;

class OrdersResponse {
    List<Order> data;
    String message;
    int status;

    OrdersResponse({this.data, this.message, this.status});

    factory OrdersResponse.fromJson(Map<String, dynamic> json) {
        return OrdersResponse(
            data: json['data'] != null ? (json['data'] as List).map((i) => Order.fromJson(i)).toList() : null,
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

class Order {
    String address;
    String created_at;
    int id;
    String lat;
    String lng;
    String name;
    String phone;
    double shipping_price;
    int status;
    double total_price;
    double discount ;
    String updated_at;
    int user_id;
    int zone_id;
    String currency ;

    Order({this.address, this.currency,this.created_at,this.discount, this.id, this.lat, this.lng, this.name, this.phone, this.shipping_price, this.status, this.total_price, this.updated_at, this.user_id, this.zone_id});

    factory Order.fromJson(Map<String, dynamic> json) {
        return Order(
            address: json['address'], 
            created_at: json['created_at'], 
            id: json['id'], 
            lat: json['lat'], 
            lng: json['lng'], 
            name: json['name'], 
            phone: json['phone'], 
            shipping_price: double.parse("${json['shipping_price']}"),
            status: json['status'], 
            total_price: double.parse("${json['total_price']}") ,
            discount:double.parse("${ json['discount']??0}"),
            updated_at: json['updated_at'],
            user_id: json['user_id'], 
            zone_id: json['zone_id'],
            currency: json['currency']
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['address'] = this.address;
        data['created_at'] = this.created_at;
        data['id'] = this.id;
        data['lat'] = this.lat;
        data['lng'] = this.lng;
        data['name'] = this.name;
        data['phone'] = this.phone;
        data['shipping_price'] = this.shipping_price;
        data['status'] = this.status;
        data['total_price'] = this.total_price;
        data['updated_at'] = this.updated_at;
        data['user_id'] = this.user_id;
        data['zone_id'] = this.zone_id;
        return data;
    }
}

Color getOrderStatusColor(int status){
    switch(status){
        case 1 :
            return Color(0xffF3A521);
        case 2 :
            return Color(0xff001EED);
        case 3 :
            return Color(0xff6ED540);
        case 4 :
            return Color(0xffF14272);
        default:
            return Color(0xffF3A521);
    }
}


String getOrderStatusString(int status){
    switch(status){
        case 1 :
            return "قيد الانتظار";
        case 2 :
            return "تم التجهيز";
        case 3 :
            return "تم الاستلام";
        case 4 :
            return "تم الرفض";
        default:
            return "قيد الانتظار";
    }
}