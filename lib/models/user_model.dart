class UserModel {
  final String uid;
  final String name;
  final String email;
  final String? photoBase64;
  final bool isAdmin;
  final DateTime createdAt;
  final DateTime? updatedAt;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.photoBase64,
    this.isAdmin = false,
    required this.createdAt,
    this.updatedAt,
  });

  // Converter para Map (para Firestore)
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'photoBase64': photoBase64,
      'isAdmin': isAdmin,
      'createdAt': createdAt,
      'updatedAt': updatedAt ?? DateTime.now(),
    };
  }

  // Criar a partir de um Map (do Firestore)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      photoBase64: map['photoBase64'],
      isAdmin: map['isAdmin'] ?? false,
      createdAt: map['createdAt']?.toDate() ?? DateTime.now(),
      updatedAt: map['updatedAt']?.toDate(),
    );
  }

  // Criar cópia com mudanças
  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? photoBase64,
    bool? isAdmin,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      photoBase64: photoBase64 ?? this.photoBase64,
      isAdmin: isAdmin ?? this.isAdmin,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
