class TaskModel {
  String description;
  // ignore: non_constant_identifier_names
  String device_type;
  String tdate;
  String title;
  String ttime;
  String uid;
  int status;
  String key;
  int millisecond;
  int reminderId;

  // ignore: non_constant_identifier_names
  TaskModel({this.description, this.device_type, this.tdate, this.title, this.ttime, this.uid, this.status,
    this.key, this.millisecond, this.reminderId});

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      description: json['description'],
      device_type: json['device_type'],
      tdate: json['tdate'],
      title: json['title'],
      ttime: json['ttime'],
      uid: json['uid'],
      status: json['status'],
      key: json['key'],
      millisecond: json['millisecond'],
      reminderId: json['reminderId'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['device_type'] = this.device_type;
    data['tdate'] = this.tdate;
    data['title'] = this.title;
    data['ttime'] = this.ttime;
    data['uid'] = this.uid;
    data['status'] = this.status;
    data['key'] = this.key;
    data['millisecond'] = this.millisecond;
    data['reminderId'] = this.reminderId;
    return data;
  }
}