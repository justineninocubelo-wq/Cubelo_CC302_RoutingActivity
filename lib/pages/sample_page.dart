import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SamplePage extends StatefulWidget {
  const SamplePage({super.key});

  @override
  State<SamplePage> createState() => _SamplePageState();
}

class _SamplePageState extends State<SamplePage> {
  late Future<List<Map<String, dynamic>>> _posts;

  @override
  void initState() {
    super.initState();
    _posts = _fetchPosts();
  }

  Future<List<Map<String, dynamic>>> _fetchPosts() async {
    final response = await http.get(
      Uri.parse('https://dummyjson.com/users?limit=30'),
    );

    if (response.statusCode != 200) {
      throw Exception('Request failed (${response.statusCode})');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final users = data['users'] as List<dynamic>;

    return users.map((value) {
      final user = value as Map<String, dynamic>;

      final company = user['company'] as Map<String, dynamic>?;

      return {
        'id': user['id'],
        'name':
            '${user['firstName'] ?? ''} ${user['lastName'] ?? ''}'.trim(),
        'program':
            user['university'] ??
            company?['title'] ??
            'Not provided',
        'year': user['year'] ?? user['yearLevel'] ?? 'Not provided',
      };
    }).toList();
  }

  void _removePost(Map<String, dynamic> post) {
    setState(() {
      _posts = _posts.then(
        (posts) =>
            posts.where((item) => item['id'] != post['id']).toList(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Posts',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        Expanded(
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: _posts,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Could not load posts:\n${snapshot.error}',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _posts = _fetchPosts();
                          });
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              final posts = snapshot.data ?? [];

              if (posts.isEmpty) {
                return const Center(
                  child: Text('No posts available'),
                );
              }

              return ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];

                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5,
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text('${post['id']}'),
                      ),
                      title: Text(
                        post['name'].toString(),
                      ),
                      subtitle: Text(
                        '${post['program']}\nYear: ${post['year']}',
                      ),
                      isThreeLine: true,
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _removePost(post),
                      ),
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