class Restaurant {
  final String id;
  final String name;
  final String image; // URL form
  final double rating;
  final String description;
  final List<String> tags;
  final String priceRange; // e.g. "$$", "Rs. 800-1200"
  final String location; // e.g. "Karachi, Pakistan"
  final Map<String, String> openingHours; // e.g. {"mon": "9am-11pm"}

  Restaurant({
    required this.id,
    required this.name,
    required this.image,
    required this.rating,
    required this.description,
    required this.tags,
    required this.priceRange,
    required this.location,
    required this.openingHours,
  });

  factory Restaurant.fromMap(Map<String, dynamic> data, String documentId) {
    return Restaurant(
      id: documentId,
      name: data['name'] ?? '',
      image: data['image'] ?? '',
      rating: (data['rating'] ?? 0).toDouble(),
      description: data['description'] ?? '',
      tags: (data['tags'] as List?)?.cast<String>() ?? <String>[],
      priceRange: data['priceRange'] ?? '',
      location: data['location'] ?? '',
      openingHours: data['openingHours'] != null
          ? Map<String, String>.from(data['openingHours'] as Map)
          : <String, String>{},
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
      'rating': rating,
      'description': description,
      'tags': tags,
      'priceRange': priceRange,
      'location': location,
      'openingHours': openingHours,
    };
  }
}
