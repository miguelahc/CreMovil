class EmitPaymentDetail {
  final int idPayment;
  final String clientName;
  final String detail;
  final String detailQr;
  final String currency;
  final double totalAmount;
  final DateTime emitDate;
  final DateTime expirationDate;
  final String idQr;
  final String imageQr;

  EmitPaymentDetail(this.idPayment, this.clientName, this.detail, this.detailQr,
      this.currency, this.totalAmount, this.emitDate, this.expirationDate,
      this.idQr, this.imageQr);

}