class UserModel {
  final String name;
  final String email;
  final String? profileImage;
  final int totalScans;
  final int safeScans;
  final int warningScans;
  final int unsafeScans;

  UserModel({
    required this.name,
    required this.email,
    this.profileImage,
    this.totalScans = 0,
    this.safeScans = 0,
    this.warningScans = 0,
    this.unsafeScans = 0,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'profileImage': profileImage,
        'totalScans': totalScans,
        'safeScans': safeScans,
        'warningScans': warningScans,
        'unsafeScans': unsafeScans,
      };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        name: json['name'] ?? '',
        email: json['email'] ?? '',
        profileImage: json['profileImage'],
        totalScans: json['totalScans'] ?? 0,
        safeScans: json['safeScans'] ?? 0,
        warningScans: json['warningScans'] ?? 0,
        unsafeScans: json['unsafeScans'] ?? 0,
      );

  UserModel copyWith({
    String? name,
    String? email,
    String? profileImage,
    int? totalScans,
    int? safeScans,
    int? warningScans,
    int? unsafeScans,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      totalScans: totalScans ?? this.totalScans,
      safeScans: safeScans ?? this.safeScans,
      warningScans: warningScans ?? this.warningScans,
      unsafeScans: unsafeScans ?? this.unsafeScans,
    );
  }
}
