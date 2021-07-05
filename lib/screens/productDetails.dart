import 'package:auto_size_text/auto_size_text.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/commonUIFunctions.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/models/commentModel.dart';
import 'package:flutter_app/models/reviewModel.dart';
import 'package:flutter_app/screens/storeDetails.dart';
import 'package:flutter_app/screens/paymentScreen.dart';
import 'package:flutter_app/models/restaurantsModel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_app/tools/loading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app/home.dart';
import 'payment_screens/paymentMethods.dart';

class ProductDetailsScreen extends StatefulWidget {
  final RestaurantDetails restaurantDetails;
  ProductDetailsScreen({@required this.restaurantDetails});
  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  bool changeContainer = false;
  List<ReviewData> allReviews = [];
  List<CommentData> allComments = [];
  bool _isClicked = false;
  bool _hasReviews = false;
  bool _hasComments = false;
  bool _isLoadingReviews = false;
  bool _isLoadingComments = false;
  int totalComments = 0;
  int totalReviews = 0;
  var quantity = 1;

  TextEditingController _commentController = TextEditingController();
  TextEditingController _reviewController = TextEditingController();

  getReviews() async {
    setState(() {
      _isLoadingReviews = true;
    });
    var headers = {'Cookie': 'ci_session=79mksn0f64co76qn67448b5j60ptihj9'};
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://fudigudi.ro/Fudigudi/webservice/get_review?restaurant_id=${widget.restaurantDetails.id}&user_id=${currentUser.id}'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String res = await response.stream.bytesToString();
      print("Reviews : " + res);

      try {
        ReviewsModel revModel = reviewModelFromJson(res);
        if (revModel.status == "1") {
          setState(() {
            allReviews = revModel.result;
            totalReviews = revModel.totalReview;
            _hasReviews = true;
            _isLoadingReviews = false;
          });
        } else {
          setState(() {
            allReviews = null;
            _hasReviews = false;
            _isLoadingReviews = false;
          });
        }
      } on Exception catch (e) {
        setState(() {
          _isLoadingReviews = false;
          _hasReviews = false;
        });
      }
    } else {
      print(response.reasonPhrase);
      setState(() {
        _isLoadingReviews = false;
        _hasReviews = false;
      });
    }
  }

  getComments() async {
    setState(() {
      _isLoadingComments = true;
    });
    var headers = {'Cookie': 'ci_session=9lqj96uq93dkbhlkbr678s54ujeev36u'};
    var request = http.Request(
      'GET',
      Uri.parse(
          'https://fudigudi.ro/Fudigudi/webservice/get_comment?restaurant_id=${widget.restaurantDetails.id}&user_id=${currentUser.id}'),
    );

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String res = await response.stream.bytesToString();
      print("Comments : " + res);
      try {
        CommentModel comModel = commentModelFromJson(res);
        if (comModel.status == "1") {
          setState(() {
            allComments = comModel.result;
            totalComments = comModel.totalComment;
            _hasComments = true;
            _isLoadingComments = false;
          });
        } else {
          setState(() {
            allComments = null;
            _hasComments = false;
            _isLoadingComments = false;
          });
        }
      } on Exception catch (e) {
        setState(() {
          _isLoadingComments = false;
          _hasComments = false;
        });
      }
    } else {
      print(response.reasonPhrase);
      setState(() {
        _isLoadingComments = false;
        _hasComments = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // getComments();
    // getReviews();
  }

  @override
  Widget build(BuildContext context) {
    RestaurantDetails _restaurantDetails = widget.restaurantDetails;
    double percentLiked;
    if (widget.restaurantDetails.rating != null) {
      double ratingToDouble = double.parse(widget.restaurantDetails.rating);
      percentLiked = (ratingToDouble / 5) * 100;
    }
    return Container(
      decoration: backgroundColorBoxDecoration(),
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              Hero(
                tag:
                    "${_restaurantDetails.restaurantName}-${_restaurantDetails.restaurantImage}",
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: CachedNetworkImageProvider(
                              _restaurantDetails.restaurantImage),
                          fit: BoxFit.fitWidth,
                          alignment: Alignment.topCenter)),
                ),
              ),
              ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  SizedBox(
                    height: 280,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: cardBoxDecoration(),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Hero(
                                    tag: "${_restaurantDetails.restaurantName}",
                                    child: Text(
                                      _restaurantDetails.restaurantName,
                                      style: titleTextStyle(fontSize: 22),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(_restaurantDetails.description),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Information",
                                      style: cardHeadingTextStyle()),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 4.0, bottom: 8, left: 16, right: 8),
                                  child: Text(
                                    "Today Pickup: ${_restaurantDetails.startTime} - ${_restaurantDetails.endTime}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w200,
                                        fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                              top: 4,
                              right: 7,
                              child: smallPositionedColored(
                                  text:
                                      "${_restaurantDetails.afterDiscountAmount} LEI"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
//goodie bag pickup location
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: cardBoxDecoration(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Goodie Bag pickup location",
                              style: cardHeadingTextStyle(),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: AutoSizeText(
                                      _restaurantDetails.restaurantAddress,
                                      maxLines: 5,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.green,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0,
                                          bottom: 8.0,
                                          left: 16,
                                          right: 16),
                                      child: Image.asset(
                                        back1Icon,
                                        height: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
//store details
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StoreDetails(
                          restaurantDetails: _restaurantDetails,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: cardBoxDecoration(),
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Store Details",
                                    style: cardHeadingTextStyle(),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: CachedNetworkImage(
                                            imageUrl: _restaurantDetails
                                                .restaurantImage,
                                            height: 45,
                                          )),
                                      Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              _restaurantDetails.restaurantName,
                                              style: cardHeadingTextStyle(),
                                            ),
                                          ),
                                          Text(
                                              "Rating: ${_restaurantDetails.rating}"),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                              bottom: 30,
                              right: 8,
                              child: smallPositionedColored(text: "View More"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // _isLoadingReviews
                  //     ? bouncingGridProgress()
                  //     : buildCommentReviews(
                  //         title: "Review",
                  //         //  commentsNo: 340,
                  //         isComment: false),
                  // _isLoadingComments
                  //     ? bouncingGridProgress()
                  //     : buildCommentReviews(
                  //         title: "Comments",
                  //         // commentsNo: 530,
                  //         isComment: true),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: cardBoxDecoration(),
                      width: double.maxFinite,
                      padding: EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "$percentLiked% people love this goodie bag",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      _showBottomSheet(context);
                    },
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: buildSignUpLoginButton(
                        context: context,
                        btnText: "Reserve",
                        textColor: Colors.white,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
              Positioned(
                right: 60,
                top: 15,
                child: smallPositionedColored(
                  text: "${widget.restaurantDetails.quantity} Left",
                  color: Colors.lime[600],
                ),
              ),
              Positioned(
                top: 15,
                right: 20,
                child: InkWell(
                  onTap: () async {
                    var headers = {
                      'Cookie': 'ci_session=jg4o2t75v010bqomh2bs2qi0nmqg21f8'
                    };
                    var request = http.MultipartRequest(
                        'POST',
                        Uri.parse(
                            'https://fudigudi.ro/Fudigudi/webservice/add_to_cart'));
                    request.fields.addAll({
                      'restaurant_id': widget.restaurantDetails.id,
                      'user_id': currentUser.id,
                      'quantity': "$quantity",
                      'amount': "${widget.restaurantDetails.amount}",
                      'item_id': widget.restaurantDetails.id
                    });

                    request.headers.addAll(headers);

                    http.StreamedResponse response = await request.send();

                    if (response.statusCode == 200) {
                      BotToast.showText(text: "Added To cart");
                      print(await response.stream.bytesToString());
                    } else {
                      print(response.reasonPhrase);
                    }
                  },
                  child: Image.asset(
                    cartIcon,
                    height: 30,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
              Positioned(
                top: 15,
                left: 20,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Image.asset(
                    backFilledIcon,
                    height: 30,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildReviewBubble() {
    return _hasReviews
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.black,
                    backgroundImage:
                        CachedNetworkImageProvider(allReviews[0].userImage),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(allReviews[0].userName,
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "10 min ago",
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              allReviews[0].review,
                              style: TextStyle(
                                  fontSize: 14.0, color: Colors.black),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          )
        : Center(
            child: Text("No Reviews"),
          );
  }

  buildCommentBubble(bool isComment) {
    return _hasComments
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.black,
                    backgroundImage:
                        CachedNetworkImageProvider(allComments[0].userImage),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(allComments[0].userName,
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "10 min ago",
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              allComments[0].comment,
                              style: TextStyle(
                                  fontSize: 14.0, color: Colors.black),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          )
        : Center(
            child: Text(isComment ? "No Comments" : "No Reviews"),
          );
  }

  Widget buildCommentReviews(
      {@required String title,
      // @required int commentsNo,
      @required bool isComment}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: cardBoxDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    title,
                    style: cardHeadingTextStyle(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    isComment ? "($totalComments)" : "($totalReviews)",
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: isComment
                      ? buildCommentBubble(isComment)
                      : buildReviewBubble(),
                ),
                Container(
                  child: Column(
                    children: [
                      Text("View All"),
                      Icon(Icons.expand_more_outlined),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Color(0xffF9FCF5),
                      border: Border.all(color: Colors.green),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.65,
                        child: TextField(
                          controller: isComment
                              ? _commentController
                              : _reviewController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: isComment
                                ? "Add Your Comment"
                                : "Leave a Review",
                            contentPadding: EdgeInsets.all(4),
                            filled: false,
                            isDense: false,
                            //fillColor: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    var headers = {
                      'Cookie': 'ci_session=fbbaqhfg63odo0rmlqvnlg3eiemuhcir'
                    };
                    var request = http.Request(
                        'GET',
                        Uri.parse(isComment
                            ? 'https://fudigudi.ro/Fudigudi/webservice/add_comment?restaurant_id=${widget.restaurantDetails.id}&user_id=${currentUser.id}&comment=${_commentController.text}'
                            : 'https://fudigudi.ro/Fudigudi/webservice/add_review?restaurant_id=${widget.restaurantDetails.id}&user_id=${currentUser.id}&review=${_reviewController.text}'));

                    request.headers.addAll(headers);

                    http.StreamedResponse response = await request.send();

                    if (response.statusCode == 200) {
                      print(await response.stream.bytesToString());
                      isComment
                          ? _commentController.clear()
                          : _reviewController.clear();
                      BotToast.showText(
                          text: isComment
                              ? "Comment Added Please reload"
                              : "Review Added Please reload");
                    } else {
                      print(response.reasonPhrase);
                      BotToast.showText(text: response.reasonPhrase);
                    }
                  },
                  child: Container(
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 16, top: 8, bottom: 8),
                        child: Text(
                          "POST",
                          style: TextStyle(color: Colors.white),
                        ),
                      )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomButtons() {
    return StatefulBuilder(builder: (context, state) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Fodoaltina",
              style: titleTextStyle(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Timing: ${widget.restaurantDetails.restaurantOpen}-${widget.restaurantDetails.restaurantClose}",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black, fontSize: 14),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    state(() {
                      ++quantity;
                    });
                  },
                  child: Image.asset(
                    plusIcon,
                    height: 30,
                  ),
                ),
              ),
              Text(
                "$quantity",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    if (quantity > 0) {
                      state(() {
                        --quantity;
                      });
                    }
                  },
                  child: Image.asset(
                    minusIcon,
                    height: 30,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 25.0, right: 25.0, bottom: 8, top: 8),
            child: Text(
              "Continuing with this command agrees the the Terms & Conditions",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                Navigator.pop(context);
                _showSecondBottomSheet(context);
              });
            },
            child: buildSignUpLoginButton(
              context: context,
              btnText: "COMANDA",
              color: Colors.green,
              textColor: Colors.white,
            ),
          ),
        ],
      );
    });
  }

  Widget bottomSecond() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              logo,
              height: 70,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Your order will be a Surprise",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 35.0, right: 35.0, top: 8, bottom: 8),
            child: Text(
              "We can't say what you will buy, because it depends a lot of the surplus of the location",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
            ),
          ),
          GestureDetector(
            onTap: () => Get.to(PaymentScreen(
              price: widget.restaurantDetails.afterDiscountAmount,
              quantity: quantity,
            )
                //PaymentMethods()
                ),
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => PaymentScreen(
            //       price: widget.restaurantDetails.afterDiscountAmount,
            //       quantity: quantity,
            //     ),
            //   ),
            // )

            child: buildSignUpLoginButton(
              context: context,
              btnText: "COMANDA",
              textColor: Colors.white,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  _showSecondBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Container(
            height: 300,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: bottomSecond(),
            ),
          );
        });
  }

  _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Container(
            height: 300,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: bottomButtons(),
            ),
          );
        });
  }

  BoxDecoration cardBoxDecoration() {
    return BoxDecoration(
        borderRadius: BorderRadius.circular(12), color: Colors.white);
  }

  cardHeadingTextStyle() {
    return TextStyle(fontWeight: FontWeight.bold, fontSize: 16);
  }
}
