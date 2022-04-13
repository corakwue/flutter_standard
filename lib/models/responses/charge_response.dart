
import 'package:flutterwave_standard/core/transaction_status.dart';

class ChargeResponse {
  String? status;
  bool? success;
  String? transactionId;
  String? txRef;
  String? paymentType;

  ChargeResponse({this.status, this.success, this.transactionId,
    this.txRef, this.paymentType});

  ChargeResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'] == null ? TransactionStatus.ERROR : json['status'];
    success = json['success'] == null ? false : json['success'] ;
    transactionId = json['transaction_id'];
    txRef = json['tx_ref'];
    paymentType = json['payment_type'];
  }

  /// Converts this instance to json
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['success'] = this.success;
    data['transaction_id'] = this.transactionId;
    data['tx_ref'] = this.txRef;
    data['payment_type'] = this.paymentType;
    return data;
  }
}

