class CourseModel {
  final String id;
  final String name;
  final String desc;
  final String introVid;
  final String rating;
  final String students;
  final String professorId;
  final String professorName;
  final String professorSpecialty;
  final String professorBio;
  final String professorExperience;
  final String professorAge;
  final List<Map<String, dynamic>> videos;

  const CourseModel({
    required this.id,
    required this.name,
    required this.desc,
    required this.introVid,
    required this.rating,
    required this.students,
    required this.professorId,
    required this.professorName,
    required this.professorSpecialty,
    required this.professorBio,
    required this.professorExperience,
    required this.professorAge,
    this.videos = const [],
  });

  factory CourseModel.fromMap(
    String id,
    Map<String, dynamic> data, {
    String professorId = "",
    String professorName = "",
    String professorSpecialty = "",
    String professorBio = "",
    String professorExperience = "",
    String professorAge = "",
  }) {
    return CourseModel(
      id: id,
      name: data["name"] ?? "",
      desc: data["desc"] ?? "",
      introVid: data["introvid"] ?? "",
      rating: data["Rating"]?.toString() ?? "",
      students: data["Students"]?.toString() ?? "",
      professorId: professorId,
      professorName: professorName,
      professorSpecialty: professorSpecialty,
      professorBio: professorBio,
      professorExperience: professorExperience,
      professorAge: professorAge,
      videos: List<Map<String, dynamic>>.from(data["videos"] ?? []),
    );
  }
}
