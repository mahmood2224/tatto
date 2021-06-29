class NotificationResponse {
    List<NotificationModel> data;
    String message;
    int status;

    NotificationResponse({this.data, this.message, this.status});

    factory NotificationResponse.fromJson(Map<String, dynamic> json) {
        return NotificationResponse(
            data: json['data'] != null ? (json['data'] as List).map((i) => NotificationModel.fromJson(i)).toList() : null,
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

class NotificationModel {
    String created_at;
    String description;
    int forall;
    int id;
    String title;
    String updated_at;
    int user_id;

    NotificationModel({this.created_at, this.description, this.forall, this.id, this.title, this.updated_at, this.user_id});

    factory NotificationModel.fromJson(Map<String, dynamic> json) {
        return NotificationModel(
            created_at: json['created_at'], 
            description: json['description'], 
            forall: json['forall'], 
            id: json['id'], 
            title: json['title'], 
            updated_at: json['updated_at'], 
            user_id: json['user_id'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['created_at'] = this.created_at;
        data['description'] = this.description;
        data['forall'] = this.forall;
        data['id'] = this.id;
        data['title'] = this.title;
        data['updated_at'] = this.updated_at;
        data['user_id'] = this.user_id;
        return data;
    }
}