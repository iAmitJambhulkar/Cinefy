import 'package:flutter/material.dart';
import 'detail_page.dart';
import 'search_page.dart';
import 'movie_service.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Map<String, dynamic>>> _moviesFuture;

  @override
  void initState() {
    super.initState();
    _moviesFuture = MovieService().fetchMovies(); // Fetch movies when the widget initializes
  }

  @override
  Widget build(BuildContext context) {
    // Calculate the number of columns based on the screen width
    final width = MediaQuery.of(context).size.width;
    int crossAxisCount = 2; // Default for mobile

    if (width > 600) {
      crossAxisCount = 3; // For tablets
    }
    if (width > 900) {
      crossAxisCount = 4; // For larger screens
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: SizedBox(
          height: 50,
          child: Image.asset('assets/logo.png', width: 150, ),
        ),
        backgroundColor: Colors.grey[900],
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            color: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchPage()),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _moviesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No movies found.'));
          }

          final movies = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0), // Increased padding for better appearance
            child: GridView.builder(
              shrinkWrap: true, // Allow GridView to take only necessary space
              physics: const NeverScrollableScrollPhysics(), // Prevent scrolling in GridView
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount, // Dynamic column count
                childAspectRatio: 0.65, // Adjusted for better card shape
                crossAxisSpacing: 16.0, // Increased spacing
                mainAxisSpacing: 16.0, // Increased spacing
              ),
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailsPage(movie: movie),
                      ),
                    );
                  },
                  child: AnimatedScale(
                    scale: 1.0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(color: Colors.grey.withOpacity(0.5)), // Subtle border
                        color: Colors.grey[800], // Adjusted dark grey card background color
                      ),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: Image.network(
                              movie['image']?['medium'] ?? 'https://example.com/placeholder.jpg',
                              fit: BoxFit.cover, // Image covers the entire card
                              height: double.infinity, // Ensure the image takes full height
                              width: double.infinity, // Ensure the image takes full width
                              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) return child; // Image loaded
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                                        : null,
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                print("Error loading image: $error"); // Log error
                                return const Center(child: Text('Image not available'));
                              },
                            ),
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: Container(
                              color: Colors.black54, // Semi-transparent background for text readability
                              padding: const EdgeInsets.symmetric(vertical: 8.0), // Increased padding
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    movie['name'] ?? 'Unknown Movie',
                                    style: const TextStyle(
                                      fontSize: 18, // Increased font size for better readability
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text(
                                      movie['summary']?.replaceAll(RegExp(r'<[^>]*>'), '') ?? 'No summary available',
                                      style: const TextStyle(fontSize: 14, color: Colors.white), // White text for summary
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
