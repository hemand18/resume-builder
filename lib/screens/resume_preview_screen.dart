import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../models/resume.dart';
import '../models/resume_controller.dart';

class ResumePreviewScreen extends StatelessWidget {
  final int templateIndex;

  const ResumePreviewScreen({
    super.key,
    required this.templateIndex,
  });

  static const Color primaryColor = Color(0xFF4F46E5);
  static const Color backgroundColor = Color(0xFFF1F5F9);
  static const Color textColor = Color(0xFF111827);
  static const Color secondaryTextColor = Color(0xFF6B7280);

  @override
  Widget build(BuildContext context) {
    final Resume resume = ResumeController.instance.resume;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Resume Preview',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(
          color: textColor,
        ),
        actions: [
          IconButton(
            tooltip: 'Print / Share',
            onPressed: () async {
              await _printResume(resume);
            },
            icon: const Icon(Icons.print_outlined),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          16,
          20,
          16,
          100,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 850,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildPreviewHeader(),
                const SizedBox(height: 16),
                _buildTemplate(resume),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(
            16,
            8,
            16,
            12,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: SizedBox(
            height: 54,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () async {
                await _printResume(resume);
              },
              icon: const Icon(
                Icons.picture_as_pdf_outlined,
              ),
              label: const Text(
                'Download / Print PDF',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // PREVIEW HEADER
  // ============================================================

  Widget _buildPreviewHeader() {
    const templateNames = [
      'Classic',
      'Modern',
      'Professional',
      'Minimal',
    ];

    final int safeIndex =
        templateIndex.clamp(0, templateNames.length - 1);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.indigo.shade50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.description_outlined,
              color: Colors.indigo,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your Resume',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${templateNames[safeIndex]} Template',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Ready',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.green.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BUILD TEMPLATE
  // ============================================================

  Widget _buildTemplate(Resume resume) {
    switch (templateIndex) {
      case 0:
        return _classicTemplate(resume);

      case 1:
        return _modernTemplate(resume);

      case 2:
        return _professionalTemplate(resume);

      case 3:
        return _minimalTemplate(resume);

      default:
        return _classicTemplate(resume);
    }
  }

  // ============================================================
  // CLASSIC TEMPLATE
  // ============================================================

  Widget _classicTemplate(Resume resume) {
    final personal = resume.personalInfo;

    return _resumeContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            personal.name.isEmpty
                ? 'Your Name'
                : personal.name,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),

          if (personal.jobTitle.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                personal.jobTitle,
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.grey.shade700,
                ),
              ),
            ),

          const SizedBox(height: 14),

          _contactInfo(personal),

          if (personal.summary.isNotEmpty) ...[
            _section('SUMMARY'),
            Text(
              personal.summary,
              style: const TextStyle(
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ],

          _educationSection(resume),
          _experienceSection(resume),
          _projectsSection(resume),
          _skillsSection(resume),
          _certificationsSection(resume),
        ],
      ),
    );
  }

  // ============================================================
  // MODERN TEMPLATE
  // ============================================================

  Widget _modernTemplate(Resume resume) {
    final personal = resume.personalInfo;

    return _resumeContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Colors.blue.shade700,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  personal.name.isEmpty
                      ? 'Your Name'
                      : personal.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                if (personal.jobTitle.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      personal.jobTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 15),

          _contactInfo(personal),

          if (personal.summary.isNotEmpty) ...[
            _section('PROFILE'),
            Text(
              personal.summary,
              style: const TextStyle(
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ],

          _educationSection(resume),
          _experienceSection(resume),
          _projectsSection(resume),
          _skillsSection(resume),
          _certificationsSection(resume),
        ],
      ),
    );
  }

  // ============================================================
  // PROFESSIONAL TEMPLATE
  // ============================================================

  Widget _professionalTemplate(Resume resume) {
    final personal = resume.personalInfo;

    return _resumeContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Colors.indigo.shade900,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  personal.name.isEmpty
                      ? 'YOUR NAME'
                      : personal.name.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),

                if (personal.jobTitle.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      personal.jobTitle,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 15,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 15),

          _contactInfo(personal),

          if (personal.summary.isNotEmpty) ...[
            _section('PROFESSIONAL SUMMARY'),
            Text(
              personal.summary,
              style: const TextStyle(
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ],

          _experienceSection(resume),
          _educationSection(resume),
          _projectsSection(resume),
          _skillsSection(resume),
          _certificationsSection(resume),
        ],
      ),
    );
  }

  // ============================================================
  // MINIMAL TEMPLATE
  // ============================================================

  Widget _minimalTemplate(Resume resume) {
    final personal = resume.personalInfo;

    return _resumeContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            personal.name.isEmpty
                ? 'Your Name'
                : personal.name,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w300,
              letterSpacing: 0.5,
            ),
          ),

          if (personal.jobTitle.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                personal.jobTitle,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 16,
                ),
              ),
            ),

          const SizedBox(height: 12),

          _contactInfo(personal),

          if (personal.summary.isNotEmpty) ...[
            _section('ABOUT'),
            Text(
              personal.summary,
              style: const TextStyle(
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ],

          _educationSection(resume),
          _experienceSection(resume),
          _projectsSection(resume),
          _skillsSection(resume),
          _certificationsSection(resume),
        ],
      ),
    );
  }

  // ============================================================
  // RESUME CONTAINER
  // ============================================================

  Widget _resumeContainer({
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(34),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }

  // ============================================================
  // CONTACT
  // ============================================================

  Widget _contactInfo(PersonalInfo personal) {
    final contacts = <Widget>[];

    if (personal.email.isNotEmpty) {
      contacts.add(
        _contactItem(
          Icons.email_outlined,
          personal.email,
        ),
      );
    }

    if (personal.phone.isNotEmpty) {
      contacts.add(
        _contactItem(
          Icons.phone_outlined,
          personal.phone,
        ),
      );
    }

    if (personal.location.isNotEmpty) {
      contacts.add(
        _contactItem(
          Icons.location_on_outlined,
          personal.location,
        ),
      );
    }

    if (personal.linkedin.isNotEmpty) {
      contacts.add(
        _contactItem(
          Icons.link,
          personal.linkedin,
        ),
      );
    }

    if (personal.github.isNotEmpty) {
      contacts.add(
        _contactItem(
          Icons.code,
          personal.github,
        ),
      );
    }

    if (personal.website.isNotEmpty) {
      contacts.add(
        _contactItem(
          Icons.language,
          personal.website,
        ),
      );
    }

    if (contacts.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      decoration: BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(
            color: Colors.grey.shade200,
          ),
        ),
      ),
      child: Wrap(
        spacing: 16,
        runSpacing: 9,
        children: contacts,
      ),
    );
  }

  Widget _contactItem(
    IconData icon,
    String text,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 15,
          color: Colors.indigo.shade700,
        ),
        const SizedBox(width: 5),
        Text(
          text,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // SECTION
  // ============================================================

  Widget _section(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 25,
        bottom: 10,
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.indigo.shade700,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 9),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // EDUCATION
  // ============================================================

  Widget _educationSection(Resume resume) {
    if (resume.education.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _section('EDUCATION'),

        ...resume.education.map(
          (education) => Padding(
            padding: const EdgeInsets.only(
              bottom: 15,
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  education.degree,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  education.institution,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),

                if (education.location.isNotEmpty)
                  Text(
                    education.location,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                    ),
                  ),

                if (education.startYear.isNotEmpty ||
                    education.endYear.isNotEmpty)
                  Text(
                    _dateRange(
                      education.startYear,
                      education.endYear,
                    ),
                    style: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                  ),

                if (education.grade.isNotEmpty)
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 2),
                    child: Text(
                      education.grade,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                if (education.description.isNotEmpty)
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 5),
                    child: Text(
                      education.description,
                      style: const TextStyle(
                        height: 1.4,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // EXPERIENCE
  // ============================================================

  Widget _experienceSection(Resume resume) {
    if (resume.experience.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _section('EXPERIENCE'),

        ...resume.experience.map(
          (experience) => Padding(
            padding: const EdgeInsets.only(
              bottom: 15,
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  experience.jobTitle,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  experience.company,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),

                if (experience.location.isNotEmpty)
                  Text(
                    experience.location,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                    ),
                  ),

                Text(
                  experience.isCurrent
                      ? '${experience.startDate} - Present'
                      : _dateRange(
                          experience.startDate,
                          experience.endDate,
                        ),
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                ),

                if (experience.description.isNotEmpty)
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 5),
                    child: Text(
                      experience.description,
                      style: const TextStyle(
                        height: 1.4,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // PROJECTS
  // ============================================================

  Widget _projectsSection(Resume resume) {
    if (resume.projects.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _section('PROJECTS'),

        ...resume.projects.map(
          (project) => Padding(
            padding: const EdgeInsets.only(
              bottom: 15,
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  project.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                if (project.technologies.isNotEmpty)
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 3),
                    child: Text(
                      project.technologies,
                      style: TextStyle(
                        color: Colors.indigo.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                if (project.description.isNotEmpty)
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 5),
                    child: Text(
                      project.description,
                      style: const TextStyle(
                        height: 1.4,
                      ),
                    ),
                  ),

                if (project.githubUrl.isNotEmpty)
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 4),
                    child: Text(
                      'GitHub: ${project.githubUrl}',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.indigo.shade700,
                      ),
                    ),
                  ),

                if (project.liveUrl.isNotEmpty)
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 2),
                    child: Text(
                      'Live Demo: ${project.liveUrl}',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.indigo.shade700,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // SKILLS
  // ============================================================

  Widget _skillsSection(Resume resume) {
    if (resume.skills.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _section('SKILLS'),

        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: resume.skills.map(
            (skill) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: Colors.indigo.shade50,
                  borderRadius:
                      BorderRadius.circular(6),
                  border: Border.all(
                    color: Colors.indigo.shade100,
                  ),
                ),
                child: Text(
                  skill,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.indigo.shade800,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            },
          ).toList(),
        ),
      ],
    );
  }

  // ============================================================
  // CERTIFICATIONS
  // ============================================================

  Widget _certificationsSection(Resume resume) {
    if (resume.certifications.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _section('CERTIFICATIONS'),

        ...resume.certifications.map(
          (certification) => Padding(
            padding: const EdgeInsets.only(
              bottom: 12,
            ),
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.workspace_premium_outlined,
                  size: 18,
                  color: Colors.indigo.shade700,
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        certification.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      if (certification
                          .organization.isNotEmpty)
                        Text(
                          certification.organization,
                        ),

                      if (certification.date.isNotEmpty)
                        Text(
                          certification.date,
                          style: TextStyle(
                            color:
                                Colors.grey.shade700,
                          ),
                        ),

                      if (certification
                          .credentialId.isNotEmpty)
                        Text(
                          'Credential ID: ${certification.credentialId}',
                          style: const TextStyle(
                            fontSize: 11,
                          ),
                        ),

                      if (certification.url.isNotEmpty)
                        Text(
                          certification.url,
                          style: TextStyle(
                            fontSize: 11,
                            color:
                                Colors.indigo.shade700,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // DATE RANGE
  // ============================================================

  String _dateRange(
    String start,
    String end,
  ) {
    if (start.isNotEmpty && end.isNotEmpty) {
      return '$start - $end';
    }

    if (start.isNotEmpty) {
      return start;
    }

    return end;
  }

  // ============================================================
  // PRINT / PDF
  // ============================================================

  Future<void> _printResume(
    Resume resume,
  ) async {
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async {
        return await _generatePdf(resume);
      },
    );
  }

  // ============================================================
  // GENERATE PDF
  // ============================================================

  Future<Uint8List> _generatePdf(
    Resume resume,
  ) async {
    final pdf = pw.Document();

    switch (templateIndex) {
      case 0:
        _addClassicPdf(pdf, resume);
        break;

      case 1:
        _addModernPdf(pdf, resume);
        break;

      case 2:
        _addProfessionalPdf(pdf, resume);
        break;

      case 3:
        _addMinimalPdf(pdf, resume);
        break;

      default:
        _addClassicPdf(pdf, resume);
    }

    return pdf.save();
  }

  // ============================================================
  // CLASSIC PDF
  // ============================================================

  void _addClassicPdf(
    pw.Document pdf,
    Resume resume,
  ) {
    final personal = resume.personalInfo;

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (context) => [
          _classicPdfHeader(personal),
          _pdfContact(personal),

          if (personal.summary.isNotEmpty) ...[
            _pdfSectionTitle('SUMMARY'),
            pw.Text(
              personal.summary,
              style: const pw.TextStyle(
                fontSize: 10,
                lineSpacing: 2,
              ),
            ),
          ],

          _pdfEducation(resume),
          _pdfExperience(resume),
          _pdfProjects(resume),
          _pdfSkills(resume),
          _pdfCertifications(resume),
        ],
      ),
    );
  }

  // ============================================================
  // MODERN PDF
  // ============================================================

  void _addModernPdf(
    pw.Document pdf,
    Resume resume,
  ) {
    final personal = resume.personalInfo;

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(35),
        build: (context) => [
          _modernPdfHeader(personal),
          _pdfContact(personal),

          if (personal.summary.isNotEmpty) ...[
            _pdfSectionTitle('PROFILE'),
            pw.Text(
              personal.summary,
              style: const pw.TextStyle(
                fontSize: 10,
                lineSpacing: 2,
              ),
            ),
          ],

          _pdfEducation(resume),
          _pdfExperience(resume),
          _pdfProjects(resume),
          _pdfSkills(resume),
          _pdfCertifications(resume),
        ],
      ),
    );
  }

  // ============================================================
  // PROFESSIONAL PDF
  // ============================================================

  void _addProfessionalPdf(
    pw.Document pdf,
    Resume resume,
  ) {
    final personal = resume.personalInfo;

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(35),
        build: (context) => [
          _professionalPdfHeader(personal),
          _pdfContact(personal),

          if (personal.summary.isNotEmpty) ...[
            _pdfSectionTitle(
              'PROFESSIONAL SUMMARY',
            ),
            pw.Text(
              personal.summary,
              style: const pw.TextStyle(
                fontSize: 10,
                lineSpacing: 2,
              ),
            ),
          ],

          _pdfExperience(resume),
          _pdfEducation(resume),
          _pdfProjects(resume),
          _pdfSkills(resume),
          _pdfCertifications(resume),
        ],
      ),
    );
  }

  // ============================================================
  // MINIMAL PDF
  // ============================================================

  void _addMinimalPdf(
    pw.Document pdf,
    Resume resume,
  ) {
    final personal = resume.personalInfo;

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(45),
        build: (context) => [
          _minimalPdfHeader(personal),
          _pdfContact(personal),

          if (personal.summary.isNotEmpty) ...[
            _pdfSectionTitle('ABOUT'),
            pw.Text(
              personal.summary,
              style: const pw.TextStyle(
                fontSize: 10,
                lineSpacing: 2,
              ),
            ),
          ],

          _pdfEducation(resume),
          _pdfExperience(resume),
          _pdfProjects(resume),
          _pdfSkills(resume),
          _pdfCertifications(resume),
        ],
      ),
    );
  }

  // ============================================================
  // PDF HEADERS
  // ============================================================

  pw.Widget _classicPdfHeader(
    PersonalInfo personal,
  ) {
    return pw.Column(
      crossAxisAlignment:
          pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          personal.name.isEmpty
              ? 'Your Name'
              : personal.name,
          style: const pw.TextStyle(
            fontSize: 26,
            fontWeight: pw.FontWeight.bold,
          ),
        ),

        if (personal.jobTitle.isNotEmpty)
          pw.Padding(
            padding: const pw.EdgeInsets.only(
              top: 5,
            ),
            child: pw.Text(
              personal.jobTitle,
              style: const pw.TextStyle(
                fontSize: 12,
                color: PdfColors.grey700,
              ),
            ),
          ),

        pw.SizedBox(height: 8),
        pw.Divider(),
      ],
    );
  }

  pw.Widget _modernPdfHeader(
    PersonalInfo personal,
  ) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(20),
      decoration: pw.BoxDecoration(
        color: PdfColors.blue700,
        borderRadius: pw.BorderRadius.circular(6),
      ),
      child: pw.Column(
        crossAxisAlignment:
            pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            personal.name.isEmpty
                ? 'Your Name'
                : personal.name,
            style: const pw.TextStyle(
              color: PdfColors.white,
              fontSize: 25,
              fontWeight: pw.FontWeight.bold,
            ),
          ),

          if (personal.jobTitle.isNotEmpty)
            pw.Padding(
              padding: const pw.EdgeInsets.only(
                top: 5,
              ),
              child: pw.Text(
                personal.jobTitle,
                style: const pw.TextStyle(
                  color: PdfColors.white,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }

  pw.Widget _professionalPdfHeader(
    PersonalInfo personal,
  ) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(20),
      color: PdfColors.indigo900,
      child: pw.Column(
        crossAxisAlignment:
            pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            personal.name.isEmpty
                ? 'YOUR NAME'
                : personal.name.toUpperCase(),
            style: const pw.TextStyle(
              color: PdfColors.white,
              fontSize: 23,
              fontWeight: pw.FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),

          if (personal.jobTitle.isNotEmpty)
            pw.Padding(
              padding: const pw.EdgeInsets.only(
                top: 5,
              ),
              child: pw.Text(
                personal.jobTitle,
                style: const pw.TextStyle(
                  color: PdfColors.white,
                  fontSize: 11,
                ),
              ),
            ),
        ],
      ),
    );
  }

  pw.Widget _minimalPdfHeader(
    PersonalInfo personal,
  ) {
    return pw.Column(
      crossAxisAlignment:
          pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          personal.name.isEmpty
              ? 'Your Name'
              : personal.name,
          style: const pw.TextStyle(
            fontSize: 28,
            fontWeight: pw.FontWeight.normal,
          ),
        ),

        if (personal.jobTitle.isNotEmpty)
          pw.Padding(
            padding: const pw.EdgeInsets.only(
              top: 5,
            ),
            child: pw.Text(
              personal.jobTitle,
              style: const pw.TextStyle(
                fontSize: 11,
                color: PdfColors.grey700,
              ),
            ),
          ),

        pw.SizedBox(height: 8),

        pw.Container(
          width: 45,
          height: 1,
          color: PdfColors.black,
        ),
      ],
    );
  }

  // ============================================================
  // PDF CONTACT
  // ============================================================

  pw.Widget _pdfContact(
    PersonalInfo personal,
  ) {
    final List<String> contacts = [];

    if (personal.email.isNotEmpty) {
      contacts.add(personal.email);
    }

    if (personal.phone.isNotEmpty) {
      contacts.add(personal.phone);
    }

    if (personal.location.isNotEmpty) {
      contacts.add(personal.location);
    }

    if (personal.linkedin.isNotEmpty) {
      contacts.add(personal.linkedin);
    }

    if (personal.github.isNotEmpty) {
      contacts.add(personal.github);
    }

    if (personal.website.isNotEmpty) {
      contacts.add(personal.website);
    }

    if (contacts.isEmpty) {
      return pw.SizedBox();
    }

    return pw.Padding(
      padding: const pw.EdgeInsets.only(
        top: 10,
      ),
      child: pw.Wrap(
        spacing: 10,
        runSpacing: 5,
        children: contacts
            .map(
              (contact) => pw.Text(
                contact,
                style: const pw.TextStyle(
                  fontSize: 8,
                  color: PdfColors.grey700,
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  // ============================================================
  // PDF SECTION TITLE
  // ============================================================

  pw.Widget _pdfSectionTitle(
    String title,
  ) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(
        top: 18,
        bottom: 7,
      ),
      child: pw.Column(
        crossAxisAlignment:
            pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            title,
            style: const pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
            ),
          ),

          pw.Container(
            margin: const pw.EdgeInsets.only(
              top: 3,
            ),
            width: 35,
            height: 1.5,
            color: PdfColors.black,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PDF EDUCATION
  // ============================================================

  pw.Widget _pdfEducation(
    Resume resume,
  ) {
    if (resume.education.isEmpty) {
      return pw.SizedBox();
    }

    return pw.Column(
      crossAxisAlignment:
          pw.CrossAxisAlignment.start,
      children: [
        _pdfSectionTitle('EDUCATION'),

        ...resume.education.map(
          (education) => pw.Padding(
            padding: const pw.EdgeInsets.only(
              bottom: 10,
            ),
            child: pw.Column(
              crossAxisAlignment:
                  pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  education.degree,
                  style: const pw.TextStyle(
                    fontSize: 10,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),

                pw.SizedBox(height: 2),

                pw.Text(
                  education.institution,
                  style: const pw.TextStyle(
                    fontSize: 9,
                  ),
                ),

                if (education.location.isNotEmpty)
                  pw.Text(
                    education.location,
                    style: const pw.TextStyle(
                      fontSize: 8,
                      color: PdfColors.grey700,
                    ),
                  ),

                if (education.startYear.isNotEmpty ||
                    education.endYear.isNotEmpty)
                  pw.Text(
                    _dateRange(
                      education.startYear,
                      education.endYear,
                    ),
                    style: const pw.TextStyle(
                      fontSize: 8,
                      color: PdfColors.grey700,
                    ),
                  ),

                if (education.grade.isNotEmpty)
                  pw.Text(
                    education.grade,
                    style: const pw.TextStyle(
                      fontSize: 8,
                      fontWeight:
                          pw.FontWeight.bold,
                    ),
                  ),

                if (education.description.isNotEmpty)
                  pw.Padding(
                    padding:
                        const pw.EdgeInsets.only(
                      top: 3,
                    ),
                    child: pw.Text(
                      education.description,
                      style: const pw.TextStyle(
                        fontSize: 8,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // PDF EXPERIENCE
  // ============================================================

  pw.Widget _pdfExperience(
    Resume resume,
  ) {
    if (resume.experience.isEmpty) {
      return pw.SizedBox();
    }

    return pw.Column(
      crossAxisAlignment:
          pw.CrossAxisAlignment.start,
      children: [
        _pdfSectionTitle('EXPERIENCE'),

        ...resume.experience.map(
          (experience) => pw.Padding(
            padding: const pw.EdgeInsets.only(
              bottom: 10,
            ),
            child: pw.Column(
              crossAxisAlignment:
                  pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  experience.jobTitle,
                  style: const pw.TextStyle(
                    fontSize: 10,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),

                pw.SizedBox(height: 2),

                pw.Text(
                  experience.company,
                  style: const pw.TextStyle(
                    fontSize: 9,
                  ),
                ),

                if (experience.location.isNotEmpty)
                  pw.Text(
                    experience.location,
                    style: const pw.TextStyle(
                      fontSize: 8,
                      color: PdfColors.grey700,
                    ),
                  ),

                pw.Text(
                  experience.isCurrent
                      ? '${experience.startDate} - Present'
                      : _dateRange(
                          experience.startDate,
                          experience.endDate,
                        ),
                  style: const pw.TextStyle(
                    fontSize: 8,
                    color: PdfColors.grey700,
                  ),
                ),

                if (experience.description.isNotEmpty)
                  pw.Padding(
                    padding:
                        const pw.EdgeInsets.only(
                      top: 3,
                    ),
                    child: pw.Text(
                      experience.description,
                      style: const pw.TextStyle(
                        fontSize: 8,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // PDF PROJECTS
  // ============================================================

  pw.Widget _pdfProjects(
    Resume resume,
  ) {
    if (resume.projects.isEmpty) {
      return pw.SizedBox();
    }

    return pw.Column(
      crossAxisAlignment:
          pw.CrossAxisAlignment.start,
      children: [
        _pdfSectionTitle('PROJECTS'),

        ...resume.projects.map(
          (project) => pw.Padding(
            padding: const pw.EdgeInsets.only(
              bottom: 10,
            ),
            child: pw.Column(
              crossAxisAlignment:
                  pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  project.name,
                  style: const pw.TextStyle(
                    fontSize: 10,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),

                if (project.technologies.isNotEmpty)
                  pw.Padding(
                    padding:
                        const pw.EdgeInsets.only(
                      top: 2,
                    ),
                    child: pw.Text(
                      project.technologies,
                      style: const pw.TextStyle(
                        fontSize: 8,
                        fontWeight:
                            pw.FontWeight.bold,
                      ),
                    ),
                  ),

                if (project.description.isNotEmpty)
                  pw.Padding(
                    padding:
                        const pw.EdgeInsets.only(
                      top: 3,
                    ),
                    child: pw.Text(
                      project.description,
                      style: const pw.TextStyle(
                        fontSize: 8,
                      ),
                    ),
                  ),

                if (project.githubUrl.isNotEmpty)
                  pw.Text(
                    'GitHub: ${project.githubUrl}',
                    style: const pw.TextStyle(
                      fontSize: 7,
                    ),
                  ),

                if (project.liveUrl.isNotEmpty)
                  pw.Text(
                    'Live Demo: ${project.liveUrl}',
                    style: const pw.TextStyle(
                      fontSize: 7,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // PDF SKILLS
  // ============================================================

  pw.Widget _pdfSkills(
    Resume resume,
  ) {
    if (resume.skills.isEmpty) {
      return pw.SizedBox();
    }

    return pw.Column(
      crossAxisAlignment:
          pw.CrossAxisAlignment.start,
      children: [
        _pdfSectionTitle('SKILLS'),

        pw.Wrap(
          spacing: 6,
          runSpacing: 5,
          children: resume.skills
              .map(
                (skill) => pw.Container(
                  padding:
                      const pw.EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 4,
                  ),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.grey200,
                    borderRadius:
                        pw.BorderRadius.circular(3),
                  ),
                  child: pw.Text(
                    skill,
                    style: const pw.TextStyle(
                      fontSize: 8,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  // ============================================================
  // PDF CERTIFICATIONS
  // ============================================================

  pw.Widget _pdfCertifications(
    Resume resume,
  ) {
    if (resume.certifications.isEmpty) {
      return pw.SizedBox();
    }

    return pw.Column(
      crossAxisAlignment:
          pw.CrossAxisAlignment.start,
      children: [
        _pdfSectionTitle('CERTIFICATIONS'),

        ...resume.certifications.map(
          (certification) => pw.Padding(
            padding: const pw.EdgeInsets.only(
              bottom: 8,
            ),
            child: pw.Column(
              crossAxisAlignment:
                  pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  certification.name,
                  style: const pw.TextStyle(
                    fontSize: 9,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),

                if (certification
                    .organization.isNotEmpty)
                  pw.Text(
                    certification.organization,
                    style: const pw.TextStyle(
                      fontSize: 8,
                    ),
                  ),

                if (certification.date.isNotEmpty)
                  pw.Text(
                    certification.date,
                    style: const pw.TextStyle(
                      fontSize: 8,
                      color: PdfColors.grey700,
                    ),
                  ),

                if (certification
                    .credentialId.isNotEmpty)
                  pw.Text(
                    'Credential ID: ${certification.credentialId}',
                    style: const pw.TextStyle(
                      fontSize: 7,
                    ),
                  ),

                if (certification.url.isNotEmpty)
                  pw.Text(
                    certification.url,
                    style: const pw.TextStyle(
                      fontSize: 7,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}