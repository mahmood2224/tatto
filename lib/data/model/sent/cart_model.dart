import 'package:tato/data/model/sent/products_model.dart';

class CartResponse {
    List<Product> data;
    String message;
    int status;

    CartResponse({this.data, this.message, this.status});

    factory CartResponse.fromJson(Map<String, dynamic> json) {
        return CartResponse(
            data: json['data'] != null ? (json['data'] as List).map((i) => Product.fromJson(i)).toList() : null,
            message: json['message'], 
            status: json['status'], 
        );
    }


}

