class Notifications {
  String category;
  List<dynamic> notifications;
  String alias = "";
  String code = "";
  String title = "";
  String message = "";
  DateTime date = DateTime(1999,1,1);
  int imageId = -1;
  Notifications(this.category, this.notifications);
}
