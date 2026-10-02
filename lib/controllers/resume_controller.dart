import 'dart:async';

import '../models/resume.dart';
import '../repositories/resume_repository.dart';

class ResumeController {
  ResumeController._();

  static final ResumeController instance = ResumeController._();

  final ResumeRepository _repository = ResumeRepository();

  Resume resume = Resume();

  Timer? _autosaveTimer;

  /// Load a specific resume for editing.
  Future<void> loadResume(String id) async {
    final savedResume = await _repository.getResume(id);

    if (savedResume != null) {
      resume = savedResume;
    }
  }

  /// Create a brand-new resume.
  void createNewResume({
    String title = 'My Resume',
  }) {
    _cancelAutosave();
    resume = Resume(title: title);
  }

  /// Save the currently edited resume immediately.
  Future<void> saveResume() async {
    resume.updatedAt = DateTime.now();
    await _repository.saveResume(resume);
  }

  /// Schedule an automatic save.
  ///
  /// Every new change resets the timer.
  /// The resume is saved only after the user
  /// stops making changes for 700 milliseconds.
  void scheduleAutosave() {
    _autosaveTimer?.cancel();

    _autosaveTimer = Timer(
      const Duration(milliseconds: 700),
      () async {
        await saveResume();
      },
    );
  }

  /// Save immediately and cancel any pending autosave.
  Future<void> saveNow() async {
    _cancelAutosave();
    await saveResume();
  }

  /// Get all saved resumes.
  Future<List<Resume>> getAllResumes() async {
    return _repository.getAllResumes();
  }

  /// Delete a resume.
  Future<void> deleteResume(String id) async {
    await _repository.deleteResume(id);
  }

  /// Duplicate a resume.
  Future<Resume?> duplicateResume(String id) async {
    return _repository.duplicateResume(id);
  }

  /// Reset the current editing session.
  void resetResume() {
    _cancelAutosave();
    resume = Resume();
  }

  void _cancelAutosave() {
    _autosaveTimer?.cancel();
    _autosaveTimer = null;
  }
}