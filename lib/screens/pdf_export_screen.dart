import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../controllers/resume_controller.dart';
import '../models/resume.dart';

class PdfExportScreen extends StatelessWidget {
  final int templateIndex;

  const PdfExportScreen({
    super.key,
    required this.templateIndex,
  });

  static const Color primaryColor = Color(0xFF4F46E5);
  static const Color backgroundColor = Color(0xFFF8F9FC);
  static const Color textColor = Color(0xFF111827);
  static const Color secondaryTextColor = Color(0xFF6B7280);

  String get templateName {
    const names = [
      'Classic',
      'Modern',
      'Professional',
      'Minimal',
    ];

    if (templateIndex >= 0 && templateIndex < names.length) {
      return names[templateIndex];
    }

    return 'Classic';
  }

  @override
  Widget build(BuildContext context) {
    final Resume resume = ResumeController.instance.resume;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        foregroundColor: textColor,
        title: const Text(
          'Export Resume',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildResumeInfo(resume),
            const SizedBox(height: 20),
            _buildActions(context, resume),
            const SizedBox(height: 20),
            _buildTips(),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.picture_as_pdf_outlined,
            color: Colors.white,
            size: 38,
          ),
          SizedBox(height: 14),
          Text(
            'Your resume is ready',
            style: TextStyle(
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Export your resume as a professional PDF.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // RESUME INFO
  // ============================================================

  Widget _buildResumeInfo(Resume resume) {
    final personal = resume.personalInfo;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.09),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.description_outlined,
                  color: primaryColor,
                  size: 27,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      personal.name.isEmpty ? 'Your Name' : personal.name,
                      style: const TextStyle(
                        color: textColor,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      personal.jobTitle.isEmpty ? 'Resume' : personal.jobTitle,
                      style: const TextStyle(
                        color: secondaryTextColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Divider(
            color: Colors.grey.shade200,
            height: 1,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _infoItem(
                  Icons.palette_outlined,
                  'Template',
                  templateName,
                ),
              ),
              Expanded(
                child: _infoItem(
                  Icons.description_outlined,
                  'Format',
                  'PDF',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoItem(
    IconData icon,
    String title,
    String value,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 19,
          color: primaryColor,
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: secondaryTextColor,
                  fontSize: 10,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: textColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // ACTIONS
  // ============================================================

  Widget _buildActions(
    BuildContext context,
    Resume resume,
  ) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton.icon(
            onPressed: () async {
              await _printResume(resume);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            icon: const Icon(
              Icons.download_outlined,
            ),
            label: const Text(
              'Download / Save PDF',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 54,
          child: OutlinedButton.icon(
            onPressed: () async {
              await _shareResume(resume);
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: primaryColor,
              side: const BorderSide(
                color: primaryColor,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            icon: const Icon(
              Icons.share_outlined,
            ),
            label: const Text(
              'Share Resume',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 54,
          child: OutlinedButton.icon(
            onPressed: () async {
              await _printResume(resume);
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: textColor,
              side: BorderSide(
                color: Colors.grey.shade300,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            icon: const Icon(
              Icons.print_outlined,
            ),
            label: const Text(
              'Print Resume',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // TIPS
  // ============================================================

  Widget _buildTips() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            color: primaryColor,
            size: 21,
          ),
          SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PDF Export Tips',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Use PDF when submitting your resume to recruiters, job portals, or companies to preserve the formatting.',
                  style: TextStyle(
                    fontSize: 11,
                    color: secondaryTextColor,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PRINT
  // ============================================================

  Future<void> _printResume(Resume resume) async {
    await Printing.layoutPdf(
      name: 'resume_${templateName.toLowerCase()}.pdf',
      onLayout: (PdfPageFormat format) async {
        return await _generatePdf(resume);
      },
    );
  }

  // ============================================================
  // SHARE
  // ============================================================

  Future<void> _shareResume(Resume resume) async {
    final pdfBytes = await _generatePdf(resume);

    await Printing.sharePdf(
      bytes: pdfBytes,
      filename: 'resume_${templateName.toLowerCase()}.pdf',
    );
  }

  // ============================================================
  // GENERATE PDF
  // ============================================================

  Future<Uint8List> _generatePdf(
    Resume resume,
  ) async {
    final pdf = pw.Document();

    final personal = resume.personalInfo;

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(35),
        build: (context) {
          return [
            _pdfHeader(personal),
            _pdfContact(personal),
            if (personal.summary.isNotEmpty) ...[
              _pdfSectionTitle(
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
                  lineSpacing: 2,
                ),
              ),
            ],
            _pdfEducation(resume),
            _pdfExperience(resume),
            _pdfProjects(resume),
            _pdfSkills(resume),
            _pdfCertifications(resume),
          ];
        },
      ),
    );

    return await pdf.save();
  }

  // ============================================================
  // PDF HEADER
  // ============================================================

  pw.Widget _pdfHeader(
    PersonalInfo personal,
  ) {
    if (templateIndex == 1) {
      return pw.Container(
        width: double.infinity,
        padding: const pw.EdgeInsets.all(18),
        decoration: pw.BoxDecoration(
          color: PdfColors.blue700,
          borderRadius: pw.BorderRadius.circular(6),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              personal.name.isEmpty ? 'Your Name' : personal.name,
              style: const pw.TextStyle(
                color: PdfColors.white,
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            if (personal.jobTitle.isNotEmpty)
              pw.Padding(
                padding: const pw.EdgeInsets.only(
                  top: 4,
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

    if (templateIndex == 2) {
      return pw.Container(
        width: double.infinity,
        padding: const pw.EdgeInsets.all(18),
        color: PdfColors.indigo900,
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              personal.name.isEmpty ? 'YOUR NAME' : personal.name.toUpperCase(),
              style: const pw.TextStyle(
                color: PdfColors.white,
                fontSize: 23,
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
                    fontSize: 11,
                  ),
                ),
              ),
          ],
        ),
      );
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          personal.name.isEmpty ? 'Your Name' : personal.name,
          style: pw.TextStyle(
            fontSize: templateIndex == 3 ? 27 : 25,
            fontWeight:
                templateIndex == 3 ? pw.FontWeight.normal : pw.FontWeight.bold,
          ),
        ),
        if (personal.jobTitle.isNotEmpty)
          pw.Padding(
            padding: const pw.EdgeInsets.only(
              top: 4,
            ),
            child: pw.Text(
              personal.jobTitle,
              style: const pw.TextStyle(
                fontSize: 12,
              ),
            ),
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
        crossAxisAlignment: pw.CrossAxisAlignment.start,
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
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _pdfSectionTitle('EDUCATION'),
        ...resume.education.map(
          (education) => pw.Padding(
            padding: const pw.EdgeInsets.only(
              bottom: 10,
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
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
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                if (education.description.isNotEmpty)
                  pw.Padding(
                    padding: const pw.EdgeInsets.only(
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
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _pdfSectionTitle('EXPERIENCE'),
        ...resume.experience.map(
          (experience) => pw.Padding(
            padding: const pw.EdgeInsets.only(
              bottom: 10,
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
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
                    padding: const pw.EdgeInsets.only(
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
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _pdfSectionTitle('PROJECTS'),
        ...resume.projects.map(
          (project) => pw.Padding(
            padding: const pw.EdgeInsets.only(
              bottom: 10,
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
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
                    padding: const pw.EdgeInsets.only(
                      top: 2,
                    ),
                    child: pw.Text(
                      project.technologies,
                      style: const pw.TextStyle(
                        fontSize: 8,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                if (project.description.isNotEmpty)
                  pw.Padding(
                    padding: const pw.EdgeInsets.only(
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
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _pdfSectionTitle('SKILLS'),
        pw.Wrap(
          spacing: 6,
          runSpacing: 5,
          children: resume.skills
              .map(
                (skill) => pw.Container(
                  padding: const pw.EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 4,
                  ),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.grey200,
                    borderRadius: pw.BorderRadius.circular(3),
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
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _pdfSectionTitle('CERTIFICATIONS'),
        ...resume.certifications.map(
          (certification) => pw.Padding(
            padding: const pw.EdgeInsets.only(
              bottom: 8,
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  certification.name,
                  style: const pw.TextStyle(
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
}
