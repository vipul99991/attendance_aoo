class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? profileImage;
  final String department;
  final String designation;
  final DateTime joinDate;
  final bool isActive;
  final UserRole role;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.profileImage,
    required this.department,
    required this.designation,
    required this.joinDate,
    this.isActive = true,
    this.role = UserRole.employee,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      profileImage: json['profileImage'],
      department: json['department'],
      designation: json['designation'],
      joinDate: DateTime.parse(json['joinDate']),
      isActive: json['isActive'] ?? true,
      role: UserRole.values.firstWhere(
        (e) => e.toString() == 'UserRole.${json['role']}',
        orElse: () => UserRole.employee,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'profileImage': profileImage,
      'department': department,
      'designation': designation,
      'joinDate': joinDate.toIso8601String(),
      'isActive': isActive,
      'role': role.toString().split('.').last,
    };
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? profileImage,
    String? department,
    String? designation,
    DateTime? joinDate,
    bool? isActive,
    UserRole? role,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profileImage: profileImage ?? this.profileImage,
      department: department ?? this.department,
      designation: designation ?? this.designation,
      joinDate: joinDate ?? this.joinDate,
      isActive: isActive ?? this.isActive,
      role: role ?? this.role,
    );
  }
}

enum UserRole { admin, manager, employee }
