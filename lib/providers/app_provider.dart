import 'package:flutter/material.dart';
import '../models/models.dart';
import '../data/data_source.dart';

class AppProvider with ChangeNotifier {
  UserProfile _userProfile = UserProfile(
    name: 'Budi Santoso', // Default name
    location: 'Banyuwangi, Jawa Timur',
    landArea: 10000, // 1 Ha default
    variety: 'Ciherang',
    plantingDate: DateTime.now().subtract(const Duration(days: 45)), // Example
  );

  bool _isDarkMode = false;

  // Diagnosis State
  Map<String, bool> _selectedSymptoms = {}; // ID -> bool
  Disease? _diagnosisResult;
  double _diagnosisConfidence = 0.0;

  // History
  List<Disease> _diagnosisHistory = [];

  UserProfile get userProfile => _userProfile;
  bool get isDarkMode => _isDarkMode;
  Map<String, bool> get selectedSymptoms => _selectedSymptoms;
  Disease? get diagnosisResult => _diagnosisResult;
  double get diagnosisConfidence => _diagnosisConfidence;
  List<Disease> get diagnosisHistory => _diagnosisHistory;

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void updateProfile(UserProfile newProfile) {
    _userProfile = newProfile;
    notifyListeners();
  }

  void toggleSymptom(String id) {
    if (_selectedSymptoms.containsKey(id)) {
      _selectedSymptoms.remove(id);
    } else {
      _selectedSymptoms[id] = true;
    }
    notifyListeners();
  }

  void resetDiagnosis() {
    _selectedSymptoms.clear();
    _diagnosisResult = null;
    _diagnosisConfidence = 0.0;
    notifyListeners();
  }

  void runDiagnosis() {
    if (_selectedSymptoms.isEmpty) {
      _diagnosisResult = null;
      _diagnosisConfidence = 0.0;
      notifyListeners();
      return;
    }

    // Simple Expert System Logic: Matching Score
    // Calculate match percentage for each disease

    Disease? bestDisease;
    double maxScore = -1.0;

    for (var disease in DataSource.diseases) {
      int matchCount = 0;
      for (var symptomId in disease.symptoms) {
        if (_selectedSymptoms.containsKey(symptomId)) {
          matchCount++;
        }
      }

      // Score = (Matches / Total Symptoms for Disease) * (Matches / Total Selected Symptoms)
      // This weights both coverage of the disease profile and specificity of user selection.
      // Simplified: Just Matches / Total Symptoms of Disease

      double score = 0.0;
      if (disease.symptoms.isNotEmpty) {
        score = matchCount / disease.symptoms.length;
      }

      if (score > maxScore) {
        maxScore = score;
        bestDisease = disease;
      }
    }

    _diagnosisResult = bestDisease;
    _diagnosisConfidence = maxScore;

    if (bestDisease != null && maxScore > 0) {
       _diagnosisHistory.insert(0, bestDisease);
    }

    notifyListeners();
  }
}
