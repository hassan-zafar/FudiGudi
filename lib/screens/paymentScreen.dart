import 'package:bot_toast/bot_toast.dart';
import 'package:credit_card/credit_card_model.dart';
import 'package:credit_card/flutter_credit_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/screens/payment_screens/existingCards.dart';
import 'package:flutter_app/services/payment_services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:stripe_payment/stripe_payment.dart';

class PaymentScreen extends StatefulWidget {
  final String price;
  final int quantity;
  PaymentScreen({this.price, this.quantity});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

enum PaymentOptionsPressed { payPal, credit, wallet }

class _PaymentScreenState extends State<PaymentScreen> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  bool saveCard = false;
  bool _isPressed = false;
  Map newCard = {};
  bool isNewCard = true;
  final MaskedTextController _cardNumberController =
      MaskedTextController(mask: '0000 0000 0000 0000');
  final TextEditingController _expiryDateController =
      MaskedTextController(mask: '00/00');
  final TextEditingController _cardHolderNameController =
      TextEditingController();
  final TextEditingController _cvvCodeController =
      MaskedTextController(mask: '0000');
  @override
  void initState() {
    super.initState();
    StripeService.init();
  }

  @override
  Widget build(BuildContext context) {
    String type = PaymentOptionsPressed.credit.toString();
    double amount = widget.quantity * double.parse(widget.price);
    String finalPrice = "$amount";
    print(finalPrice);
    return SafeArea(
      child: Container(
        decoration: backgroundColorBoxDecoration(),
        child: Scaffold(
          body: ListView(
            shrinkWrap: true,
            children: [
              Container(
                height: 200,
                color: Color(0xffF0F9F4),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Payment",
                        style: titleTextStyle(),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: GestureDetector(
                        //     onTap: () {
                        //       setState(() {
                        //         type = PaymentOptionsPressed.payPal.toString();
                        //       });
                        //     },
                        //     child: iconButtons(
                        //       icon: FontAwesomeIcons.paypal,
                        //       isPressed: type ==
                        //           PaymentOptionsPressed.payPal.toString(),
                        //     ),
                        //   ),
                        // ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isNewCard = true;
                                type = PaymentOptionsPressed.credit.toString();
                              });
                            },
                            child: Container(
                              color: saveCard ? Colors.green : Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Icon(FontAwesomeIcons.creditCard),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isNewCard = false;
                                type = PaymentOptionsPressed.wallet.toString();
                              });
                            },
                            child: Container(
                              color: saveCard ? Colors.green : Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Icon(FontAwesomeIcons.wallet),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // CreditCardWidget(
              //   cardNumber: cardNumber,
              //   expiryDate: expiryDate,
              //   cardHolderName: cardHolderName,
              //   cvvCode: cvvCode,
              //   showBackView: isCvvFocused,
              // ),
              isNewCard
                  ? Form(
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            margin: const EdgeInsets.only(
                                left: 16, top: 8, right: 16),
                            child: TextField(
                              controller: _cardHolderNameController,
                              style: TextStyle(),
                              decoration: InputDecoration(
                                //  border: InputBorder.none,
                                labelText: 'Name on Card',
                              ),
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            margin: const EdgeInsets.only(
                                left: 16, top: 16, right: 16),
                            child: TextField(
                              controller: _cardNumberController,
                              style: TextStyle(),
                              decoration: InputDecoration(
                                //   border: InputBorder.none,
                                labelText: 'Card number',
                                hintText: 'xxxx xxxx xxxx xxxx',
                              ),
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * .4,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                margin: const EdgeInsets.only(
                                    left: 16, top: 8, right: 16),
                                child: TextField(
                                  controller: _expiryDateController,
                                  style: TextStyle(),
                                  decoration: InputDecoration(
                                      //  border: InputBorder.none,
                                      labelText: 'Expired Date',
                                      hintText: 'MM/YY'),
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * .4,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                margin: const EdgeInsets.only(
                                    left: 16, top: 8, right: 16),
                                child: TextField(
                                  controller: _cvvCodeController,
                                  style: TextStyle(),
                                  decoration: InputDecoration(
                                    // border: InputBorder.none,
                                    labelText: 'CVV',
                                    hintText: 'XXXX',
                                  ),
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.done,
                                  onChanged: (String text) {
                                    setState(() {
                                      cvvCode = text;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  : ExistingCardsPage(),
              isNewCard
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                saveCard = !saveCard;
                              });
                            },
                            child: CircleAvatar(
                              child: Icon(
                                Icons.done_rounded,
                                color:
                                    saveCard ? Colors.white : Colors.green[700],
                              ),
                              backgroundColor: saveCard
                                  ? Colors.green[700]
                                  : Colors.transparent,
                              radius: 15,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Save this card details"),
                          ),
                        ],
                      ),
                    )
                  : Container(),
            ],
          ),
          bottomSheet: InkWell(
            onTap: () {
              setState(() {
                newCard = {
                  'cardNumber': _cardNumberController.text,
                  'expiryDate': _expiryDateController.text,
                  'cardHolderName': _cardHolderNameController.text,
                  'cvvCode': _cvvCodeController.text,
                  'showBackView': false,
                };
              });
              print(newCard);
              payViaExistingCard(context, newCard, finalPrice);
            },
            child: Container(
              height: 90,
              padding: EdgeInsets.all(16),
              color: Colors.green,
              child: Center(
                child: Text(
                  "$finalPrice LEI Reserve",
                  style: titleTextStyle(fontSize: 30, color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  payViaExistingCard(BuildContext context, card, String finalPrice) async {
    ProgressDialog dialog = new ProgressDialog(context);
    print(card);
    dialog.style(message: 'Please wait...');
    await dialog.show();
    print(card["expiryDate"]);
    var expiryArr = card['expiryDate'].split('/');
    print(expiryArr);
    CreditCard stripeCard = CreditCard(
      number: card['cardNumber'],
      expMonth: int.parse(expiryArr[0]),
      expYear: int.parse(expiryArr[1]),
    );
    var response = await StripeService.payViaExistingCard(
        amount: finalPrice,
        currency: 'INR',
        card: stripeCard,
        saveCard: saveCard);
    await dialog.hide();
    // Scaffold.of(context)
    //     .showSnackBar(SnackBar(
    //       content: Text(response.message),
    //       duration: new Duration(milliseconds: 1200),
    //     ))
    //     .closed
    //     .then((_) {      Navigator.pop(context);

    // });
    BotToast.showText(
      text: response.message,
      duration: Duration(milliseconds: 1200),
    );
    Navigator.pop(context);
  }

  iconButtons({@required IconData icon, @required bool isPressed}) {
    return Container(
      padding: EdgeInsets.only(top: 15.0, bottom: 15.0, left: 30, right: 30),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        color: isPressed ? Color(0xff8CC63E) : Color(0xffF0F9F4),
      ),
      child: FaIcon(
        icon,
        size: 18,
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}
