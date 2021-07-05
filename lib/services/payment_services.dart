import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:stripe_payment/stripe_payment.dart';

import '../home.dart';

class StripeTransactionResponse {
  String message;
  bool success;
  StripeTransactionResponse({this.message, this.success});
}

class StripeService {
  static String apiBase = 'https://api.stripe.com/v1';
  static String paymentApiUrl = '${StripeService.apiBase}/payment_intents';
  //TODO:secret value ko correctly assign krna h

  static String secret;
  static Map<String, String> headers = {
    'Authorization': 'Bearer ${StripeService.secret}',
    'Content-Type': 'application/x-www-form-urlencoded'
  };
  static init() {
    StripePayment.setOptions(StripeOptions(
        publishableKey:
            "pk_test_51IH6khHvrBXHiy9OKldfgUUtI4iHepzsYINuK66EDMeLNPnFWmlaxqcJt2bEiry73Ei8QysltqwDq8bppntPeO4D00YDqGmHT2",
        merchantId: "Test",
        androidPayMode: 'test'));
  }

  getSecretKey(String token) async {}

  static Future<StripeTransactionResponse> payViaExistingCard(
      {String amount, String currency, CreditCard card, bool saveCard}) async {
    try {
      var paymentMethod = await StripePayment.createPaymentMethod(
          PaymentMethodRequest(card: card));
      StripePayment.createTokenWithCard(card).then((token) async {
        //var headers = {'Cookie': 'ci_session=ca0t5gqpunvhvk15g7shn3f5b1at59he'};
        print("token" + token.tokenId);
        var request = http.MultipartRequest(
            'POST',
            Uri.parse(
                'https://fudigudi.ro/Fudigudi/webservice/stripe_payment?place_order_id=7&user_id=${currentUser.id}&payment_type=Stripe&amount=$amount&currency=$currency&token=${token.tokenId}'
                ));
        request.fields.addAll({'': ''});

        // request.headers.addAll();

        http.StreamedResponse response = await request.send();

        if (response.statusCode == 200) {
          String res = await response.stream.bytesToString();
          print(res);
          if (saveCard) {
            var request = http.MultipartRequest(
                'POST',
                Uri.parse(
                    'https://fudigudi.ro/Fudigudi/webservice/save_card?user_id=${currentUser.id}&email=${currentUser.email}&description=wel&source=${token.tokenId}'));
            request.fields.addAll({'': ''});

            // request.headers.addAll();

            http.StreamedResponse saveCardRes = await request.send();
            if (saveCardRes.statusCode == 200) {
              String scRes = await saveCardRes.stream.bytesToString();
              print(scRes);
            }
          }
          return StripeTransactionResponse(message: res);
        } else {
          print(response.reasonPhrase);
          return StripeTransactionResponse(success: false);
        }
      });

      // var paymentIntent =
      //     await StripeService.createPaymentIntent(amount, currency);
      // var response = await StripePayment.confirmPaymentIntent(PaymentIntent(
      //     clientSecret: paymentIntent['client_secret'],
      //     paymentMethodId: paymentMethod.id));
      // if (response.status == 'succeeded') {
      //   return new StripeTransactionResponse(
      //       message: 'Transaction successful', success: true);
      // } else {
      //   return new StripeTransactionResponse(
      //       message: 'Transaction failed', success: false);
      // }
    } on PlatformException catch (err) {
      return StripeService.getPlatformExceptionErrorResult(err);
    } catch (err) {
      return new StripeTransactionResponse(
          message: 'Transaction failed: ${err.toString()}', success: false);
    }
  }

  static Future<StripeTransactionResponse> payWithNewCard(
      {String amount, String currency}) async {
    try {
      var paymentMethod = await StripePayment.paymentRequestWithCardForm(
          CardFormPaymentRequest());
      var paymentIntent =
          await StripeService.createPaymentIntent(amount, currency);
      var response = await StripePayment.confirmPaymentIntent(PaymentIntent(
          clientSecret: paymentIntent['client_secret'],
          paymentMethodId: paymentMethod.id));
      if (response.status == 'succeeded') {
        return new StripeTransactionResponse(
            message: 'Transaction successful', success: true);
      } else {
        return new StripeTransactionResponse(
            message: 'Transaction failed', success: false);
      }
    } on PlatformException catch (err) {
      return StripeService.getPlatformExceptionErrorResult(err);
    } catch (err) {
      return new StripeTransactionResponse(
          message: 'Transaction failed: ${err.toString()}', success: false);
    }
  }

  static getPlatformExceptionErrorResult(err) {
    String message = 'Something went wrong';
    if (err.code == 'cancelled') {
      message = 'Transaction cancelled';
    }

    return new StripeTransactionResponse(message: message, success: false);
  }

  static Future<Map<String, dynamic>> createPaymentIntent(
      String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      var response = await http.post(StripeService.paymentApiUrl,
          body: body, headers: StripeService.headers);
      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
    return null;
  }
}
