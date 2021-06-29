import 'package:tato/data/model/sent/products_model.dart';

class SliderResponse {
    List<SliderImage> data;
    String message;
    int status;

    SliderResponse({this.data, this.message, this.status});

    factory SliderResponse.fromJson(Map<String, dynamic> json) {
        return SliderResponse(
            data: json['data'] != null ? (json['data'] as List).map((i) => SliderImage.fromJson(i)).toList() : null,
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

class SliderImage {
    String created_at;
    int id;
    String slider_image;
    String updated_at;
    Product product ;

    SliderImage({this.created_at, this.id, this.product,this.slider_image, this.updated_at});

    factory SliderImage.fromJson(Map<String, dynamic> json) {
        return SliderImage(
            created_at: json['created_at'], 
            id: json['id'], 
            slider_image: json['slider_image'], 
            updated_at: json['updated_at'],
            product: json['product_res'] == null ? null : Product.fromJson(json['product_res'])
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['created_at'] = this.created_at;
        data['id'] = this.id;
        data['slider_image'] = this.slider_image;
        data['updated_at'] = this.updated_at;
        return data;
    }
}