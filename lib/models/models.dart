
class Symptom {
  final String id;
  final String description;
  final String category; // 'leaf', 'stem', 'fruit', 'root', 'general'
  final String? imageUrl;
  bool isSelected;

  Symptom({
    required this.id,
    required this.description,
    required this.category,
    this.imageUrl,
    this.isSelected = false,
  });
}

class Disease {
  final String id;
  final String name;
  final String description;
  final String scientificName;
  final String cause; // Bakteri, Jamur, Virus, Hama
  final List<String> symptoms; // List of Symptom IDs
  final List<String> prevention;
  final List<String> treatment;
  final String imageUrl;
  final String severity; // High, Medium, Low

  Disease({
    required this.id,
    required this.name,
    required this.description,
    required this.scientificName,
    required this.cause,
    required this.symptoms,
    required this.prevention,
    required this.treatment,
    required this.imageUrl,
    required this.severity,
  });
}

class LibraryItem {
  final String id;
  final String title;
  final String category; // Budidaya, Hama, Penyakit, Pupuk, Varietas
  final String content;
  final String summary;
  final String imageUrl;
  final String date;

  LibraryItem({
    required this.id,
    required this.title,
    required this.category,
    required this.content,
    required this.summary,
    required this.imageUrl,
    required this.date,
  });
}

class FarmingScheduleItem {
  final String title;
  final String description;
  final int dayStart;
  final int dayEnd;
  final String category; // Pupuk, Air, Hama, Panen
  final bool isCompleted;
  final String? actionLabel;

  FarmingScheduleItem({
    required this.title,
    required this.description,
    required this.dayStart,
    required this.dayEnd,
    required this.category,
    this.isCompleted = false,
    this.actionLabel,
  });
}

class UserProfile {
  String name;
  String location;
  double landArea; // in m2
  String variety;
  DateTime? plantingDate;

  UserProfile({
    this.name = '',
    this.location = '',
    this.landArea = 0,
    this.variety = '',
    this.plantingDate,
  });
}
