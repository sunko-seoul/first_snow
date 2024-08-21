class NotificationPayload {
  final String fcmToken;
  final String title;
  final String message;
  final String payload;

  NotificationPayload({
    required this.fcmToken,
    required this.title,
    required this.message,
    required this.payload,
  });

  Map<String, dynamic> toJson() {
    return {
      'token': fcmToken,
      'title': title,
      'message': message,
      'payload': payload,
    };
  }
}
