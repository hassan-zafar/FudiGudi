import 'package:credit_card/credit_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/services/payment_services.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:progress_dialog/progress_dialog.dart';

class ExistingCardsPage extends StatefulWidget {
  ExistingCardsPage({Key key}) : super(key: key);

  @override
  ExistingCardsPageState createState() => ExistingCardsPageState();
}

class ExistingCardsPageState extends State<ExistingCardsPage> {
  List cards = [
    {
      'cardNumber': '4242424242424242',
      'expiryDate': '04/24',
      'cardHolderName': 'Hassan Zafar',
      'cvvCode': '424',
      'showBackView': false,
    },
    {
      'cardNumber': '5555555566554444',
      'expiryDate': '04/23',
      'cardHolderName': 'Ali Zafar',
      'cvvCode': '123',
      'showBackView': false,
    }
  ];

  payViaExistingCard(
      BuildContext context, card, String finalPrice, bool isSaved) async {
    ProgressDialog dialog = new ProgressDialog(context);
    dialog.style(message: 'Please wait...');
    await dialog.show();
    var expiryArr = card['expiryDate'].split('/');
    CreditCard stripeCard = CreditCard(
      number: card['cardNumber'],
      expMonth: int.parse(expiryArr[0]),
      expYear: int.parse(expiryArr[1]),
    );
    finalPrice = "49";
    var response = await StripeService.payViaExistingCard(
        amount: finalPrice, currency: 'INR', card: stripeCard, saveCard: true);
    await dialog.hide();
    Scaffold.of(context)
        .showSnackBar(SnackBar(
          content: Text(response.message),
          duration: new Duration(milliseconds: 1200),
        ))
        .closed
        .then((_) {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.maxFinite,
      padding: EdgeInsets.all(20),
      child: ListView.builder(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        itemCount: cards.length,
        itemBuilder: (BuildContext context, int index) {
          var card = cards[index];
          return InkWell(
            onTap: () {
              payViaExistingCard(context, card, "34", true);
            },
            child: CreditCardWidget(
              cardNumber: card['cardNumber'],
              expiryDate: card['expiryDate'],
              cardHolderName: card['cardHolderName'],
              cvvCode: card['cvvCode'],
              showBackView: false,
            ),
          );
        },
      ),
    );
  }
}
