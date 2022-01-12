class NotificationModel {
  final String title;
  final String content;
  final int id;


  NotificationModel(this.id, this.title, this.content);

  NotificationModel.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        content = json['content'],
        id = json['id'];

  Map<String, dynamic> toJson() => {
    'id' : id,
    'title': title,
    'content': content,
  };
}