import 'package:tato/data/model/sent/products_model.dart';

class CategoryResponse {
    List<CategoryModel> data;
    String message;
    int status;

    CategoryResponse({this.data, this.message, this.status});

    factory CategoryResponse.fromJson(Map<String, dynamic> json) {
        return CategoryResponse(
            data: json['data'] != null ? (json['data'] as List).map((i) => CategoryModel.fromJson(i)).toList() : null,
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

class CategoryModel {
    List<Product> dishes;
    int id;
    String image;
    String name;

    CategoryModel({this.dishes, this.id, this.image, this.name});

    factory CategoryModel.fromJson(Map<String, dynamic> json) {
        return CategoryModel(
            dishes: json['dishes'] != null ? (json['dishes'] as List).map((i) => Product.fromJson(i)).toList() : null,
            id: json['id'], 
            image: json['image'], 
            name: json['name'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['id'] = this.id;
        data['image'] = this.image;
        data['name'] = this.name;

        return data;
    }
}

