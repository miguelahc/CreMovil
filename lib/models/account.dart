import 'package:json_annotation/json_annotation.dart';

class Account {
  String accountNumber;
  String identificationNumber;
  String aliasName;

  Account(this.accountNumber, this.identificationNumber, this.aliasName);
}

@JsonSerializable()
class AccountCre {
  String pin;
  String phoneNumber;
  String phoneImei;
  String accountNumber;
  String companyNumber;
  String identificationNumber;
  String aliasName;
  String environment;
  String phoneSO;
  String phonePushId;
  String accountType;
  String documentNumber;
  String currentReading;
  String imageReading;
  String accountId;
  String titularName;
  DateTime dateRegister;
  DateTime dateModified;
  String isPartner;
  String address;
  double totalDebt;
  String stateAccount;
  String registerState; //"R",
  String districtCode; //"3",
  String sectionCode; //"3",
  String numberUV; //"0",
  String numz; //"0058",
  List estadocuenta;

  AccountCre(
      this.pin,
      this.phoneNumber,
      this.phoneImei,
      this.accountNumber,
      this.companyNumber,
      this.identificationNumber,
      this.aliasName,
      this.environment,
      this.phoneSO,
      this.phonePushId,
      this.accountType,
      this.documentNumber,
      this.currentReading,
      this.imageReading,
      this.accountId,
      this.titularName,
      this.dateRegister,
      this.dateModified,
      this.isPartner,
      this.address,
      this.totalDebt,
      this.stateAccount,
      this.registerState,
      this.districtCode,
      this.sectionCode,
      this.numberUV,
      this.numz,
      this.estadocuenta);

  Map<String, dynamic> toJson() => {
        if (pin != "NULL") 'Pin': pin,
        if (phoneNumber != "NULL") 'PhoneNumber': phoneNumber,
        if (phoneImei != "NULL") 'PhoneImei': phoneImei,
        if (accountNumber != "NULL") 'AccountNumber': accountNumber,
        if (companyNumber != "NULL") 'CompanyNumber': companyNumber,
        if (identificationNumber != "NULL")
          'IdentificationNumber': identificationNumber,
        if (aliasName != "NULL") 'AliasName': aliasName,
        if (environment != "NULL") 'Environment': environment,
        if (phoneSO != "NULL") 'PhoneSO': phoneSO,
        if (phonePushId != "NULL") 'PhonePushId': phonePushId,
        if (accountType != "NULL") 'AccountType': accountType,
        if (documentNumber != "NULL") 'DocumentNumber': documentNumber,
        if (currentReading != "NULL") 'CurrentReading': currentReading,
        if (imageReading != "NULL") 'ImageReading': imageReading,
        if (accountId != "NULL") 'AccountId': accountId,
        if (titularName != "NULL") 'TitularName': titularName,
        'DateRegister': dateRegister.toIso8601String(),
        'DateModified': dateModified.toIso8601String(),
        if (isPartner != "NULL") 'IsPartner': isPartner,
        if (address != "NULL") 'Address': address,
        if (totalDebt != -1) 'TotalDebt': totalDebt,
        if (stateAccount != "NULL") 'StateAccount': stateAccount,
        if (registerState != "NULL") 'RegisterState': registerState,
        if (districtCode != "NULL") 'DistrictCode': districtCode,
        if (sectionCode != "NULL") 'SectionCode': sectionCode,
        if (numberUV != "NULL") 'NumberUV': numberUV,
        if (numz != "NULL") 'numz': numz,
        'estadocuenta':
            estadocuenta.isEmpty ? '[]' : listestadocuenta(estadocuenta),
      };

  List listestadocuenta(List listestcuenta) {
    AccountStatement accountstatement;
    String companynumber,
        dategestion,
        dateinvoice,
        documentnumber,
        downloadinvoice,
        payinvoice,
        totalinvoice,
        valuekwh;

    List resultestadocuenta = new List.empty(growable: true);
    for (int i = 0; i < listestcuenta.length; i++) {
      companynumber = (listestcuenta[i])["nucomp"].toString();
      dategestion = (listestcuenta[i])["dsgest"].toString();
      dateinvoice = (listestcuenta[i])["stfact"].toString();
      documentnumber = (listestcuenta[i])["nudocu"].toString();
      downloadinvoice = (listestcuenta[i])["opfact"].toString();
      payinvoice = (listestcuenta[i])["oppaga"].toString();
      totalinvoice = (listestcuenta[i])["tofact"].toString();
      valuekwh = (listestcuenta[i])["vakwh"].toString();
      accountstatement = new AccountStatement(
          companynumber,
          dategestion,
          dateinvoice,
          documentnumber,
          downloadinvoice,
          payinvoice,
          double.parse(totalinvoice),
          int.parse(valuekwh));
      resultestadocuenta.add(accountstatement.toJson());
    }
    return resultestadocuenta;
  }
}

class RegisterAccount {
  int companyName;
  String clientName;
  String typeAccount;

  RegisterAccount(this.companyName, this.clientName, this.typeAccount);

  Map<String, dynamic> toJson() => {
        'CompanyName': companyName,
        'ClientName': clientName,
        'TypeAccount': typeAccount,
      };
}

class AccountStatement {
  String documentNumber;
  String companyNumber;
  int valuekwh;
  String dateGestion;
  double totalInvoice;
  String dateInvoice;
  String downloadInvoice; //S o N --Indica si se puede descargar la factura
  String payInvoice; //S o N --Indica si se puede pagar la factura
  AccountStatement(
      this.companyNumber,
      this.dateGestion,
      this.dateInvoice,
      this.documentNumber,
      this.downloadInvoice,
      this.payInvoice,
      this.totalInvoice,
      this.valuekwh);

  Map<String, dynamic> toJson() => {
        'DocumentNumber': documentNumber,
        'CompanyNumber': companyNumber,
        'Valuekwh': valuekwh,
        'DateGestion': dateGestion,
        'TotalInvoice': totalInvoice,
        'DateInvoice': dateInvoice,
        'DownloadInvoice': downloadInvoice,
        'PayInvoice': payInvoice,
      };
}

class ListAccounts {
  String phoneNumber;
  String phoneImei;
  String accountNumber;
  String accountName;
  String companyNumber;
  String aliasName;
  String accountType;
  String accountTypeRegister;
  double amountDebt;
  int numberInvoicesDue;
  String dateLastReading;
  int lastReading;
  String category;

  ListAccounts(
      this.accountName,
      this.accountNumber,
      this.accountType,
      this.accountTypeRegister,
      this.aliasName,
      this.companyNumber,
      this.phoneImei,
      this.phoneNumber,
      this.amountDebt,
      this.numberInvoicesDue,
      this.dateLastReading,
      this.lastReading,
      this.category);

  static List getAccounts(List listestcuenta) {
    String phonenumber,
        phoneimei,
        accountnumber,
        accountname,
        companynumber,
        aliasname,
        accounttype,
        accounttyperegister;
    double amountdebt;
    int numberinvoicesdue;
    String dateLastReading;
    int lastReading;
    String category;
    ListAccounts accountstatement;
    List resultcuentas = new List.empty(growable: true);
    for (int i = 0; i < listestcuenta.length; i++) {
      phonenumber = listestcuenta[i]["nutele"].toString();
      phoneimei = (listestcuenta[i])["dsimei"];
      accountnumber = (listestcuenta[i])["nucuen"].toString();
      accountname = (listestcuenta[i]["nocuen"] ?? "");
      companynumber = (listestcuenta[i])["nucomp"].toString();
      aliasname = (listestcuenta[i])["noalia"];
      dateLastReading = (listestcuenta[i]["fclect"] ?? "");
      lastReading = (listestcuenta[i]["valect"] ?? "");
      accounttype = (listestcuenta[i])["ticuen"].toString();
      accounttyperegister = (listestcuenta[i])["tiregi"];
      amountdebt = double.parse((listestcuenta[i])["modeud"].toString());
      numberinvoicesdue = (listestcuenta[i])["ctdeud"];
      category = (listestcuenta[i])["dscate"];
      accountstatement = ListAccounts(
          accountname,
          accountnumber,
          accounttype,
          accounttyperegister,
          aliasname,
          companynumber,
          phoneimei,
          phonenumber,
          amountdebt,
          numberinvoicesdue,
          dateLastReading,
          lastReading,
      category);
      resultcuentas.add(accountstatement.toJson());
    }
    return resultcuentas;
  }

  Map<String, dynamic> toJson() => {
        'PhoneNumber': phoneNumber,
        'PhoneImei': phoneNumber,
        'AccountNumber': accountNumber,
        'AccountName': accountName,
        'CompanyNumber': companyNumber,
        'AliasName': aliasName,
        'AccountType': accountType,
        'AccountTypeRegister': accountTypeRegister,
        'AmountDebt': amountDebt,
        'NumberInvoicesDue': numberInvoicesDue,
        'DateLastReading': dateLastReading,
        'LastReading': lastReading,
        'Category': category
      };
}
