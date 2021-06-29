import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share/share.dart';
import 'package:tato/data/userData.dart';
import 'package:tato/ui/views/NotificationPage.dart';
import 'package:tato/ui/views/about_us.dart';
import 'package:tato/ui/views/home.dart';
import 'package:tato/ui/views/ordersPage.dart';
import 'package:tato/ui/views/product_gallary.dart';
import 'package:tato/utils/colors.dart';

class SpedoDrawer extends StatelessWidget {
  String shareLink  ;

  SpedoDrawer({@required this.shareLink});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width/1.4,
      child: Material(
        child: SingleChildScrollView(
          child: Container(

            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 60,),
                Image.asset("assets/images/logo.png" , height: 140,),
                SizedBox(height : 16),
                Text("title".tr(), style: TextStyle(fontSize: 16 , fontWeight: FontWeight.bold , color: PRIMARY_COLOR),),
                SizedBox(height: 40),
                InkWell(
                  onTap: (){
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ProductGallary(selectedType: LIST,)));
                  },
                  child: Container(
                    height: 38,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Icon(FontAwesomeIcons.listAlt , color: PRIMARY_COLOR, size: 20,),
                              SizedBox(
                                width:16,
                              ),
                              Text(
                                "products".tr(),
                                style: TextStyle(
                                  fontSize: 13,
                                ),
                              )
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16,),

                InkWell(
                  onTap: (){
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ProductGallary(selectedType: GRIDE,)));
                  },
                  child: Container(
                    height: 38,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Icon(FontAwesomeIcons.th , color: PRIMARY_COLOR, size: 20,),
                              SizedBox(
                                width:16,
                              ),
                              Text(
                                "products_gallary".tr(),
                                style: TextStyle(
                                  fontSize: 13,
                                ),
                              )
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16,),

                InkWell(
                  onTap: (){
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Home()));
                  },
                  child: Container(
                    height: 38,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Icon(FontAwesomeIcons.gripHorizontal , color: PRIMARY_COLOR, size: 20,),
                              SizedBox(
                                width:16,
                              ),
                              Text(
                                "categories".tr(),
                                style: TextStyle(
                                  fontSize: 13,
                                ),
                              )
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16,),


                InkWell(
                  onTap: (){
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>NotificationPage()));
                  },
                  child: Container(
                    height: 38,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Icon(FontAwesomeIcons.solidBell
                                , color: PRIMARY_COLOR, size: 20,),
                              SizedBox(
                                width:16,
                              ),
                              Text(
                                "notifications".tr(),
                                style: TextStyle(
                                  fontSize: 13,
                                ),
                              )
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16,),


                InkWell(
                  onTap: (){
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>OrdersPage()));
                  },
                  child: Container(
                    height: 38,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Icon(FontAwesomeIcons.shoppingBag , color: PRIMARY_COLOR, size: 20,),
                              SizedBox(
                                width:16,
                              ),
                              Text(
                                "orders".tr(),
                                style: TextStyle(
                                  fontSize: 13,
                                ),
                              )
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16,),

                InkWell(
                  onTap: (){
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AboutUsPage()));
                  },
                  child: Container(
                    height: 38,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Icon(FontAwesomeIcons.userFriends , color: PRIMARY_COLOR, size: 20,),
                              SizedBox(
                                width:16,
                              ),
                              Text(
                                "about_us".tr(),
                                style: TextStyle(
                                  fontSize: 13,
                                ),
                              )
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16,),

                InkWell(
                  onTap: (){
                    Navigator.of(context).pop();
                    Share.share(
                       this.shareLink??""
                    );
                  },
                  child: Container(
                    height: 38,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Icon(FontAwesomeIcons.shareAlt , color: PRIMARY_COLOR, size: 20,),
                              SizedBox(
                                width:16,
                              ),
                              Text(
                                "share".tr(),
                                style: TextStyle(
                                  fontSize: 13,
                                ),
                              )
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16,),


                SizedBox(height: 16,),
                // InkWell(
                //   onTap:() {
                //     Navigator.of(context).pop() ;
                //     Navigator.of(context).pop();
                //     Navigator.of(context).pop();
                //     Navigator.of(context).pop();
                //   },
                //   child: Container(
                //     height: 38,
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //       children: [
                //         Container(
                //           child: Row(
                //             children: [
                //               Icon(FontAwesomeIcons.signOutAlt , color: PRIMARY_COLOR, size: 20,),
                //               SizedBox(
                //                 width:16,
                //               ),
                //               Text(
                //                 "logout".tr(),
                //                 style: TextStyle(
                //                   fontSize: 13,
                //                 ),
                //               )
                //             ],
                //           ),
                //         ),
                //         Icon(
                //           Icons.arrow_forward_ios,
                //           size: 18,
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                // SizedBox(height: 16,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
