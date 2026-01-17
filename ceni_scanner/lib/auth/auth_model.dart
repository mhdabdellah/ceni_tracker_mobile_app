class UserModel {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String? wilaya;
  final int? wilayaId;
  final String? moughataa;
  final int? moughataaId;
  final String? commune;
  final int? communeId;
  final String? center;
  final int? centerId;
  final String? bureau;
  final int? bureauId;
  final bool isAdmin;
  final bool isManager;
  final bool isDif;
  final bool isSimpleUser;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.wilaya,
    this.wilayaId,
    this.moughataa,
    this.moughataaId,
    this.commune,
    this.communeId,
    this.center,
    this.centerId,
    this.bureau,
    this.bureauId,
    required this.isAdmin,
    required this.isManager,
    required this.isDif,
    required this.isSimpleUser,
  });

  /// **Convert from Map**
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as int,
      username: map['username'] as String,
      email: map['email'] as String,
      firstName: map['first_name'] as String,
      lastName: map['last_name'] as String,
      wilaya: map['wilaya'] as String?,
      wilayaId: map['wilaya_id'] as int?,
      moughataa: map['moughataa'] as String?,
      moughataaId: map['moughataa_id'] as int?,
      commune: map['commune'] as String?,
      communeId: map['commune_id'] as int?,
      center: map['center'] as String?,
      centerId: map['center_id'] as int?,
      bureau: map['bureau'] as String?,
      bureauId: map['bureau_id'] as int?,
      isAdmin: map['is_admin'] as bool,
      isManager: map['is_manager'] as bool,
      isDif: map['is_dif'] as bool,
      isSimpleUser: map['is_simple_user'] as bool,
    );
  }

  /// **Convert to Map**
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'wilaya': wilaya,
      'wilaya_id': wilayaId,
      'moughataa': moughataa,
      'moughataa_id': moughataaId,
      'commune': commune,
      'commune_id': communeId,
      'center': center,
      'center_id': centerId,
      'bureau': bureau,
      'bureau_id': bureauId,
      'is_admin': isAdmin,
      'is_manager': isManager,
      'is_dif': isDif,
      'is_simple_user': isSimpleUser,
    };
  }
}

class UserAssignment {
  final int userId;
  final String username;
  final int? wilaya;
  final int? moughataa;
  final int? commune;
  final int? center;
  final int? bureau;

  UserAssignment({
    required this.userId,
    required this.username,
    this.wilaya,
    this.moughataa,
    this.commune,
    this.center,
    this.bureau,
  });

  factory UserAssignment.fromMap(Map<String, dynamic> map) {
    return UserAssignment(
      userId: map['user_id'],
      username: map['username'],
      wilaya: map['wilaya'] != null ? int.parse(map['wilaya']) : null,
      moughataa: map['moughataa'] != null ? int.parse(map['moughataa']) : null,
      commune: map['commune'] != null ? int.parse(map['commune']) : null,
      center: map['center'] != null ? int.parse(map['center']) : null,
      bureau: map['bureau'] != null ? int.parse(map['bureau']) : null,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'username': username,
      'wilaya': wilaya,
      'moughataa': moughataa,
      'commune': commune,
      'center': center,
      'bureau': bureau,
    };
  }
}

class User {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
  });

  User.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        username = map['username'],
        email = map['email'],
        firstName = map['first_name'],
        lastName = map['last_name'];

  Map<String, dynamic> toMap() => {
        "username": username,
        "email": email,
        "first_name": firstName,
        "last_name": lastName
      };
}
