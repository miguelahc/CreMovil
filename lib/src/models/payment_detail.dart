class PaymentDetail {
  final int number;
  final int type;
  final int paymentId;
  final int documentId;
  final String documentNumber;
  final int year;
  final int mount;
  final String period;
  final String currency;
  final double total;
  final double accumulated;
  bool isSelected = false;

  PaymentDetail(this.number, this.type, this.paymentId, this.documentId,
      this.documentNumber, this.year, this.mount, this.period, this.currency,
      this.total, this.accumulated);
}