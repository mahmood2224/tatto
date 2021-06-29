class ProductResponse {
    List<Product> data;
    String message;
    int status;

    ProductResponse({this.data, this.message, this.status});

    factory ProductResponse.fromJson(Map<String, dynamic> json) {
        return ProductResponse(
            data: json['data'] != null ? (json['data'] as List).map((i) => Product.fromJson(i)).toList() : null,
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

class Product {
    int category_id;
    String desc;
    int id;
    String image;
    String name;
    String price;
    int qty;
    List<String> images;
    String ratings ;
    int original_qty;
    String total_price;
    String note ;
    String currency ;

    Product({this.category_id, this.images,this.ratings,this.original_qty,this.desc, this.id, this.image, this.name, this.price, this.qty, this.total_price , this.currency});

    factory Product.fromJson(Map<String, dynamic> json) {
        return Product(
            category_id: json['category_id'],
            desc: json['desc'],
            id: json['id'],
            image: json['image'],
            name: json['name'],
            images: json['images'] != null ? new List<String>.from(json['images']) : null,
            original_qty: json['original_qty'],
            price: "${json['price']??0.0}",
            qty: json['qty'],
            ratings: json['rating'],
            total_price:"${json['total_price'] ?? 0.0 }",
            currency: json['currency']
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['category_id'] = this.category_id;
        data['desc'] = this.desc;
        data['id'] = this.id;
        data['image'] = this.image;
        data['name'] = this.name;
        data['price'] = this.price;
        data['qty'] = this.qty;
        data['total_price'] = this.total_price;
        return data;
    }
}

class CartNoteModel{
    int cartProductId ;
    String note ;

    CartNoteModel({this.cartProductId, this.note});

    Map<String,String> toJson(){
        Map<String,String> data = new Map();
        data['id'] = "$cartProductId" ;
        data['note'] = note ;
        return data;
    }

}