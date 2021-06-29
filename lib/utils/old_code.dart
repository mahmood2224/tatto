// grid view for products
/*
_selectedType == GRIDE
                  ? GridView.builder(
                padding:
                EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                itemCount: this.product?.length ?? 0,
                itemBuilder: (context, index) {
                  Product dish = this.product[index];
                  GlobalKey key = GlobalKey();
                  return InkWell(
                    onTap: () {
                      if(_addAgain)
                        if(this.counts.count == 0 )
                          _showTypeDialog("${dish.id}",
                              key: key, image: dish.image);
                        else
                          _addToCart("${dish.id}",
                              key: key, image: dish.image);
                    },
                    child: Material(
                      elevation: 3,
                      borderRadius: BorderRadius.circular(7),
                      child: Container(
                        key: key,
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            color: Colors.white),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                                borderRadius: BorderRadius.circular(7),
                                child: Image.network(
                                  dish.image,
                                  width: 102,
                                  height: 85,
                                  fit: BoxFit.fill,
                                )),
                            Text(
                              "${dish.name}",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: TEXT_COLOR),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              convertNumbersString("${dish?.price}") +
                                  " " +
                                 dish?.currency??"cr".tr(),
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: PRIMARY_COLOR),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 118 / gridViewHeight,
                  crossAxisCount: 3,
                  crossAxisSpacing: 11,
                  mainAxisSpacing: 11,
                ),
              )

   */