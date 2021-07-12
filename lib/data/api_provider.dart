import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:tato/data/Localization.dart';
import 'package:tato/data/data_constatnts.dart';
import 'package:tato/data/model/sent/AuthModel.dart';
import 'package:tato/data/model/sent/about_us.dart';
import 'package:tato/data/model/sent/branch.dart';
import 'package:tato/data/model/sent/cart_model.dart';
import 'package:tato/data/model/sent/category_model.dart';
import 'package:tato/data/model/sent/settings_model.dart';
import 'package:tato/data/model/sent/counts_model.dart';
import 'package:tato/data/model/sent/general_model.dart';
import 'package:tato/data/model/sent/make_order.dart';
import 'package:tato/data/model/sent/notification_response.dart';
import 'package:tato/data/model/sent/orders_model.dart';
import 'package:tato/data/model/sent/products_model.dart';
import 'package:tato/data/model/sent/slider_image.dart';
import 'package:tato/data/model/sent/types_model.dart';
import 'package:tato/data/model/sent/zone_model.dart';
import 'package:tato/data/userData.dart';
import 'package:tato/utils/colors.dart';
import 'package:path/path.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:async/async.dart';
import 'package:easy_localization/easy_localization.dart';

class ApiProvider {
  static void getSlider(
      {onSuccess(List<SliderImage> images), onError()}) async {
    //API Calling
    String lang = await getLanguage();
    String token = await getToken();
    var headers;
    headers = {"lang": lang, "Authorization": token, ...apiHeaders};

    var url = Uri.parse("$BASE_URL$SLIDER_END_POINT");
    //data handling
    http.Response response =
        await http.get(url, headers: headers);

    // Decoding Response.
    Map<String, dynamic> decoded = json.decode(response.body);

    // Debugging API response
    debugApi(
        methodName: "get slider",
        statusCode: response.statusCode,
        response: decoded,
        data: null,
        endPoint: response.request.url,
        headers: headers);

    //exporting data into model
    SliderResponse responseData = SliderResponse.fromJson(decoded);
    if (isValidResponse(response.statusCode) && responseData.status == 1) {
      onSuccess(responseData.data);
    } else {
      onError();
    }
  }

  static void login({onSuccess(), onError()}) async {

    //API Calling
    var headers;
    headers = apiHeaders;
    final info = DeviceInfoPlugin() ;
    String macAddress ='' ;
    if(Platform.isIOS){
      IosDeviceInfo iosInfo = await info.iosInfo;
      macAddress = iosInfo.identifierForVendor ;
    }else{
      AndroidDeviceInfo androidInfo = await info.androidInfo ;
      macAddress = androidInfo.androidId ;
    }

    var data = json.encode({"mac_address":macAddress});
    var url = Uri.parse("$BASE_URL$LOGIN_END_POINT");
    
    http.Response response = await http.post(
        url,
        headers: headers ,body: data);

    // Decoding Response.
    Map<String, dynamic> decoded = json.decode(response.body);

    // Debugging API response
    debugApi(
        methodName: "login",
        statusCode: response.statusCode,
        response: decoded,
        data:  null,
        endPoint: response.request.url,
        headers: headers);

    // modiling
    AuthResponse responseData = AuthResponse.fromJson(decoded);
    if (isValidResponse(response.statusCode) && responseData.status == 1) {
      setUserData(data: responseData.data);
      saveFireBaseToken();
      onSuccess();
    }
    else
      onError();
  }


  static void getAllProducts(
      {String searchTxt, onSuccess(List<Product> products), onError()}) async {
    //API Calling
    String lang = await getLanguage();
    String token = await getToken();
    int userId = await getUserId();
    var headers;
    headers = {"lang": lang, "Authorization": token, ...apiHeaders};
    var url = Uri.parse("$BASE_URL$PRODUCTS_END_POINT${searchTxt != null ? "?search_txt=$searchTxt" : ""}");
    http.Response response = await http.get(
        url,
        headers: headers);

    // Decoding Response.
    Map<String, dynamic> decoded = json.decode(response.body);

    // Debugging API response
    debugApi(
        methodName: "get All Products",
        statusCode: response.statusCode,
        response: decoded,
        data: null,
        endPoint: response.request.url,
        headers: headers);

    // modiling
    ProductResponse responseData = ProductResponse.fromJson(decoded);
    if (isValidResponse(response.statusCode)) {
      onSuccess(responseData.data);
    } else
      onError();
  }

  static void getAllCategories(
      {onSuccess(List<CategoryModel> products), onError()}) async {
    //API Calling
    String lang = await getLanguage();
    String token = await getToken();
    int userId = await getUserId();
    var headers;
    headers = {"lang": lang, "Authorization": token, ...apiHeaders};
    var url = Uri.parse("$BASE_URL$CATEGORY_END_POINT");
    http.Response response =
        await http.get(url, headers: headers);

    // Decoding Response.
    Map<String, dynamic> decoded = json.decode(response.body);

    // Debugging API response
    debugApi(
        methodName: "get All categories",
        statusCode: response.statusCode,
        response: decoded,
        data: null,
        endPoint: response.request.url,
        headers: headers);

    // modiling
    CategoryResponse responseData = CategoryResponse.fromJson(decoded);
    if (isValidResponse(response.statusCode)) {
      onSuccess(responseData.data);
    } else
      onError();
  }

  static void addToCart(
      {@required String productId,
      int qty = 1,
      onSuccess(String msg, Count count),
      onError(String msg)}) async {
    //API Calling
    String lang = await getLanguage();
    String token = await getToken();
    int userId = await getUserId();
    var headers;
    headers = {"lang": lang, "Authorization": token, ...apiHeaders};

    //data handling
    var body = json.encode({"product_id": productId, "qty": qty});
    var url = Uri.parse("$BASE_URL$ADD_TO_CART_END_POINT");
    http.Response response = await http.post(url,
        headers: headers, body: body);

    // Decoding Response.
    Map<String, dynamic> decoded = json.decode(response.body);

    // Debugging API response
    debugApi(
        methodName: "add to cart ",
        statusCode: response.statusCode,
        response: decoded,
        data: body,
        endPoint: response.request.url,
        headers: headers);

    //exporting data into model
    CountsResponse responseData = CountsResponse.fromJson(decoded);
    if (isValidResponse(response.statusCode) && responseData.status == 1) {
      onSuccess(responseData.message, responseData.data);
    } else {
      onError(responseData.message);
    }
  }

  static void addNotesToCart(
      {@required List<CartNoteModel> products,
      onSuccess(String msg),
      onError(String msg)}) async {
    //API Calling
    String lang = await getLanguage();
    String token = await getToken();
    int userId = await getUserId();
    var headers;
    headers = {"lang": lang, "Authorization": token, ...apiHeaders};
    var url = Uri.parse("$BASE_URL$ADD_NOTES_TO_CART_END_POINT");
    //data handling
    var body = json.encode({"products": products});
    http.Response response = await http.post(
        url,
        headers: headers,
        body: body);

    // Decoding Response.
    Map<String, dynamic> decoded = json.decode(response.body);

    // Debugging API response
    debugApi(
        methodName: "add Notes to cart ",
        statusCode: response.statusCode,
        response: decoded,
        data: body,
        endPoint: response.request.url,
        headers: headers);

    //exporting data into model
    GeneralResponse responseData = GeneralResponse.fromJson(decoded);
    if (isValidResponse(response.statusCode) && responseData.status == 1) {
      onSuccess(responseData.message);
    } else {
      onError(responseData.message);
    }
  }

  static void removeFromCart(
      {@required productId,
      onSuccess(String msg, Count count),
      onError()}) async {
    //API Calling
    String lang = await getLanguage();
    String token = await getToken();
    int userId = await getUserId();
    var headers;
    headers = {"lang": lang, "Authorization": token, ...apiHeaders};
var url = Uri.parse("$BASE_URL$REMOVE_CART_END_POINT");
    //data handling
    var body = json.encode({"product_id": productId});
    http.Response response = await http.post(url,
        headers: headers, body: body);

    // Decoding Response.
    Map<String, dynamic> decoded = json.decode(response.body);

    // Debugging API response
    debugApi(
        methodName: "remove from cart ",
        statusCode: response.statusCode,
        response: decoded,
        data: body,
        endPoint: response.request.url,
        headers: headers);

    //exporting data into model
    CountsResponse responseData = CountsResponse.fromJson(decoded);
    if (isValidResponse(response.statusCode) && responseData.status == 1) {
      onSuccess(responseData.message, responseData.data);
    } else {
      onError();
    }
  }

  static void getCart({onSuccess(List<Product> products), onError()}) async {
    //API Calling
    String lang = await getLanguage();
    String token = await getToken();
    int userId = await getUserId();
    var headers;
    headers = {"lang": lang, "Authorization": token, ...apiHeaders};
    var url = Uri.parse("$BASE_URL$GET_CART_END_POINT");

    //data handling
    http.Response response =
        await http.get(url, headers: headers);

    // Decoding Response.
    Map<String, dynamic> decoded = json.decode(response.body);

    // Debugging API response
    debugApi(
        methodName: "get cart ",
        statusCode: response.statusCode,
        response: decoded,
        data: null,
        endPoint: response.request.url,
        headers: headers);

    //exporting data into model
    CartResponse responseData = CartResponse.fromJson(decoded);
    if (isValidResponse(response.statusCode) && responseData.status == 1) {
      onSuccess(responseData.data);
    } else {
      onError();
    }
  }

  static void getNotification(
      {onSuccess(List<NotificationModel> notification), onError()}) async {
    //API Calling
    String lang = await getLanguage();
    String token = await getToken();
    int userId = await getUserId();
    var headers;
    headers = {"lang": lang, "Authorization": token, ...apiHeaders};
    var url = Uri.parse("$BASE_URL$NOTIFICATION_END_POINT");

    //data handling
    http.Response response =
        await http.get(url, headers: headers);

    // Decoding Response.
    Map<String, dynamic> decoded = json.decode(response.body);

    // Debugging API response
    debugApi(
        methodName: "get notification ",
        statusCode: response.statusCode,
        response: decoded,
        data: null,
        endPoint: response.request.url,
        headers: headers);

    //exporting data into model
    NotificationResponse responseData = NotificationResponse.fromJson(decoded);
    if (isValidResponse(response.statusCode) && responseData.status == 1) {
      onSuccess(responseData.data);
    } else {
      onError();
    }
  }

  static void getOrders({onSuccess(List<Order> orders), onError()}) async {
    //API Calling
    String lang = await getLanguage();
    String token = await getToken();
    int userId = await getUserId();
    var headers;
    headers = {"lang": lang, "Authorization": token, ...apiHeaders};
    var url = Uri.parse("$BASE_URL$ORDER_END_POINT");

    //data handling
    http.Response response =
        await http.get(url, headers: headers);

    // Decoding Response.
    Map<String, dynamic> decoded = json.decode(response.body);

    // Debugging API response
    debugApi(
        methodName: "get orders ",
        statusCode: response.statusCode,
        response: decoded,
        data: null,
        endPoint: response.request.url,
        headers: headers);

    //exporting data into model
    OrdersResponse responseData = OrdersResponse.fromJson(decoded);
    if (isValidResponse(response.statusCode) && responseData.status == 1) {
      onSuccess(responseData.data);
    } else {
      onError();
    }
  }

  static void getCounts({onSuccess(Count count), onError()}) async {
    //API Calling
    String lang = await getLanguage();
    String token = await getToken();
    int userId = await getUserId();
    var headers;
    headers = {"lang": lang, "Authorization": token, ...apiHeaders};
    var url = Uri.parse("$BASE_URL$COUNT_END_POINT");

    //data handling
    http.Response response =
        await http.get(url, headers: headers);

    // Decoding Response.
    Map<String, dynamic> decoded = json.decode(response.body);

    // Debugging API response
    debugApi(
        methodName: "get counts ",
        statusCode: response.statusCode,
        response: decoded,
        data: null,
        endPoint: response.request.url,
        headers: headers);

    //exporting data into model
    CountsResponse responseData = CountsResponse.fromJson(decoded);
    if (isValidResponse(response.statusCode) && responseData.status == 1) {
      onSuccess(responseData.data);
    } else {
      onError();
    }
  }

  static void getTypes({onSuccess(TypesModel types), onError()}) async {
    //API Calling
    String lang = await getLanguage();
    String token = await getToken();
    int userId = await getUserId();
    var headers;
    headers = {"lang": lang, "Authorization": token, ...apiHeaders};
    var url = Uri.parse("$BASE_URL$ORDER_TYPE_END_POINT");

    //data handling
    http.Response response =
        await http.get(url, headers: headers);

    // Decoding Response.
    Map<String, dynamic> decoded = json.decode(response.body);

    // Debugging API response
    debugApi(
        methodName: "get types ",
        statusCode: response.statusCode,
        response: decoded,
        data: null,
        endPoint: response.request.url,
        headers: headers);

    //exporting data into model
    TypeResponse responseData = TypeResponse.fromJson(decoded);
    if (isValidResponse(response.statusCode) && responseData.status == 1) {
      onSuccess(responseData.type);
    } else {
      onError();
    }
  }

  static void getAboutUs({onSuccess(AboutUsModel aboutUs), onError()}) async {
    //API Calling
    String lang = await getLanguage();
    String token = await getToken();
    int userId = await getUserId();
    var headers;
    headers = {"lang": lang, "Authorization": token, ...apiHeaders};
    var url = Uri.parse("$BASE_URL$ABOUT_US_END_POINT");

    //data handling
    http.Response response =
        await http.get(url, headers: headers);

    // Decoding Response.
    Map<String, dynamic> decoded = json.decode(response.body);

    // Debugging API response
    debugApi(
        methodName: "get aboutUs ",
        statusCode: response.statusCode,
        response: decoded,
        data: null,
        endPoint: response.request.url,
        headers: headers);

    //exporting data into model
    AboutUsResponse responseData = AboutUsResponse.fromJson(decoded);
    if (isValidResponse(response.statusCode) && responseData.status == 1) {
      onSuccess(responseData.data);
    } else {
      onError();
    }
  }

  static void getColorFromServer({onSuccess()}) async {
    //API Calling
    String lang = await getLanguage();
    String token = await getToken();
    int userId = await getUserId();
    var headers;
    headers = {"lang": lang, "Authorization": token, ...apiHeaders};

    print("$BASE_URL$COLOR_END_POINT");
    var url = Uri.parse("$BASE_URL$COLOR_END_POINT");

    //data handling
    http.Response response =
        await http.get(url, headers: headers);

    print("${response.request.url}");
    // Decoding Response.
    Map<String, dynamic> decoded = json.decode(response.body);

    // Debugging API response
    debugApi(
        methodName: "get color ",
        statusCode: response.statusCode,
        response: decoded,
        data: null,
        endPoint: response.request.url,
        headers: headers);

    //exporting data into model
    ColorModel responseData = ColorModel.fromJson(decoded);
    if (isValidResponse(response.statusCode) && responseData.status == 1) {
      await saveColor(responseData.data);
      onSuccess();
    }
  }

  static void getDiscountFromServer(double totalPrice, int type,
      {onSuccess(int discount)}) async {
    //API Calling
    String lang = await getLanguage();
    String token = await getToken();
    int userId = await getUserId();
    var headers;
    headers = {"lang": lang, "Authorization": token, ...apiHeaders};
    var url = Uri.parse("$BASE_URL$DISCOUNT_END_POINT?total_price=$totalPrice&order_type=$type");

    //data handling
    http.Response response = await http.get(
        url,
        headers: headers);

    // Decoding Response.
    Map<String, dynamic> decoded = json.decode(response.body);

    // Debugging API response
    debugApi(
        methodName: "get discount ",
        statusCode: response.statusCode,
        response: decoded,
        data: null,
        endPoint: response.request.url,
        headers: headers);

    //exporting data into model
    DiscountModel responseData = DiscountModel.fromJson(decoded);
    if (isValidResponse(response.statusCode) && responseData.status == 1) {
      onSuccess(responseData?.discount ?? 0);
    }
  }

  static void getAllZones({onSuccess(List<Zone> zones), onError()}) async {
    //API Calling
    String lang = await getLanguage();
    String token = await getToken();
    var headers;
    headers = {"lang": lang, "Authorization": token, ...apiHeaders};

    var url = Uri.parse("$BASE_URL$ZONES_END_POINT");

    //data handling
    http.Response response =
        await http.get(url, headers: headers);

    // Decoding Response.
    Map<String, dynamic> decoded = json.decode(response.body);

    // Debugging API response
    debugApi(
        methodName: "get zones",
        statusCode: response.statusCode,
        response: decoded,
        data: null,
        endPoint: response.request.url,
        headers: headers);

    //exporting data into model
    ZonesResponse responseData = ZonesResponse.fromJson(decoded);
    if (isValidResponse(response.statusCode) && responseData.status == 1) {
      onSuccess(responseData.data);
    } else {
      onError();
    }
  }

  static void getAllBranches(
      {onSuccess(List<Branch> branches), onError()}) async {
    //API Calling
    String lang = await getLanguage();
    String token = await getToken();
    var headers;
    headers = {"lang": lang, "Authorization": token, ...apiHeaders};
    var url = Uri.parse("$BASE_URL$BRANCHES_END_POINT");

    //data handling
    http.Response response =
        await http.get(url, headers: headers);

    // Decoding Response.
    Map<String, dynamic> decoded = json.decode(response.body);

    // Debugging API response
    debugApi(
        methodName: "get branches",
        statusCode: response.statusCode,
        response: decoded,
        data: null,
        endPoint: response.request.url,
        headers: headers);

    //exporting data into model
    BranchResponse responseData = BranchResponse.fromJson(decoded);
    if (isValidResponse(response.statusCode) && responseData.status == 1) {
      onSuccess(responseData.branches);
    } else {
      onError();
    }
  }

  static void makeOrder(
      {@required MakeOrderModel data,
      onSuccess(String msg, String data),
      onError(String error)}) async {
    //API Calling
    String lang = await getLanguage();
    String token = await getToken();
    int userId = await getUserId();
    var headers;
    headers = {"lang": lang, "Authorization": token, ...apiHeaders};

    //data handling
    var body = json.encode(data.toJson());
    String endPoint = data.orderType == PLACE
        ? MAKE_ORDER_PLACE_END_POINT
        : MAKE_ORDER_END_POINT;

    var url = Uri.parse("$BASE_URL$endPoint");

    http.Response response =
        await http.post(url, headers: headers, body: body);

    // Decoding Response.
    Map<String, dynamic> decoded = json.decode(response.body);

    // Debugging API response
    debugApi(
        methodName: "makeOrder",
        statusCode: response.statusCode,
        response: decoded,
        data: body,
        endPoint: response.request.url,
        headers: headers);

    //exporting data into model
    SaveOrderResponseResponse responseData =
        SaveOrderResponseResponse.fromJson(decoded);
    if (isValidResponse(response.statusCode) && responseData.status == 1) {
      onSuccess(responseData.message, responseData.data);
    } else {
      onError(responseData.message);
    }
  }

  static void saveToken({@required String FCMtoken}) async {
    //API Calling
    String lang = await getLanguage();
    String token = await getToken();
    int userId = await getUserId();
    var headers;
    headers = {"lang": lang, "Authorization": token, ...apiHeaders};
    var url = Uri.parse("$BASE_URL$SAVE_FCM_TOKEN_END_POINT");

    //data handling
    var body = json.encode({"fcm_token": FCMtoken});
    http.Response response = await http.post(
        url,
        headers: headers,
        body: body);

    // Decoding Response.
    Map<String, dynamic> decoded = json.decode(response.body);

    // Debugging API response
    debugApi(
        methodName: "save Token",
        statusCode: response.statusCode,
        response: decoded,
        data: body,
        endPoint: response.request.url,
        headers: headers);
  }
}
