//BASE URL declaration
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String BASE_URL = 'http://api.tato.apishipping.iraq-soft.info/';
const int API_VERSION = 1;
//Static Headers
const Map<String, String> apiHeaders = {
  "Content-Type": "application/json",
  "Accept": "application/json, text/plain, */*",
  "X-Requested-With": "XMLHttpRequest",
};

//api/auth_apis.dart end_points
const String LOGIN_END_POINT = "api/Auth_general/login" ;
const String SLIDER_END_POINT = "api/general/get-slider";
const String ADD_TO_CART_END_POINT = "api/cart/add";
const String ADD_NOTES_TO_CART_END_POINT = "api/cart/add-notes";
const String REMOVE_CART_END_POINT = "api/cart/remove";
const String GET_CART_END_POINT = "api/cart/get";
const String ZONES_END_POINT = "api/Auth_general/get-zones";
const String BRANCHES_END_POINT = "api/branch/get";
const String MAKE_ORDER_END_POINT = "api/order/add";
const String MAKE_ORDER_PLACE_END_POINT = "api/order/add-place";
const String GET_ORDER_END_POINT = "api/order/get-orders";
const String COLOR_END_POINT = "api/Auth_general/color/get";
const String COUNT_END_POINT = "api/cart/get-count";
const String SAVE_FCM_TOKEN_END_POINT = "api/firebase/save-token";
const String PRODUCTS_END_POINT = "api/products/get";
const String CATEGORY_END_POINT = "api/products/get-categories";
const String NOTIFICATION_END_POINT = "api/notification/get";
const String ORDER_END_POINT = "api/order/get-orders";
const String DISCOUNT_END_POINT = "api/discount/get";
const String ORDER_TYPE_END_POINT = "api/order-type/get";
const String ABOUT_US_END_POINT = "api/about_us/get";


////////////////////////////////////////////////////////////////////////////////
//////////////////////////////// Helpers Functions /////////////////////////////

bool isValidResponse(int statusCode) {
  return  statusCode >= 200 && statusCode <= 302;
}

void debugApi(
    {String fileName = "ApiProvider.dart",
    @required String methodName,
    @required int statusCode,
    @required response,
    @required data,
    @required endPoint,
    headers}) {
  debugPrint(
    "FileName: $fileName\n"
    "Method: $methodName\n"
    "${endPoint != null ? 'URL: $endPoint\n' : ''}"
    "${data != null ? 'data: $data\n' : ''}"
    "${headers != null ? "Headerss :$headers\n" : ""}"
    "statusCode: $statusCode\n"
    "${response != null ? 'Response: $response\n' : ''}"
    "--------------------",
    wrapWidth: 512,
  );
}
