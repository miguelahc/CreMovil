class ResultJson {
  int code;
  String message;
  String data;

  ResultJson(this.code, this.message, this.data);

  Map<String, dynamic> toJson() => {
    'Code': code,
    'Message': message,
    'Data': data,
  };
}