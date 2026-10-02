import 'package:flutter/material.dart';

import '../controllers/resume_controller.dart';
import '../models/resume.dart';

import 'certifications_screen.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  List<Project> get projectsList =>
      ResumeController.instance.resume.projects;

  static const Color primaryColor = Color(0xFF4F46E5);
  static const Color backgroundColor = Color(0xFFF8FAFC);

  // ============================================================
  // ADD / EDIT PROJECT
  // ============================================================

  void showProjectForm({int? editIndex}) {
    final bool isEditing = editIndex != null;

    final Project? existingProject =
        isEditing ? projectsList[editIndex] : null;

    final nameController = TextEditingController(
      text: existingProject?.name ?? '',
    );

    final technologiesController = TextEditingController(
      text: existingProject?.technologies ?? '',
    );

    final descriptionController = TextEditingController(
      text: existingProject?.description ?? '',
    );

    final githubController = TextEditingController(
      text: existingProject?.githubUrl ?? '',
    );

    final liveUrlController = TextEditingController(
      text: existingProject?.liveUrl ?? '',
    );

    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(26),
        ),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 10,
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ==================================================
                  // DRAG HANDLE
                  // ==================================================

                  Center(
                    child: Container(
                      width: 42,
                      height: 4,
                      margin: const EdgeInsets.only(
                        bottom: 18,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  // ==================================================
                  // HEADER
                  // ==================================================

                  Row(
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.folder_outlined,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isEditing
                                  ? 'Edit Project'
                                  : 'Add Project',
                              style: const TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              isEditing
                                  ? 'Update your project details'
                                  : 'Showcase one of your best projects',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(sheetContext);
                        },
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ==================================================
                  // PROJECT NAME
                  // ==================================================

                  _buildTextField(
                    controller: nameController,
                    label: 'Project Name',
                    hint: 'e.g. Movie Recommendation System',
                    icon: Icons.folder_outlined,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter project name';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 15),

                  // ==================================================
                  // TECHNOLOGIES
                  // ==================================================

                  _buildTextField(
                    controller: technologiesController,
                    label: 'Technologies',
                    hint: 'e.g. Python, Flutter, MySQL',
                    icon: Icons.code_outlined,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter technologies';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 15),

                  // ==================================================
                  // DESCRIPTION
                  // ==================================================

                  _buildTextField(
                    controller: descriptionController,
                    label: 'Description',
                    hint:
                        'Describe your project, features and achievements.',
                    icon: Icons.description_outlined,
                    maxLines: 5,
                    alignLabelWithHint: true,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter project description';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 15),

                  // ==================================================
                  // GITHUB URL
                  // ==================================================

                  _buildTextField(
                    controller: githubController,
                    label: 'GitHub URL',
                    hint: 'https://github.com/username/project',
                    icon: Icons.code,
                    keyboardType: TextInputType.url,
                  ),

                  const SizedBox(height: 15),

                  // ==================================================
                  // LIVE URL
                  // ==================================================

                  _buildTextField(
                    controller: liveUrlController,
                    label: 'Live Demo URL',
                    hint: 'https://your-project.com',
                    icon: Icons.language_outlined,
                    keyboardType: TextInputType.url,
                  ),

                  const SizedBox(height: 25),

                  // ==================================================
                  // SAVE BUTTON
                  // ==================================================

                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: () {
                        if (!formKey.currentState!.validate()) {
                          return;
                        }

                        final Project newProject = Project(
                          name: nameController.text.trim(),
                          technologies:
                              technologiesController.text.trim(),
                          description:
                              descriptionController.text.trim(),
                          githubUrl: githubController.text.trim(),
                          liveUrl: liveUrlController.text.trim(),
                        );

                        setState(() {
                          if (isEditing) {
                            projectsList[editIndex] = newProject;
                          } else {
                            projectsList.add(newProject);
                          }
                        });

                        // Autosave after adding/updating a project.
                        ResumeController.instance.scheduleAutosave();

                        Navigator.pop(sheetContext);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isEditing ? Icons.check : Icons.add,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            isEditing
                                ? 'Update Project'
                                : 'Add Project',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // TEXT FIELD
  // ============================================================

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
    bool alignLabelWithHint = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        alignLabelWithHint: alignLabelWithHint,
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: primaryColor,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Colors.red,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // DELETE PROJECT
  // ============================================================

  void deleteProject(int index) {
    final projectName = projectsList[index].name;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Delete Project?',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to delete "$projectName"?',
            style: TextStyle(
              color: Colors.grey.shade700,
              height: 1.4,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                setState(() {
                  projectsList.removeAt(index);
                });

                // Autosave after deleting a project.
                ResumeController.instance.scheduleAutosave();

                Navigator.pop(dialogContext);
              },
              child: const Text(
                'Delete',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        titleSpacing: 20,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Projects',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Step 3 of 4',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // ======================================================
          // PROGRESS
          // ======================================================

          Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              4,
              20,
              12,
            ),
            child: Row(
              children: List.generate(
                4,
                (index) {
                  return Expanded(
                    child: Container(
                      margin: EdgeInsets.only(
                        right: index == 3 ? 0 : 6,
                      ),
                      height: 5,
                      decoration: BoxDecoration(
                        color: index <= 2
                            ? primaryColor
                            : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // ======================================================
          // PROJECT CONTENT
          // ======================================================

          Expanded(
            child: projectsList.isEmpty
                ? _buildEmptyState()
                : _buildProjectList(),
          ),

          // ======================================================
          // BOTTOM BUTTONS
          // ======================================================

          Container(
            padding: const EdgeInsets.fromLTRB(
              20,
              12,
              20,
              20,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 15,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton.icon(
                    onPressed: showProjectForm,
                    icon: const Icon(Icons.add),
                    label: const Text(
                      'Add Project',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: primaryColor,
                      side: const BorderSide(
                        color: primaryColor,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: projectsList.isEmpty
                        ? null
                        : () async {
                            // Save immediately before continuing.
                            await ResumeController.instance.saveNow();

                            if (!context.mounted) return;

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const CertificationsScreen(),
                              ),
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey.shade300,
                      disabledForegroundColor: Colors.grey.shade600,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Save & Continue',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward,
                          size: 20,
                        ),
                      ],
                    ),
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
  // EMPTY STATE
  // ============================================================

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.folder_outlined,
                size: 48,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Showcase your projects',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Add your best projects with technologies, '
              'descriptions and links to your work.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                height: 1.5,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: showProjectForm,
              icon: const Icon(Icons.add),
              label: const Text(
                'Add Your First Project',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // PROJECT LIST
  // ============================================================

  Widget _buildProjectList() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(
        20,
        10,
        20,
        20,
      ),
      itemCount: projectsList.length,
      itemBuilder: (context, index) {
        final Project project = projectsList[index];

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Colors.grey.shade200,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.035),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ==================================================
                // TOP ROW
                // ==================================================

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.folder_outlined,
                        color: primaryColor,
                        size: 26,
                      ),
                    ),

                    const SizedBox(width: 14),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            project.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 7),
                          Text(
                            project.technologies,
                            style: const TextStyle(
                              color: primaryColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    PopupMenuButton<String>(
                      padding: EdgeInsets.zero,
                      onSelected: (value) {
                        if (value == 'edit') {
                          showProjectForm(
                            editIndex: index,
                          );
                        } else if (value == 'delete') {
                          deleteProject(index);
                        }
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem<String>(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(
                                Icons.edit_outlined,
                              ),
                              SizedBox(width: 10),
                              Text('Edit'),
                            ],
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(
                                Icons.delete_outline,
                              ),
                              SizedBox(width: 10),
                              Text('Delete'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // ==================================================
                // DESCRIPTION
                // ==================================================

                Text(
                  project.description,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),

                // ==================================================
                // LINKS
                // ==================================================

                if (project.githubUrl.isNotEmpty ||
                    project.liveUrl.isNotEmpty) ...[
                  const SizedBox(height: 15),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (project.githubUrl.isNotEmpty)
                        _buildLinkChip(
                          icon: Icons.code,
                          label: 'GitHub',
                        ),
                      if (project.liveUrl.isNotEmpty)
                        _buildLinkChip(
                          icon: Icons.language,
                          label: 'Live Demo',
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // LINK CHIP
  // ============================================================

  Widget _buildLinkChip({
    required IconData icon,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(width: 1),
          Icon(
            icon,
            size: 17,
            color: primaryColor,
          ),
          const SizedBox(width: 7),
          Text(
            label,
            style: const TextStyle(
              color: primaryColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}