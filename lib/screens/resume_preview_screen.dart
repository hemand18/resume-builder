import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../controllers/resume_controller.dart';
import '../models/resume.dart';

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
        iconTheme: const IconThemeData(color: textColor),
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
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 850),
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
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
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
              icon: const Icon(Icons.picture_as_pdf_outlined),
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

  Widget _buildPreviewHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.description_outlined,
              color: primaryColor,
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your resume is ready',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Review your details before exporting to PDF.',
                  style: TextStyle(
                    fontSize: 13,
                    color: secondaryTextColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

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
    Widget _classicTemplate(Resume resume) {
    final personal = resume.personalInfo;

    return _resumeContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            personal.name.isEmpty ? 'Your Name' : personal.name,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  personal.name.isEmpty ? 'Your Name' : personal.name,
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
              crossAxisAlignment: CrossAxisAlignment.start,
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
            personal.name.isEmpty ? 'Your Name' : personal.name,
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
  // CONTACT INFORMATION
  // ============================================================

  Widget _contactInfo(PersonalInfo personal) {
    final items = <Widget>[];

    if (personal.email.isNotEmpty) {
      items.add(
        _contactItem(
          icon: Icons.email_outlined,
          text: personal.email,
        ),
      );
    }

    if (personal.phone.isNotEmpty) {
      items.add(
        _contactItem(
          icon: Icons.phone_outlined,
          text: personal.phone,
        ),
      );
    }

    if (personal.location.isNotEmpty) {
      items.add(
        _contactItem(
          icon: Icons.location_on_outlined,
          text: personal.location,
        ),
      );
    }

    if (personal.linkedin.isNotEmpty) {
      items.add(
        _contactItem(
          icon: Icons.link,
          text: personal.linkedin,
        ),
      );
    }

    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Wrap(
      spacing: 16,
      runSpacing: 10,
      children: items,
    );
  }

  Widget _contactItem({
    required IconData icon,
    required String text,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 15,
          color: secondaryTextColor,
        ),
        const SizedBox(width: 5),
        Flexible(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 11,
              color: secondaryTextColor,
            ),
          ),
        ),
      ],
    );
  }
    // ============================================================
  // SECTION HEADING
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
            padding: const EdgeInsets.only(bottom: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      education.grade,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                if (education.description.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      education.description,
                      style: const TextStyle(height: 1.4),
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
            padding: const EdgeInsets.only(bottom: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                  _experienceDateRange(
                    start: experience.startDate,
                    end: experience.endDate,
                    isCurrent: experience.isCurrent,
                  ),
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                ),
                if (experience.description.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      experience.description,
                      style: const TextStyle(height: 1.4),
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
            padding: const EdgeInsets.only(bottom: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                    padding: const EdgeInsets.only(top: 3),
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
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      project.description,
                      style: const TextStyle(height: 1.4),
                    ),
                  ),
                if (project.githubUrl.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
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
                    padding: const EdgeInsets.only(top: 2),
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
                  borderRadius: BorderRadius.circular(6),
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
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.workspace_premium_outlined,
                  size: 18,
                  color: Colors.indigo.shade700,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        certification.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (certification.organization.isNotEmpty)
                        Text(certification.organization),
                      if (certification.date.isNotEmpty)
                        Text(
                          certification.date,
                          style: TextStyle(
                            color: Colors.grey.shade700,
                          ),
                        ),
                      if (certification.credentialId.isNotEmpty)
                        Text(
                          'Credential ID: ${certification.credentialId}',
                          style: const TextStyle(fontSize: 11),
                        ),
                      if (certification.url.isNotEmpty)
                        Text(
                          certification.url,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.indigo.shade700,
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
  // DATE RANGE HELPERS
  // ============================================================

  String _dateRange(String start, String end) {
    final startDate = start.trim();
    final endDate = end.trim();

    if (startDate.isNotEmpty && endDate.isNotEmpty) {
      return '$startDate - $endDate';
    }

    if (startDate.isNotEmpty) {
      return startDate;
    }

    if (endDate.isNotEmpty) {
      return endDate;
    }

    return '';
  }

  String _experienceDateRange({
    required String start,
    required String end,
    required bool isCurrent,
  }) {
    final startDate = start.trim();
    final endDate = end.trim();

    if (isCurrent) {
      if (startDate.isEmpty) {
        return 'Present';
      }

      return '$startDate - Present';
    }

    return _dateRange(startDate, endDate);
  }
    // ============================================================
  // PRINT / PDF EXPORT
  // ============================================================

  Future<void> _printResume(Resume resume) async {
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async {
        return _generatePdf(resume);
      },
    );
  }

  Future<Uint8List> _generatePdf(Resume resume) async {
    final pdf = pw.Document();
    final personal = resume.personalInfo;

    final PdfColor accentColor;

    switch (templateIndex) {
      case 1:
        accentColor = PdfColors.blue700;
        break;
      case 2:
        accentColor = PdfColors.indigo900;
        break;
      case 3:
        accentColor = PdfColors.grey800;
        break;
      default:
        accentColor = PdfColors.indigo;
    }

    pw.Widget heading(String text) {
      return pw.Container(
        width: double.infinity,
        margin: const pw.EdgeInsets.only(top: 14, bottom: 7),
        padding: const pw.EdgeInsets.only(bottom: 5),
        decoration: pw.BoxDecoration(
          border: pw.Border(
            bottom: pw.BorderSide(
              color: accentColor,
              width: 1.2,
            ),
          ),
        ),
        child: pw.Text(
          text.toUpperCase(),
          style: pw.TextStyle(
            fontSize: 11,
            fontWeight: pw.FontWeight.bold,
            color: accentColor,
          ),
        ),
      );
    }

    pw.Widget bodyText(String text) {
      return pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 5),
        child: pw.Text(
          text,
          style: const pw.TextStyle(
            fontSize: 9,
            lineSpacing: 2,
          ),
        ),
      );
    }

    pw.Widget entryTitle(String text) {
      return pw.Padding(
        padding: const pw.EdgeInsets.only(top: 5, bottom: 3),
        child: pw.Text(
          text,
          style: const pw.TextStyle(
            fontSize: 10,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      );
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(38),
        build: (context) {
          final widgets = <pw.Widget>[];

          // Name and professional title.
          widgets.add(
            pw.Text(
              personal.name.isEmpty ? 'Your Name' : personal.name,
              style: pw.TextStyle(
                fontSize: 25,
                fontWeight: pw.FontWeight.bold,
                color: accentColor,
              ),
            ),
          );

          if (personal.jobTitle.isNotEmpty) {
            widgets.add(
              pw.Padding(
                padding: const pw.EdgeInsets.only(top: 4),
                child: pw.Text(
                  personal.jobTitle,
                  style: const pw.TextStyle(fontSize: 12),
                ),
              ),
            );
          }

          // Contact details.
          final contacts = <String>[
            if (personal.email.isNotEmpty) personal.email,
            if (personal.phone.isNotEmpty) personal.phone,
            if (personal.location.isNotEmpty) personal.location,
            if (personal.linkedin.isNotEmpty) personal.linkedin,
          ];

          if (contacts.isNotEmpty) {
            widgets.add(
              pw.Padding(
                padding: const pw.EdgeInsets.only(top: 10),
                child: pw.Text(
                  contacts.join('  |  '),
                  style: const pw.TextStyle(
                    fontSize: 8,
                    color: PdfColors.grey700,
                  ),
                ),
              ),
            );
          }

          // Summary.
          if (personal.summary.trim().isNotEmpty) {
            widgets.add(heading('Summary'));
            widgets.add(bodyText(personal.summary));
          }

          // Education.
          if (resume.education.isNotEmpty) {
            widgets.add(heading('Education'));

            for (final education in resume.education) {
              widgets.add(entryTitle(education.degree));

              if (education.institution.isNotEmpty) {
                widgets.add(bodyText(education.institution));
              }

              if (education.location.isNotEmpty) {
                widgets.add(bodyText(education.location));
              }

              final dates = _dateRange(
                education.startYear,
                education.endYear,
              );

              if (dates.isNotEmpty) {
                widgets.add(bodyText(dates));
              }

              if (education.grade.isNotEmpty) {
                widgets.add(bodyText(education.grade));
              }

              if (education.description.isNotEmpty) {
                widgets.add(bodyText(education.description));
              }
            }
          }

          // Experience.
          if (resume.experience.isNotEmpty) {
            widgets.add(heading('Experience'));

            for (final experience in resume.experience) {
              widgets.add(entryTitle(experience.jobTitle));

              if (experience.company.isNotEmpty) {
                widgets.add(bodyText(experience.company));
              }

              if (experience.location.isNotEmpty) {
                widgets.add(bodyText(experience.location));
              }

              final dates = _experienceDateRange(
                start: experience.startDate,
                end: experience.endDate,
                isCurrent: experience.isCurrent,
              );

              if (dates.isNotEmpty) {
                widgets.add(bodyText(dates));
              }

              if (experience.description.isNotEmpty) {
                widgets.add(bodyText(experience.description));
              }
            }
          }

          // Projects.
          if (resume.projects.isNotEmpty) {
            widgets.add(heading('Projects'));

            for (final project in resume.projects) {
              widgets.add(entryTitle(project.name));

              if (project.technologies.isNotEmpty) {
                widgets.add(bodyText(project.technologies));
              }

              if (project.description.isNotEmpty) {
                widgets.add(bodyText(project.description));
              }

              if (project.githubUrl.isNotEmpty) {
                widgets.add(bodyText('GitHub: ${project.githubUrl}'));
              }

              if (project.liveUrl.isNotEmpty) {
                widgets.add(bodyText('Live Demo: ${project.liveUrl}'));
              }
            }
          }

          // Skills.
          if (resume.skills.isNotEmpty) {
            widgets.add(heading('Skills'));
            widgets.add(bodyText(resume.skills.join('  •  ')));
          }

          // Certifications.
          if (resume.certifications.isNotEmpty) {
            widgets.add(heading('Certifications'));

            for (final certification in resume.certifications) {
              widgets.add(entryTitle(certification.name));

              if (certification.organization.isNotEmpty) {
                widgets.add(bodyText(certification.organization));
              }

              if (certification.date.isNotEmpty) {
                widgets.add(bodyText(certification.date));
              }

              if (certification.credentialId.isNotEmpty) {
                widgets.add(
                  bodyText(
                    'Credential ID: ${certification.credentialId}',
                  ),
                );
              }

              if (certification.url.isNotEmpty) {
                widgets.add(bodyText(certification.url));
              }
            }
          }

          return widgets;
        },
      ),
    );

    return pdf.save();
  }
}