abstract class TransactionCallBack {
  onTransactionSuccess(String id, String txRef, String paymentType);
  onTransactionError();
  onCancelled();
}