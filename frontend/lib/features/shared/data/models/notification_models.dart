class NotificationResponse {
  final int id;
  final String title;
  final String message;
  final bool isRead;
  final String createdAt;
  final String timestamp;

  NotificationResponse({
    required this.id,
    required this.title,
    required this.message,
    required this.isRead,
    required this.createdAt,
    required this.timestamp,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    return NotificationResponse(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      message: json['message'] as String? ?? '',
      isRead: json['isRead'] as bool? ?? false,
      createdAt: json['createdAt'] as String? ?? '',
      timestamp: json['timestamp'] as String? ?? json['createdAt'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'isRead': isRead,
      'createdAt': createdAt,
      'timestamp': timestamp,
    };
  }
}
