import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/job.dart';
import 'job_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService apiService = ApiService();
  late Future<List<Job>> futureJobs;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    futureJobs = apiService.fetchJobs();
  }

  void _searchJobs() {
    setState(() {
      futureJobs = apiService.fetchJobs(query: _searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search jobs...',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                    onSubmitted: (value) => _searchJobs(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _searchJobs,
                )
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Job>>(
              future: futureJobs,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  // If real API is not running, show dummy data for demo
                  return _buildDummyList(); 
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No jobs found'));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final job = snapshot.data![index];
                    return ListTile(
                      title: Text(job.title),
                      subtitle: Text('${job.companyName} • ${job.location}'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => JobDetailScreen(job: job),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDummyList() {
    // Fallback UI for when the API is not actually running locally
    final dummyJobs = [
      Job(id: 1, title: 'Laravel Developer', description: 'Great job', companyName: 'Tech Co', location: 'Remote', salary: 5000, categoryId: 1),
      Job(id: 2, title: 'Flutter Engineer', description: 'Mobile dev needed', companyName: 'App Studio', location: 'Paris', salary: 6000, categoryId: 1),
    ];
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Could not connect to API (is it running?). Showing demo data:", style: TextStyle(color: Colors.red)),
        Expanded(
          child: ListView.builder(
            itemCount: dummyJobs.length,
            itemBuilder: (context, index) {
              final job = dummyJobs[index];
              return ListTile(
                title: Text(job.title),
                subtitle: Text('${job.companyName} • ${job.location}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JobDetailScreen(job: job),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
