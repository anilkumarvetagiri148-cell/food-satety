class AlertModel {
  final String id;
  final String category; // 'Expiry Alert', 'Food Safety Alert', 'Allergen Alert', 'Nutrition Alert'
  final String title;
  final String description;
  final String date;
  final String severity; // 'High', 'Medium', 'Low'
  bool isRead;

  AlertModel({
    required this.id,
    required this.category,
    required this.title,
    required this.description,
    required this.date,
    required this.severity,
    this.isRead = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'category': category,
        'title': title,
        'description': description,
        'date': date,
        'severity': severity,
        'isRead': isRead,
      };

  factory AlertModel.fromJson(Map<String, dynamic> json) => AlertModel(
        id: json['id'] ?? '',
        category: json['category'] ?? 'Food Safety Alert',
        title: json['title'] ?? '',
        description: json['description'] ?? '',
        date: json['date'] ?? '',
        severity: json['severity'] ?? 'Medium',
        isRead: json['isRead'] ?? false,
      );

  AlertModel copyWith({bool? isRead}) {
    return AlertModel(
      id: id,
      category: category,
      title: title,
      description: description,
      date: date,
      severity: severity,
      isRead: isRead ?? this.isRead,
    );
  }
}
