import 'dart:convert';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutterwave_standard/core/TransactionCallBack.dart';
import 'package:flutterwave_standard/utils.dart';

class FlutterwaveInAppBrowser extends InAppBrowser {
  String redirectUrl;
  final TransactionCallBack callBack;

  var hasCompletedProcessing = false;
  var haveCallBacksBeenCalled = false;

  FlutterwaveInAppBrowser(
      {this.redirectUrl = Utils.DEFAULT_URL, required this.callBack});

  @override
  Future onBrowserCreated() async {}

  @override
  Future onLoadStart(url) async {
    final responseBody = url?.queryParameters.containsKey('response') == true ? json.decode(url?.queryParameters['response'] ?? '') : {};
    final status = url?.queryParameters["status"] ?? responseBody['status'] as String?;
    final txRef = url?.queryParameters["tx_ref"] ?? responseBody['txRef'] as String?;
    final id = url?.queryParameters["transaction_id"] ?? responseBody['id'].toString() as String?;
    final paymentType = url?.queryParameters['payment_type'] ?? responseBody['paymentType'] as String?;
    final hasRedirected = status != null && txRef != null;
    if (hasRedirected && url != null) {
      hasCompletedProcessing = hasRedirected;
      _processResponse(url, status, txRef, id, paymentType);
    }
  }

  _processResponse(Uri url, String? status, String? txRef, String? id, String? paymentType) {
    if ("successful" == status) {
      callBack.onTransactionSuccess(id!, txRef!, paymentType!);
    } else {
      callBack.onCancelled();
    }
    haveCallBacksBeenCalled = true;
    close();
  }

  @override
  Future onLoadStop(url) async {}

  @override
  void onLoadError(url, code, message) {
    callBack.onTransactionError();
  }

  @override
  void onProgressChanged(progress) {}

  @override
  void onExit() {
    if (!haveCallBacksBeenCalled) {
      callBack.onCancelled();
    }
  }
}
