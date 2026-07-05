class LocationModel {
  final String id;
  final String title;
  final String location;
  final String image;
  final String category;
  final String distance;
  final String tag;
  final String weatherOrRating;
  final bool isHike;

  LocationModel({
    required this.id,
    required this.title,
    required this.location,
    required this.image,
    required this.category,
    required this.distance,
    required this.tag,
    required this.weatherOrRating,
    this.isHike = false,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      location: json['location'] ?? '',
      image: json['image'] ?? '',
      category: json['category'] ?? '',
      distance: json['distance'] ?? '',
      tag: json['tag'] ?? '',
      weatherOrRating: json['weatherOrRating'] ?? '',
      isHike: json['isHike'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'location': location,
      'image': image,
      'category': category,
      'distance': distance,
      'tag': tag,
      'weatherOrRating': weatherOrRating,
      'isHike': isHike,
    };
  }
}
