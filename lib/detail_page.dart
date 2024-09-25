import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Ensure this dependency is added in pubspec.yaml

class DetailsPage extends StatelessWidget {
  final Map<String, dynamic> movie;

  const DetailsPage({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          movie['name'],
          style: TextStyle(color: Colors.white), // Set text color to white
        ),
        backgroundColor: Colors.black, // Dark theme color
        iconTheme: IconThemeData(color: Colors.white), // Set icon color to white
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Movie Image
            Container(
              width: 150, // Fixed width for the image
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8.0,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.network(
                  movie['image']['medium'],
                  fit: BoxFit.cover,
                  height: 200.0,
                  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(child: Icon(Icons.error, size: 48));
                  },
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            // Movie Name
            Text(
              movie['name'],
              style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8.0),
            // Info Cards
            _buildInfoCard('Genres: ${movie['genres'].join(", ")}'),
            _buildInfoCard('Language: ${movie['language']}', Icons.language), // Language icon
            _buildInfoCard('Status: ${movie['status']}', Icons.info), // Optional icon for status
            _buildRatingCard(movie['rating']['average']?.toString() ?? 'N/A'),
            const SizedBox(height: 16.0),
            // Summary Section
            const Text(
              'Summary:',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8.0),
            Text(
              movie['summary'].replaceAll(RegExp(r'<[^>]*>'), ''), // Remove HTML tags
              style: const TextStyle(fontSize: 16.0, color: Colors.white),
            ),
            const SizedBox(height: 16.0),
            // Watch Button
            TextButton(
              onPressed: () => _launchURL(movie['officialSite']),
              child: const Text('Watch on Official Site'),
              style: TextButton.styleFrom( // Use TextButton style
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                textStyle: const TextStyle(fontSize: 16.0, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black87, // Dark background for the whole page
    );
  }

  Widget _buildInfoCard(String info, [IconData? icon]) {
    return Card(
      color: Colors.grey[800], // Card color
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0), // Use same padding as rating card
        child: Row(
          mainAxisSize: MainAxisSize.min, // Use min size to fit content
          children: [
            if (icon != null)
              Icon(icon, color: Colors.white, size: 20), // Icon with specified size
            if (icon != null) const SizedBox(width: 4.0), // Space only if icon is present
            Text(
              info,
              style: const TextStyle(fontSize: 16.0, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }




  Widget _buildRatingCard(String rating) {
    return Card(
      color: Colors.grey[800], // Card color
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0), // Reduced padding to minimize extra space
        child: Row(
          mainAxisSize: MainAxisSize.min, // Use min size to fit content
          children: [
            const Icon(Icons.star, color: Colors.yellow, size: 20), // Star icon with specified size
            const SizedBox(width: 4.0), // Reduced space between icon and text
            Text(
              'Rating: $rating',
              style: const TextStyle(fontSize: 16.0, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }



  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url'; // Better error handling could be added here
    }
  }
}
