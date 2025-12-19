class Job {
  final int id;
  final String title;
  final String description;
  final String companyName;
  final String location;
  final double? salary;
  final int categoryId;

  Job({
    required this.id,
    required this.title,
    required this.description,
    required this.companyName,
    required this.location,
    this.salary,
    required this.categoryId,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      companyName: json['company_name'],
      location: json['location'],
      salary: json['salary'] != null ? double.parse(json['salary'].toString()) : null,
      categoryId: json['category_id'],
    );
  }
}
