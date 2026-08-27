import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../models/resume.dart';

class PdfService {
  static Future<Uint8List> generateResumePdf(
    Resume resume,
    int templateIndex,
  ) async {
    final pdf = pw.Document();

    final personal = resume.personalInfo;

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(35),
        build: (context) {
          return [
            _buildHeader(
              personal,
              templateIndex,
            ),

            if (personal.summary.isNotEmpty) ...[
              _sectionTitle(
                templateIndex == 1
                    ? 'PROFILE'
                    : templateIndex == 2
                        ? 'PROFESSIONAL SUMMARY'
                        : templateIndex == 3
                            ? 'ABOUT'
                            : 'SUMMARY',
              ),
              pw.Text(
                personal.summary,
                style: const pw.TextStyle(
                  fontSize: 10,
                ),
              ),
            ],

            _educationSection(resume),

            _experienceSection(resume),

            _projectsSection(resume),

            _skillsSection(resume),

            _certificationsSection(resume),
          ];
        },
      ),
    );

    return pdf.save();
  }

  // ============================================================
  // HEADER
  // ============================================================

  static pw.Widget _buildHeader(
    PersonalInfo personal,
    int templateIndex,
  ) {
    final name = personal.name.isEmpty
        ? 'Your Name'
        : personal.name;

    final jobTitle = personal.jobTitle;

    final contact = <String>[];

    if (personal.email.isNotEmpty) {
      contact.add(personal.email);
    }

    if (personal.phone.isNotEmpty) {
      contact.add(personal.phone);
    }

    if (personal.location.isNotEmpty) {
      contact.add(personal.location);
    }

    if (personal.linkedin.isNotEmpty) {
      contact.add(personal.linkedin);
    }

    if (personal.github.isNotEmpty) {
      contact.add(personal.github);
    }

    if (personal.website.isNotEmpty) {
      contact.add(personal.website);
    }

    if (templateIndex == 1) {
      return pw.Column(
        crossAxisAlignment:
            pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.all(18),
            decoration: pw.BoxDecoration(
              color: PdfColors.blue700,
              borderRadius:
                  pw.BorderRadius.circular(6),
            ),
            child: pw.Column(
              crossAxisAlignment:
                  pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  name,
                  style: pw.TextStyle(
                    color: PdfColors.white,
                    fontSize: 25,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                if (jobTitle.isNotEmpty)
                  pw.Padding(
                    padding:
                        const pw.EdgeInsets.only(top: 5),
                    child: pw.Text(
                      jobTitle,
                      style: const pw.TextStyle(
                        color: PdfColors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (contact.isNotEmpty)
            _contactText(contact),
          pw.SizedBox(height: 5),
        ],
      );
    }

    if (templateIndex == 2) {
      return pw.Column(
        crossAxisAlignment:
            pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.all(20),
            color: PdfColors.indigo900,
            child: pw.Column(
              crossAxisAlignment:
                  pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  name.toUpperCase(),
                  style: pw.TextStyle(
                    color: PdfColors.white,
                    fontSize: 23,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                if (jobTitle.isNotEmpty)
                  pw.Padding(
                    padding:
                        const pw.EdgeInsets.only(top: 5),
                    child: pw.Text(
                      jobTitle,
                      style: const pw.TextStyle(
                        color: PdfColors.white,
                        fontSize: 11,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (contact.isNotEmpty)
            _contactText(contact),
          pw.SizedBox(height: 5),
        ],
      );
    }

    if (templateIndex == 3) {
      return pw.Column(
        crossAxisAlignment:
            pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            name,
            style: pw.TextStyle(
              fontSize: 27,
              fontWeight: pw.FontWeight.normal,
            ),
          ),
          if (jobTitle.isNotEmpty)
            pw.Padding(
              padding:
                  const pw.EdgeInsets.only(top: 4),
              child: pw.Text(
                jobTitle,
                style: const pw.TextStyle(
                  fontSize: 12,
                  color: PdfColors.grey700,
                ),
              ),
            ),
          if (contact.isNotEmpty)
            _contactText(contact),
          pw.SizedBox(height: 5),
        ],
      );
    }

    // CLASSIC
    return pw.Column(
      crossAxisAlignment:
          pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          name,
          style: pw.TextStyle(
            fontSize: 26,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        if (jobTitle.isNotEmpty)
          pw.Padding(
            padding:
                const pw.EdgeInsets.only(top: 4),
            child: pw.Text(
              jobTitle,
              style: const pw.TextStyle(
                fontSize: 13,
              ),
            ),
          ),
        if (contact.isNotEmpty)
          _contactText(contact),
        pw.SizedBox(height: 5),
      ],
    );
  }

  // ============================================================
  // CONTACT
  // ============================================================

  static pw.Widget _contactText(
    List<String> contact,
  ) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(
        top: 8,
        bottom: 8,
      ),
      child: pw.Text(
        contact.join('  |  '),
        style: const pw.TextStyle(
          fontSize: 8,
          color: PdfColors.grey700,
        ),
      ),
    );
  }

  // ============================================================
  // SECTION TITLE
  // ============================================================

  static pw.Widget _sectionTitle(
    String title,
  ) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(
        top: 15,
        bottom: 7,
      ),
      child: pw.Text(
        title,
        style: pw.TextStyle(
          fontSize: 12,
          fontWeight: pw.FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }

  // ============================================================
  // EDUCATION
  // ============================================================

  static pw.Widget _educationSection(
    Resume resume,
  ) {
    if (resume.education.isEmpty) {
      return pw.SizedBox();
    }

    return pw.Column(
      crossAxisAlignment:
          pw.CrossAxisAlignment.start,
      children: [
        _sectionTitle('EDUCATION'),

        ...resume.education.map(
          (education) {
            final date = _dateRange(
              education.startYear,
              education.endYear,
            );

            return pw.Padding(
              padding: const pw.EdgeInsets.only(
                bottom: 10,
              ),
              child: pw.Column(
                crossAxisAlignment:
                    pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    education.degree,
                    style: pw.TextStyle(
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),

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

                  if (date.isNotEmpty)
                    pw.Text(
                      date,
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
                      ),
                    ),

                  if (education.description.isNotEmpty)
                    pw.Padding(
                      padding:
                          const pw.EdgeInsets.only(top: 3),
                      child: pw.Text(
                        education.description,
                        style: const pw.TextStyle(
                          fontSize: 8,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  // ============================================================
  // EXPERIENCE
  // ============================================================

  static pw.Widget _experienceSection(
    Resume resume,
  ) {
    if (resume.experience.isEmpty) {
      return pw.SizedBox();
    }

    return pw.Column(
      crossAxisAlignment:
          pw.CrossAxisAlignment.start,
      children: [
        _sectionTitle('EXPERIENCE'),

        ...resume.experience.map(
          (experience) {
            final date = experience.isCurrent
                ? '${experience.startDate} - Present'
                : _dateRange(
                    experience.startDate,
                    experience.endDate,
                  );

            return pw.Padding(
              padding: const pw.EdgeInsets.only(
                bottom: 10,
              ),
              child: pw.Column(
                crossAxisAlignment:
                    pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    experience.jobTitle,
                    style: pw.TextStyle(
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),

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

                  if (date.isNotEmpty)
                    pw.Text(
                      date,
                      style: const pw.TextStyle(
                        fontSize: 8,
                        color: PdfColors.grey700,
                      ),
                    ),

                  if (experience.description.isNotEmpty)
                    pw.Padding(
                      padding:
                          const pw.EdgeInsets.only(top: 3),
                      child: pw.Text(
                        experience.description,
                        style: const pw.TextStyle(
                          fontSize: 8,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  // ============================================================
  // PROJECTS
  // ============================================================

  static pw.Widget _projectsSection(
    Resume resume,
  ) {
    if (resume.projects.isEmpty) {
      return pw.SizedBox();
    }

    return pw.Column(
      crossAxisAlignment:
          pw.CrossAxisAlignment.start,
      children: [
        _sectionTitle('PROJECTS'),

        ...resume.projects.map(
          (project) {
            return pw.Padding(
              padding: const pw.EdgeInsets.only(
                bottom: 10,
              ),
              child: pw.Column(
                crossAxisAlignment:
                    pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    project.name,
                    style: pw.TextStyle(
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),

                  if (project.technologies.isNotEmpty)
                    pw.Text(
                      project.technologies,
                      style: pw.TextStyle(
                        fontSize: 8,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),

                  if (project.description.isNotEmpty)
                    pw.Padding(
                      padding:
                          const pw.EdgeInsets.only(top: 3),
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
                        color: PdfColors.grey700,
                      ),
                    ),

                  if (project.liveUrl.isNotEmpty)
                    pw.Text(
                      'Live: ${project.liveUrl}',
                      style: const pw.TextStyle(
                        fontSize: 7,
                        color: PdfColors.grey700,
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  // ============================================================
  // SKILLS
  // ============================================================

  static pw.Widget _skillsSection(
    Resume resume,
  ) {
    if (resume.skills.isEmpty) {
      return pw.SizedBox();
    }

    return pw.Column(
      crossAxisAlignment:
          pw.CrossAxisAlignment.start,
      children: [
        _sectionTitle('SKILLS'),

        pw.Wrap(
          spacing: 5,
          runSpacing: 5,
          children: resume.skills.map(
            (skill) {
              return pw.Container(
                padding: const pw.EdgeInsets.symmetric(
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

  static pw.Widget _certificationsSection(
    Resume resume,
  ) {
    if (resume.certifications.isEmpty) {
      return pw.SizedBox();
    }

    return pw.Column(
      crossAxisAlignment:
          pw.CrossAxisAlignment.start,
      children: [
        _sectionTitle('CERTIFICATIONS'),

        ...resume.certifications.map(
          (certification) {
            return pw.Padding(
              padding: const pw.EdgeInsets.only(
                bottom: 8,
              ),
              child: pw.Column(
                crossAxisAlignment:
                    pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    certification.name,
                    style: pw.TextStyle(
                      fontSize: 9,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),

                  if (certification.organization.isNotEmpty)
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

                  if (certification.credentialId.isNotEmpty)
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
                        color: PdfColors.grey700,
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  // ============================================================
  // DATE RANGE
  // ============================================================

  static String _dateRange(
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
}