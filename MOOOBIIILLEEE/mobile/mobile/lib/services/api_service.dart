import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/job.dart';

class ApiService {
  // Replace with your actual local IP if running on emulator (e.g. 10.0.2.2 for Android)
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  Future<List<Job>> fetchJobs({String? query}) async {
    String url = '$baseUrl/jobs';
    if (query != null && query.isNotEmpty) {
      url += '?search=$query';
    }

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Job> jobs = body.map((dynamic item) => Job.fromJson(item)).toList();
      return jobs;
    } else {
      throw Exception('Failed to load jobs');
    }
  }

  Future<Job> fetchJobDetails(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/jobs/$id'));

    if (response.statusCode == 200) {
      return Job.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load job details');
    }
  }
  
  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      body: {
        'email': email,
        'password': password,
      },
    );
    
    return response.statusCode == 200;
  }
}
