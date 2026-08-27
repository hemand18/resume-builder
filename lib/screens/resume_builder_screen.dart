import 'package:flutter/material.dart';

import '../models/resume_controller.dart';
import 'personal_info_screen.dart';
import 'experience_screen.dart';
import 'education_screen.dart';
import 'skills_screen.dart';
import 'projects_screen.dart';
import 'certifications_screen.dart';
import 'template_screen.dart';

class ResumeBuilderScreen extends StatelessWidget {
  const ResumeBuilderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final resume = ResumeController.instance.resume;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Resume Builder',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Build Your Resume',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Complete each section and preview your resume.',
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),

          const SizedBox(height: 25),

          _buildSection(
            context,
            icon: Icons.person_outline,
            title: 'Personal Information',
            subtitle: resume.personalInfo.name.isEmpty
                ? 'Add your name, contact details and summary'
                : resume.personalInfo.name,
            screen: const PersonalInfoScreen(),
          ),

          _buildSection(
            context,
            icon: Icons.work_outline,
            title: 'Experience',
            subtitle: resume.experience.isEmpty
                ? 'Add your work experience'
                : '${resume.experience.length} experience(s)',
            screen: const ExperienceScreen(),
          ),

          _buildSection(
            context,
            icon: Icons.school_outlined,
            title: 'Education',
            subtitle: resume.education.isEmpty
                ? 'Add your education'
                : '${resume.education.length} education record(s)',
            screen: const EducationScreen(),
          ),

          _buildSection(
            context,
            icon: Icons.code,
            title: 'Skills',
            subtitle: resume.skills.isEmpty
                ? 'Add your technical and professional skills'
                : '${resume.skills.length} skill(s)',
            screen: const SkillsScreen(),
          ),

          _buildSection(
            context,
            icon: Icons.folder_outlined,
            title: 'Projects',
            subtitle: resume.projects.isEmpty
                ? 'Add your projects'
                : '${resume.projects.length} project(s)',
            screen: const ProjectsScreen(),
          ),

          _buildSection(
            context,
            icon: Icons.verified_outlined,
            title: 'Certifications',
            subtitle: resume.certifications.isEmpty
                ? 'Add your certifications'
                : '${resume.certifications.length} certification(s)',
            screen: const CertificationsScreen(),
          ),

          const SizedBox(height: 20),

          SizedBox(
            height: 55,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const TemplateScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.preview_outlined),
              label: const Text(
                'Choose Template & Preview',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget screen,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          child: Icon(icon),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(subtitle),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 18,
        ),
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => screen,
            ),
          );

          (context as Element).markNeedsBuild();
        },
      ),
    );
  }
}