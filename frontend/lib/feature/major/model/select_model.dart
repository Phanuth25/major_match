class SelectModel {
  final String message;
  final List<Major> majors;

  SelectModel({required this.message, required this.majors});

  factory SelectModel.fromJson(Map<String, dynamic> json) {
    return SelectModel(
      message: json['message'] as String? ?? '',
      majors: (json['majors'] as List<dynamic>?)
              ?.map((item) => Major.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class Major {
  final int id;
  final String name;
  final String description;
  final String image;
  final String career;

  Major({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.career,
  });

  factory Major.fromJson(Map<String, dynamic> json) {
    return Major(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      image: json['image'] as String? ?? '',
      career: json['career'] as String? ?? '',
    );
  }
}