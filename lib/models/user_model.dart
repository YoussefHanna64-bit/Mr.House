enum UserRole { student, professor }

class UserModel {
  final String id;
  final String name;
  final String address;
  final String phoneNumber;
  final String gender;
  final String email;
  final UserRole role;
  final String? bio;
  final String? specialty;
  final String? age;
  final String? experience;

  const UserModel({
    required this.id,
    required this.name,
    required this.address,
    required this.phoneNumber,
    required this.gender,
    required this.email,
    required this.role,
    this.bio,
    this.specialty,
    this.age,
    this.experience,
  });

  factory UserModel.fromMap(
      String id, Map<String, dynamic> data, UserRole role) {
    return UserModel(
      id: id,
      name: data["name"] ?? data["Fullname"] ?? "",
      address: data["address"] ?? "",
      phoneNumber: data["phoneNumber"]?.toString() ?? "",
      gender: data["gender"] ?? "Male",
      email: data["email"] ?? "",
      role: role,
      bio: data["Bio"],
      specialty: data["Specialty"],
      age: data["Age"]?.toString(),
      experience: data["Experience"]?.toString(),
    );
  }
}
