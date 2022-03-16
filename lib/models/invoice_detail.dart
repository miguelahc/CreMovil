import 'package:intl/intl.dart';

class InvoiceDetail {
  final documentNumber;
  final companyNumber;
  bool downloadInvoice = false;
  bool  payInvoice = false;
  String titularName = "";
  String invoiceName = "";
  String location = "";
  String categoryName = "";
  double baseTaxCredit = 0.0;
  double totalInvoice = 0.0;
  String status = "";
  String dateIssue = "";
  String from = "";
  String until = "";
  int readingCurrent = 0;
  int readingBefore = 0;
  DateTime dateReadingCurrent = DateTime(1900, 1, 1);
  DateTime dateReadingBefore = DateTime(1900, 1, 1);
  int daysConsumption = 0;
  int consumption = 0;
  Iterable<dynamic> energyPower = [];
  Iterable<dynamic> municipalFees = [];
  Iterable<dynamic> chargesPayments = [];
  Iterable<dynamic> others = [];
  InvoiceDetail(this.documentNumber, this.companyNumber);
}

class DataInvoice {
  String titularName;
  String invoiceName;
  String location;
  String categoryName;
  double baseTaxCredit;
  double totaInvoice;
  String status = "";
  String dateIssue = "";
  String from = "";
  String until = "";
  int readingCurrent;
  int readingBefore;
  DateTime dateReadingCurrent;
  DateTime dateReadingBefore;
  int daysConsumption;
  int consumption;
  List detalle;
  DataInvoice(
      this.baseTaxCredit,
      this.categoryName,
      this.invoiceName,
      this.location,
      this.titularName,
      this.totaInvoice,
      this.detalle,
      this.readingBefore,
      this.readingCurrent,
      this.dateReadingBefore,
      this.dateReadingCurrent,
      this.consumption,
      this.daysConsumption);

  Map<String, dynamic> toJson() => {
    'detalle': detalle.isEmpty ? '[]' : listdetallesimulacion(detalle),
    'TitularName': titularName,
    'InvoiceName': invoiceName,
    'Location': location,
    'CategoryName': categoryName,
    'BaseTaxCredit': baseTaxCredit,
    'TotaInvoice': totaInvoice,
    'Status': status,
    'DateIssue': dateIssue,
    'ReadingBefore': readingBefore,
    'ReadingCurrent': readingCurrent,
    'DateReadingBefore': (dateReadingBefore.toString()).toString(),
    'DateReadingCurrent': (dateReadingCurrent.toString()).toString(),
    'Consumption': consumption,
    'DaysConsumption': daysConsumption,
    'From': from,
    "Until": until
  };
  List listdetallesimulacion(List listestconceptos) {
    DetailsSimulateInvoice detalleSimularFactura;
    String _category;
    String _description;
    String _value;
    String _concept;
    DateFormat dateFormat = DateFormat("dd/MM/yyyy");
    List resultConceptos = new List.empty(growable: true);
    for (int i = 0; i < listestconceptos.length; i++) {
      _category = listestconceptos[i]["dscate"] == null
          ? ""
          : listestconceptos[i]["dscate"].toString();
      _description = (listestconceptos[i])["dsconc"].toString();
      _value = listestconceptos[i]["vaconc"] == null
          ? "0"
          : listestconceptos[i]["vaconc"].toString();
      _concept = listestconceptos[i]["dtconc"] == null
          ? ""
          : listestconceptos[i]["dtconc"].toString();

      detalleSimularFactura = DetailsSimulateInvoice(_category, _concept, _description, _value);

      if (_description.trim().toLowerCase() == "titular")
        this.titularName = _concept;
      else if (_description.trim().toLowerCase() == "a facturar")
        this.invoiceName = _concept;
      else if (_description.trim().toLowerCase() == "ubicación")
        this.location = _concept;
      else if (_description.trim().toLowerCase() == "categoría")
        this.categoryName = _concept;
      else if (_description.trim().toLowerCase() == "total facturado")
        this.totaInvoice = double.parse(_concept == "" ? _value : _concept);
      else if (_description.trim().toLowerCase() == "base para crédito fiscal")
        this.baseTaxCredit = double.parse(_concept == "" ? _value : _concept);
      else if (_description.trim().toLowerCase() == "estado")
        this.status = _concept;
      else if (_description.trim().toLowerCase() == "fecha emisión")
        this.dateIssue = _concept;
      else if (_description.trim().toLowerCase() == "fecha lectura desde")
        this.from = _concept ;
      else if (_description.trim().toLowerCase() == "fecha lectura hasta")
        this.until = _concept;
      else if (_description.trim().toLowerCase() == "dias lectura")
        this.daysConsumption = int.parse(_concept);
      /*
      else if (_description.trim() == "Lectura anterior")
        this.readingBefore =
            int.parse(listestconceptos[i]["vaconc"].toString());
      else if (_description.trim() == "Lectura actual")
        this.readingCurrent =
            int.parse(listestconceptos[i]["vaconc"].toString());
      else if (_description.trim() == "Fecha lectura anterior")
        this.dateReadingBefore = dateFormat.parse(_concept);
      else if (_description.trim() == "Fecha lectura actual")
        this.dateReadingCurrent = dateFormat.parse(_concept);
      else if (_description.trim() == "Dias de consumo")
        this.daysConsumption = int.parse(_concept);
      else if (_description.trim() == "Consumo")
        this.consumption = int.parse(listestconceptos[i]["vaconc"].toString());
        */
      else {
        resultConceptos.add(detalleSimularFactura.toJson());
      }
    }
    return resultConceptos;
  }
}

class DetailsSimulateInvoice {
  String category;
  String description;
  String value;
  String concept;
  DetailsSimulateInvoice(
      this.category, this.concept, this.description, this.value);

  Map<String, dynamic> toJson() => {
    'Category': category,
    'Description': description,
    'Value': value,
    'Concept': concept,
  };
}
