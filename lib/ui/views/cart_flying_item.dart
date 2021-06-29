import 'package:flutter/material.dart';

class CartItem extends StatefulWidget {
  Position position ;
  Function onAnimationCompleted ;
  String image ;

  CartItem(this.position , {this.onAnimationCompleted , this.image});

  @override
  _CartItemState createState() {
    return _CartItemState();
  }
}

class _CartItemState extends State<CartItem> with TickerProviderStateMixin{
  AnimationController moveController;
  Animation moveAnimation;

  GlobalKey currentKey = GlobalKey();

  Position fromPosition ;
  @override
  void initState() {
    super.initState();
    moveController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 1000));
    moveAnimation =
        CurvedAnimation(parent: moveController, curve: Curves.easeInOut);

    moveController.addListener(() {
      print("is animation Completed : ${moveAnimation.isCompleted}");
      if(moveAnimation.isCompleted) widget.onAnimationCompleted() ;
    });
  }



  @override
  Widget build(BuildContext context) {
    fromPosition = widget.position;
    print("build this card $fromPosition");
    if(fromPosition != null )moveController.forward(from: 0.36668479442596436);
    return Container(
        key: currentKey,
        height: 58,
        width: 58,
        child: widget.position == null ? buildCard() :  buildMoving()
    );

  }



  Widget buildMoving() {
    return AnimatedBuilder(
        animation: moveAnimation,
        builder: (context, snapshot) {
          Position currentPosition;
          double x = 0, y = 0;
          if (currentKey.currentContext.findRenderObject() != null) {
            currentPosition = getPositionbyKey(currentKey);
            x = fromPosition.x -
                currentPosition.x +
                fromPosition.size.width -
                90;
            y = fromPosition.y - currentPosition.y;
          }
          // print("x = $x \n y = $y");
          // print("move animation value = ${moveAnimation.value}");
          // print ( "offest = (${x * (1 - moveAnimation.value)} , ${y * (1 - moveController.value)}");
          if(x==0) return Container() ;
          return Transform.translate(
              offset: Offset(x * (1 - moveAnimation.value),
                  y * (1 - moveController.value)),
              child: buildCard());
        });
  }

   Widget buildCard(){
    return  Container(
       width: 58,
       height: 58,
       decoration: BoxDecoration(
           shape: BoxShape.circle,
           image: widget.image == null ? null :DecorationImage(image: NetworkImage(widget.image??"") , fit: BoxFit.fill)
       ),

     );
   }
  @override
  void dispose() {
    super.dispose();
  }
}

Position getPositionbyKey(GlobalKey key) {
  RenderBox box = key.currentContext.findRenderObject();
  Size size = box.size;
  Offset position = box.localToGlobal(Offset.zero); //this is global position
  double x = position.dx;
  double y = position.dy;
  return Position(x, y, size);
}

class Position {
  double x;

  double y;
  Size size;

  Position(this.x, this.y, this.size);
}