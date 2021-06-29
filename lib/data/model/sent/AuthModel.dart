class AuthResponse {
    User data;
    String message;
    int status;

    AuthResponse({this.data, this.message, this.status});

    factory AuthResponse.fromJson(Map<String, dynamic> json) {
        return AuthResponse(
            data: json['data'] != null ? User.fromJson(json['data']) : null,
            message: json['message'], 
            status: json['status'], 
        );
    }


}

class User {
    String created_at;
    String fcmToken;
    int id;
    String mac_address;
    String token;
    String updated_at;

    User({this.created_at, this.fcmToken, this.id, this.mac_address, this.token, this.updated_at});

    factory User.fromJson(Map<String, dynamic> json) {
        return User(
            created_at: json['created_at'], 
            fcmToken: json['fcmToken'] ,
            id: json['id'], 
            mac_address: json['mac_address'], 
            token: json['token'], 
            updated_at: json['updated_at'], 
        );
    }


}