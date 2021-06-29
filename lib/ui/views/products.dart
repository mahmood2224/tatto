import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tato/data/api_provider.dart';
import 'package:tato/data/model/sent/category_model.dart';
import 'package:tato/data/model/sent/counts_model.dart';
import 'package:tato/data/model/sent/products_model.dart';
import 'package:tato/data/model/sent/types_model.dart';
import 'package:tato/ui/views/Product_widget.dart';
import 'package:tato/ui/views/product_details.dart';
import 'package:tato/ui/views/shopping_cart.dart';
import 'package:tato/ui/widgets/Loading.dart';
import 'package:tato/ui/widgets/Logo.dart';
import 'package:tato/ui/widgets/app_bar.dart';
import 'package:tato/ui/widgets/button_nav.dart';
import 'package:tato/ui/widgets/spedo_button.dart';
import 'package:tato/ui/widgets/type_dialog.dart';
import 'package:tato/utils/Dialog.dart';
import 'package:tato/utils/algorithms.dart';
import 'package:tato/utils/colors.dart';
import 'package:easy_localization/easy_localization.dart';

class ProductsPage extends StatefulWidget {
  CategoryModel category ;
  List<CategoryModel> categories ;
  ProductsPage(this.category , this.categories );

  @override
  _ProductsPageState createState() {
    return _ProductsPageState();
  }
}

class _ProductsPageState extends State<ProductsPage>  with SingleTickerProviderStateMixin {


  int _selectedCat = 0 ;

  CategoryModel _selectedCategory ;

  bool _countsloading = false ;
  Count counts ;

  TabController tabController;

  TypesModel types ;

  bool _loading = false ;
  RefreshController _refreshController =
  RefreshController(initialRefresh: false);
  @override
  void initState() {
    super.initState();
    _getTypes();
    tabController = new TabController(length: widget.categories?.length??0, vsync: this);
    tabController.index = widget.categories.indexOf(widget.category);
    tabController.addListener(_setSelectedCat);
    this._selectedCategory = widget.category ;
    _selectedCat = widget.categories.indexOf(_selectedCategory);
    _getCounts();
  }

  _setSelectedCat(){
    print("selected Cat Called ${tabController.index}");
      this._selectedCat = tabController.index ;
      this._selectedCategory = widget.categories[tabController.index] ;
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


  _getTypes() {
    ApiProvider.getTypes(
        onError: () {},
        onSuccess: (types) {
          setState(() {
            this.types = types;
          });
        });
  }

  _addToCartApi(int productId) {

    ApiProvider.addToCart(
        productId: "$productId",
        qty: 1,
        onSuccess: (message , count ) {
          showToast(message, backgroundColor: Colors.green);
          _getCounts();
        },
        onError: (message) {
          showToast(message, backgroundColor: Colors.red);
        });
  }

  _addToCart(int productId){
    if((this.counts?.count??0) == 0)
      ShowDialog(
          context: context,
          height: MediaQuery.of(context).size.height / 2.5,
          alignment: Alignment.center,
          radius: BorderRadius.circular(16),
          child: TypeDialog(this.types,onSuccess: ()=>_addToCartApi(productId),));
    else
      _addToCartApi(productId);
  }

  _getCategories() {
    _refreshController.refreshCompleted();
    setState(()=>_loading = true);
    ApiProvider.getAllCategories(
        onError: () => setState(() => _loading = false),
        onSuccess: (categories) {
          setState(() {
            widget.categories = categories;
            tabController.index = widget.categories.indexOf(widget.category);
            tabController.addListener(_setSelectedCat);
            this._selectedCategory = widget.category ;
            _selectedCat = widget.categories.indexOf(_selectedCategory);
            _loading = false ;
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double itemHeight = Platform.isIOS ? 212 : 192 ;
    return  Scaffold(
      appBar: SpedoAppBar(context,
          getCounts: _getCounts,
          counts: this.counts , title : "المنتجات" , ),
      body: Container(
        height: height,
        width: width,
        child:_loading ? Loading(): Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8,),
            Container(
              height: 30,
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: TabBar(
                controller: tabController,
                indicatorColor: Colors.blue,
                indicatorSize: TabBarIndicatorSize.tab,
                unselectedLabelColor: PRIMARY_COLOR,
                indicator: BoxDecoration(
                  color: PRIMARY_COLOR,
                  borderRadius: BorderRadius.circular(12)
                ),
                isScrollable: true,
                tabs: widget.categories.map((i) =>
                    Tab( text: i.name??"", )
                ).toList()
              ),
            ),

            Container(
              height: height - 80 - 60 - 82,
              child: TabBarView(
                controller: tabController,
                children: widget.categories.map((e) =>  Container(
                  child: GridView.builder(
                    padding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    itemCount: e?.dishes?.length??0,
                    itemBuilder: (context, index) {
                      Product product = e?.dishes[index] ;
                      return ProductWidget(product:  product , category: _selectedCategory,);
                    },
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 164 / itemHeight,
                      crossAxisCount: 2,
                      crossAxisSpacing: 11,
                      mainAxisSpacing: 11,
                    ),
                  ),
                ),).toList(),
              ),
            ),

            SizedBox(height: 80,),
          ],
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
