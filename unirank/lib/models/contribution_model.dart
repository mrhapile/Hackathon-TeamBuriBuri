class ContributionModel {
  final String id;
  final String userId;
  final DateTime date;
  final int count;

  ContributionModel({
    required this.id,
    required this.userId,
    required this.date,
    required this.count,
  });

  factory ContributionModel.fromJson(Map<String, dynamic> json) {
    return ContributionModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      date: DateTime.parse(json['date'] as String),
      count: json['count'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'date': date.toIso8601String(),
      'count': count,
    };
  }
}
