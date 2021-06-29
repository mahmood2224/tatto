import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tato/data/api_provider.dart';
import 'package:tato/data/model/sent/category_model.dart';
import 'package:tato/data/model/sent/counts_model.dart';
import 'package:tato/data/model/sent/slider_image.dart';
import 'package:tato/ui/views/product_details.dart';
import 'package:tato/ui/views/products.dart';
import 'package:tato/ui/views/shopping_cart.dart';
import 'package:tato/ui/widgets/Loading.dart';
import 'package:tato/ui/widgets/Logo.dart';
import 'package:tato/ui/widgets/app_bar.dart';
import 'package:tato/ui/widgets/button_nav.dart';
import 'package:tato/ui/widgets/drawer.dart';
import 'package:tato/utils/colors.dart';
import 'package:easy_localization/easy_localization.dart';

class Home extends StatefulWidget {


  @override
  _HomeState createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {

  List<SliderImage> _sliderList = [] ;
  bool loading = false ;
  int _slideSelected = 0 ;
  bool _countsloading = false ;
  Count counts ;
  String shareLink ;
  List<CategoryModel> categories = [] ;
  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  @override
  void initState() {
    super.initState();
    _getCategories();
    _getSlider();
    _getCounts();
    _getAboutUs();
  }

  _getSlider(){
    setState(()=>loading = true);
    ApiProvider.getSlider(onError: (){
      print("there is some error ") ;
      setState(()=>loading = false);
    } , onSuccess: (slides)=>setState((){
      print("slides : ${slides.length}");
      this._sliderList = slides ;
      this.loading = false ;
    }));
  }

  _getAboutUs() {
    ApiProvider.getAboutUs(
        onError: () {},
        onSuccess: (aboutUs) {
          this.shareLink = aboutUs?.share_string??"" ;
        });
  }

  _getCounts() {
    setState(() => _countsloading = true);
    ApiProvider.getCounts(
        onError: () => setState(() => _countsloading = false),
        onSuccess: (count) {
          setState(() {
            this.counts = count;
            this._countsloading = false;
          });
        });
  }

  _getCategories() {
    _refreshController.refreshCompleted();
    ApiProvider.getAllCategories(
        onError: () => setState(() => loading = false),
        onSuccess: (categories) {
          setState(() {
            this.categories = categories;
          });
        });
  }


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return  Scaffold(
      key: _scaffoldKey,
      drawer: SpedoDrawer(shareLink: this.shareLink,),
      appBar: SpedoAppBar(context,
        leading: InkWell(
          onTap: () => _scaffoldKey.currentState.openDrawer(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset("assets/icons/side_menu.svg" , color: PRIMARY_COLOR,)
            ],
          ),
        ),
          getCounts: _getCounts,
          counts: this.counts , title : "الاقسام" , ),
      body: Container(
        height: height,
        width: width,
        child: loading ? Loading() :SmartRefresher(
          onRefresh: (){
            this._getCategories();
            this._getCounts();
            this._getSlider();
          },
          controller: _refreshController,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8,),
                Container(
                  height: 192,
                  child: Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: <Widget>[
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: CarouselSlider(
                          aspectRatio: 16 / 9,
                          viewportFraction: 1.0,
                          enableInfiniteScroll: true,
                          reverse: false,
                          autoPlay: true,
                          autoPlayInterval: Duration(seconds: 3),
                          onPageChanged: (pageIndex) {
                            setState(() => this._slideSelected = pageIndex);
                          },
                          items: _sliderList.map((i) {
                            return InkWell(
                              onTap: (){
                                if(i.product != null) {
                                  CategoryModel cat = this.categories.firstWhere((element){
                                    return element.id == i.product.category_id;
                                  });
                                  print(cat);
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) =>
                                          ProductDetails(i.product , cat )));
                                }
                              },
                              child: Builder(
                                builder: (BuildContext context) {
                                  return Container(
                                      width: MediaQuery.of(context).size.width,
                                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8)),
                                      child: Image.network(
                                        i?.slider_image??"",
                                        fit: BoxFit.fill,
                                      ));
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      Positioned(
                        bottom: 16,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8 , vertical: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.black45
                          ),
                          child: Row(
                            children: _sliderList.map((v) {
                              var index = _sliderList.indexOf(v);
                              return Builder(
                                builder: (BuildContext context) {
                                  return Container(
                                    width: 8,
                                    height: 8,
                                    margin: EdgeInsets.symmetric(horizontal: 2.0),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: this._slideSelected == index
                                            ? PRIMARY_COLOR
                                            : Colors.white70),
                                  );
                                },
                              );
                            }).toList(),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16 , vertical: 8),
                  child: Text("categories".tr() , style: TextStyle(fontSize: 16 , fontWeight: FontWeight.w500 , color: TEXT_COLOR100),),
                ),
                GridView.builder(
                  padding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  itemCount: this.categories?.length??0,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    CategoryModel cat = this.categories[index] ;
                    return InkWell(
                      onTap: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ProductsPage(cat , this.categories))),
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(image: NetworkImage(cat?.image??""), fit: BoxFit.fill),
                          borderRadius: BorderRadius.circular(16)
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16 , vertical: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(
                              colors: [
                                Colors.black54 ,
                                Colors.transparent
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            )
                          ),
                          child: Align(
                            alignment: AlignmentDirectional.bottomCenter,
                            child: Text(cat?.name??"" , style: TextStyle(fontSize: 20 , fontWeight: FontWeight.bold  ,color: Colors.white),),
                          ),
                        ),
                      ),
                    );
                  },
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 164 / 172,
                    crossAxisCount: 2,
                    crossAxisSpacing: 11,
                    mainAxisSpacing: 11,
                  ),
                ),
                SizedBox(height: 80,),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: SpedoButtonNav(
          text: "total".tr(),
          smtext: "${this.counts?.total_price ?? 0} ",
          cr: counts?.currency??"cr".tr(),
          right:20 ,
          loading: _countsloading,
          buttonSt: "finish_order".tr(),
          press: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => ShoppingCart()),
            );
            _getCounts();
          }),
    );
  }


  @override
  void dispose() {
    super.dispose();
  }

}