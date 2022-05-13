class Notifications {
  int id = -1;
  String category;
  List<dynamic> notifications;
  int companyNumber = 1;
  String alias = "";
  int code = -1;
  String title = "";
  String message = "";
  DateTime date = DateTime(1999,1,1);
  int imageId = -1;
  bool havePosition = false;
  int categoryId = -1;
  Notifications(this.category, this.notifications);
}
