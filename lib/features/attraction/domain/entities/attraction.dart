class Attraction {
  final String id;
  final String name;
  final String description;
  final String openingTime;
  final String closingTime;
  final int price;
  final String featuredImage;

  const Attraction({
    required this.id,
    required this.name,
    required this.description,
    required this.openingTime,
    required this.closingTime,
    required this.price,
    required this.featuredImage,
  });
}
