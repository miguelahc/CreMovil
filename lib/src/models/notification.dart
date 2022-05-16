import 'package:app_cre/src/models/models.dart';

class Notifications {
  int id = -1;
  List<dynamic> notifications = [];
  int companyNumber = 1;
  String alias = "";
  int code = -1;
  String title = "";
  String message = "";
  DateTime date = DateTime(1999,1,1);
  int imageId = -1;
  bool havePosition = false;
  Category category;
  int noRead = 0;
  Notifications(this.category);
}
