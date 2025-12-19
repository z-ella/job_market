import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/job.dart';

class ApiService {
  // Replace with your actual local IP if running on emulator (e.g. 10.0.2.2 for Android)
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  Future<List<Job>> fetchJobs({String? query, String? token}) async {
    String url = '$baseUrl/jobs';
    if (query != null && query.isNotEmpty) {
      url += '?search=$query';
    }

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Job> jobs = body.map((dynamic item) => Job.fromJson(item)).toList();
      return jobs;
    } else {
      throw Exception('Failed to load jobs');
    }
  }

  Future<Job> fetchJobDetails(int id, {String? token}) async {
    final response = await http.get(
      Uri.parse('$baseUrl/jobs/$id'),
      headers: {
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return Job.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load job details');
    }
  }
  
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Accept': 'application/json'},
        body: {
          'email': email,
          'password': password,
        },
      );
      
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return {
          'success': true, 
          'token': data['access_token'],
          'role': data['user']['role'],
        };
      } else {
        return {'success': false, 'message': data['message'] ?? 'Login failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Connection error. Is the server running?'};
    }
  }

  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Accept': 'application/json'},
        body: {
          'name': name,
          'email': email,
          'password': password,
        },
      );
      
      final data = jsonDecode(response.body);
      if (response.statusCode == 201) {
        return {'success': true, 'token': data['access_token']};
      } else {
        // Handle validation errors or server errors
        String errorMsg = data['message'] ?? 'Registration failed';
        if (data['errors'] != null) {
          // If there are detailed validation errors, pick the first one
          var errors = data['errors'] as Map<String, dynamic>;
          errorMsg = errors.values.first[0].toString();
        }
        return {'success': false, 'message': errorMsg};
      }
    } catch (e) {
      return {'success': false, 'message': 'Connection error. Is the server running?'};
    }
  }

  Future<bool> createJob(Map<String, dynamic> jobData, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/jobs'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jobData.map((key, value) => MapEntry(key, value.toString())),
    );

    return response.statusCode == 201;
  }

  Future<bool> deleteJob(int id, String token) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/jobs/$id'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    return response.statusCode == 200;
  }

  Future<List<Map<String, dynamic>>> fetchCategories() async {
    // Note: I haven't created a route for this yet, so I'll just mock it or assume it exists if I add it.
    // Actually, let's assume it exists if I add it to the backend.
    final response = await http.get(
      Uri.parse('$baseUrl/categories'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    }
    return [];
  }
}
