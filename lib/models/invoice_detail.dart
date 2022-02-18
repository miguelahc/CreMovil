class InvoiceDetail {
  final documentNumber;
  final companyNumber;
  String titularName = "";
  String invoiceName = "";
  String location = "";
  String categoryName = "";
  double baseTaxCredit = 0.0;
  double totalInvoice = 0.0;
  Iterable<dynamic> energyPower = [];
  Iterable<dynamic> municipalFees = [];
  Iterable<dynamic> chargesPayments = [];

  InvoiceDetail(this.documentNumber, this.companyNumber);
}
