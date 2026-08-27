import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'resume.dart';

class ResumeController {
  ResumeController._();

  static final ResumeController instance = ResumeController._();

  Resume resume = Resume();

  static const String _resumeKey = 'current_resume';

  Future<void> saveResume() async {
    final prefs = await SharedPreferences.getInstance();

    final resumeJson = jsonEncode(resume.toJson());

    await prefs.setString(_resumeKey, resumeJson);
  }

  Future<void> loadResume() async {
    final prefs = await SharedPreferences.getInstance();

    final savedResume = prefs.getString(_resumeKey);

    if (savedResume == null || savedResume.isEmpty) {
      resume = Resume();
      return;
    }

    try {
      final Map<String, dynamic> json =
          jsonDecode(savedResume) as Map<String, dynamic>;

      resume = Resume.fromJson(json);
    } catch (e) {
      resume = Resume();
    }
  }

  Future<void> deleteSavedResume() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_resumeKey);

    resume = Resume();
  }

  void resetResume() {
    resume = Resume();
  }
}
