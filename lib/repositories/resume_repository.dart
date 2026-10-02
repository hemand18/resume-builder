import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/resume.dart';

class ResumeRepository {
  static const String _resumesKey = 'saved_resumes';

  /// Save or update a resume.
  Future<void> saveResume(Resume resume) async {
    final resumes = await getAllResumes();

    final existingIndex =
        resumes.indexWhere((item) => item.id == resume.id);

    resume.updatedAt = DateTime.now();

    if (existingIndex >= 0) {
      resumes[existingIndex] = resume;
    } else {
      resumes.add(resume);
    }

    await _saveAllResumes(resumes);
  }

  /// Get all saved resumes.
  Future<List<Resume>> getAllResumes() async {
    final prefs = await SharedPreferences.getInstance();

    final savedData = prefs.getString(_resumesKey);

    if (savedData == null || savedData.isEmpty) {
      return [];
    }

    try {
      final decoded = jsonDecode(savedData);

      if (decoded is! List) {
        return [];
      }

      return decoded
          .map(
            (item) => Resume.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList();
    } catch (_) {
      return [];
    }
  }

  /// Get a specific resume by ID.
  Future<Resume?> getResume(String id) async {
    final resumes = await getAllResumes();

    try {
      return resumes.firstWhere(
        (resume) => resume.id == id,
      );
    } catch (_) {
      return null;
    }
  }

  /// Delete a resume.
  Future<void> deleteResume(String id) async {
    final resumes = await getAllResumes();

    resumes.removeWhere(
      (resume) => resume.id == id,
    );

    await _saveAllResumes(resumes);
  }

  /// Duplicate a resume.
  Future<Resume?> duplicateResume(String id) async {
    final original = await getResume(id);

    if (original == null) {
      return null;
    }

    final copy = Resume(
      title: '${original.title} Copy',
      templateId: original.templateId,
      personalInfo: PersonalInfo(
        name: original.personalInfo.name,
        jobTitle: original.personalInfo.jobTitle,
        email: original.personalInfo.email,
        phone: original.personalInfo.phone,
        location: original.personalInfo.location,
        linkedin: original.personalInfo.linkedin,
        github: original.personalInfo.github,
        website: original.personalInfo.website,
        summary: original.personalInfo.summary,
      ),
      experience: original.experience
          .map(
            (item) => Experience(
              jobTitle: item.jobTitle,
              company: item.company,
              location: item.location,
              startDate: item.startDate,
              endDate: item.endDate,
              isCurrent: item.isCurrent,
              description: item.description,
            ),
          )
          .toList(),
      education: original.education
          .map(
            (item) => Education(
              degree: item.degree,
              institution: item.institution,
              location: item.location,
              startYear: item.startYear,
              endYear: item.endYear,
              grade: item.grade,
              description: item.description,
            ),
          )
          .toList(),
      skills: List<String>.from(original.skills),
      projects: original.projects
          .map(
            (item) => Project(
              name: item.name,
              technologies: item.technologies,
              description: item.description,
              githubUrl: item.githubUrl,
              liveUrl: item.liveUrl,
            ),
          )
          .toList(),
      certifications: original.certifications
          .map(
            (item) => Certification(
              name: item.name,
              organization: item.organization,
              date: item.date,
              credentialId: item.credentialId,
              url: item.url,
            ),
          )
          .toList(),
    );

    await saveResume(copy);

    return copy;
  }

  Future<void> _saveAllResumes(
    List<Resume> resumes,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    final data = resumes
        .map((resume) => resume.toJson())
        .toList();

    await prefs.setString(
      _resumesKey,
      jsonEncode(data),
    );
  }
}