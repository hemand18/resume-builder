import 'package:flutter/material.dart';

import '../models/resume.dart';
import '../models/resume_controller.dart';
import 'skills_screen.dart';

class ExperienceScreen extends StatefulWidget {
  const ExperienceScreen({super.key});

  @override
  State<ExperienceScreen> createState() => _ExperienceScreenState();
}

class _ExperienceScreenState extends State<ExperienceScreen> {
  Resume get resume => ResumeController.instance.resume;

  List<Experience> get experienceList => resume.experience;

  // ============================================================
  // COLORS
  // ============================================================

  static const Color primaryColor = Color(0xFF4F46E5);
  static const Color backgroundColor = Color(0xFFF8FAFC);
  static const Color cardColor = Colors.white;

  // ============================================================
  // ADD / EDIT EXPERIENCE
  // ============================================================

  void showExperienceForm({int? editIndex}) {
    final bool isEditing = editIndex != null;

    final Experience? existingExperience =
        isEditing ? experienceList[editIndex] : null;

    final jobTitleController = TextEditingController(
      text: existingExperience?.jobTitle ?? '',
    );

    final companyController = TextEditingController(
      text: existingExperience?.company ?? '',
    );

    final locationController = TextEditingController(
      text: existingExperience?.location ?? '',
    );

    final startDateController = TextEditingController(
      text: existingExperience?.startDate ?? '',
    );

    final endDateController = TextEditingController(
      text: existingExperience?.endDate ?? '',
    );

    final descriptionController = TextEditingController(
      text: existingExperience?.description ?? '',
    );

    bool isCurrent = existingExperience?.isCurrent ?? false;

    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 12,
                    bottom:
                        MediaQuery.of(context).viewInsets.bottom + 20,
                  ),
                  child: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // TOP HANDLE
                          Center(
                            child: Container(
                              width: 45,
                              height: 5,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),

                          const SizedBox(height: 18),

                          // HEADER
                          Row(
                            children: [
                              Container(
                                width: 45,
                                height: 45,
                                decoration: BoxDecoration(
                                  color: primaryColor.withValues(alpha: 0.1),
                                  borderRadius:
                                      BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.work_outline,
                                  color: primaryColor,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  isEditing
                                      ? 'Edit Experience'
                                      : 'Add Experience',
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.pop(sheetContext);
                                },
                                style: IconButton.styleFrom(
                                  backgroundColor:
                                      Colors.grey.shade100,
                                ),
                                icon: const Icon(Icons.close),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // JOB TITLE
                          _buildTextField(
                            controller: jobTitleController,
                            label: 'Job Title',
                            hint: 'e.g. Flutter Developer Intern',
                            icon: Icons.work_outline,
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty) {
                                return 'Please enter a job title';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 16),

                          // COMPANY
                          _buildTextField(
                            controller: companyController,
                            label: 'Company',
                            hint: 'e.g. ABC Technologies',
                            icon: Icons.business_outlined,
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty) {
                                return 'Please enter the company';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 16),

                          // LOCATION
                          _buildTextField(
                            controller: locationController,
                            label: 'Location',
                            hint: 'e.g. Chennai, India',
                            icon: Icons.location_on_outlined,
                          ),

                          const SizedBox(height: 16),

                          // DATES
                          Row(
                            children: [
                              Expanded(
                                child: _buildTextField(
                                  controller: startDateController,
                                  label: 'Start Date',
                                  hint: 'Jan 2025',
                                  icon: Icons.calendar_today_outlined,
                                  validator: (value) {
                                    if (value == null ||
                                        value.trim().isEmpty) {
                                      return 'Required';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildTextField(
                                  controller: endDateController,
                                  label: 'End Date',
                                  hint: 'Jun 2025',
                                  icon: Icons.event_outlined,
                                  enabled: !isCurrent,
                                  validator: (value) {
                                    if (isCurrent) {
                                      return null;
                                    }

                                    if (value == null ||
                                        value.trim().isEmpty) {
                                      return 'Required';
                                    }

                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          // CURRENT JOB
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: Colors.grey.shade200,
                              ),
                            ),
                            child: CheckboxListTile(
                              value: isCurrent,
                              contentPadding:
                                  const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              controlAffinity:
                                  ListTileControlAffinity.leading,
                              activeColor: primaryColor,
                              title: const Text(
                                'I currently work here',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: const Text(
                                'End date will be shown as Present',
                              ),
                              onChanged: (value) {
                                setSheetState(() {
                                  isCurrent = value ?? false;

                                  if (isCurrent) {
                                    endDateController.clear();
                                  }
                                });
                              },
                            ),
                          ),

                          const SizedBox(height: 18),

                          // DESCRIPTION
                          _buildTextField(
                            controller: descriptionController,
                            label: 'Description',
                            hint:
                                'Describe your responsibilities, achievements, and work...',
                            icon: Icons.description_outlined,
                            maxLines: 5,
                          ),

                          const SizedBox(height: 25),

                          // SAVE BUTTON
                          SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: ElevatedButton(
                              onPressed: () {
                                if (!formKey.currentState!.validate()) {
                                  return;
                                }

                                final experience = Experience(
                                  jobTitle:
                                      jobTitleController.text.trim(),
                                  company:
                                      companyController.text.trim(),
                                  location:
                                      locationController.text.trim(),
                                  startDate:
                                      startDateController.text.trim(),
                                  endDate:
                                      endDateController.text.trim(),
                                  isCurrent: isCurrent,
                                  description:
                                      descriptionController.text.trim(),
                                );

                                setState(() {
                                  if (isEditing) {
                                    experienceList[editIndex] =
                                        experience;
                                  } else {
                                    experienceList.add(experience);
                                  }
                                });

                                Navigator.pop(sheetContext);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(14),
                                ),
                              ),
                              child: Text(
                                isEditing
                                    ? 'Update Experience'
                                    : 'Add Experience',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
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
    IconData? icon,
    String? Function(String?)? validator,
    int maxLines = 1,
    bool enabled = true,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: icon != null ? Icon(icon) : null,
        filled: true,
        fillColor: enabled
            ? Colors.grey.shade50
            : Colors.grey.shade100,
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
        alignLabelWithHint: maxLines > 1,
      ),
    );
  }

  // ============================================================
  // DELETE EXPERIENCE
  // ============================================================

  void deleteExperience(int index) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Delete Experience?',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Are you sure you want to delete this experience?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                setState(() {
                  experienceList.removeAt(index);
                });

                Navigator.pop(dialogContext);
              },
              child: const Text('Delete'),
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
              'Experience',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Step 1 of 4',
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
          // PROGRESS
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
                        color: index == 0
                            ? primaryColor
                            : Colors.grey.shade300,
                        borderRadius:
                            BorderRadius.circular(10),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          Expanded(
            child: experienceList.isEmpty
                ? _buildEmptyState()
                : _buildExperienceList(),
          ),

          // BOTTOM BUTTONS
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
                    onPressed: showExperienceForm,
                    icon: const Icon(Icons.add),
                    label: const Text(
                      'Add Experience',
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
                        borderRadius:
                            BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const SkillsScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(14),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
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
                Icons.work_outline,
                size: 48,
                color: primaryColor,
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Build your experience',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              'Add your internships, jobs, freelance work, or other professional experience.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                height: 1.5,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 28),

            ElevatedButton.icon(
              onPressed: showExperienceForm,
              icon: const Icon(Icons.add),
              label: const Text(
                'Add Experience',
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
  // EXPERIENCE LIST
  // ============================================================

  Widget _buildExperienceList() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(
        20,
        10,
        20,
        20,
      ),
      itemCount: experienceList.length,
      itemBuilder: (context, index) {
        final experience = experienceList[index];

        final String dateText = experience.isCurrent
            ? '${experience.startDate} - Present'
            : '${experience.startDate} - ${experience.endDate}';

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Colors.grey.shade200,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                // ICON
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.1),
                    borderRadius:
                        BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.work_outline,
                    color: primaryColor,
                    size: 25,
                  ),
                ),

                const SizedBox(width: 14),

                // DETAILS
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        experience.jobTitle,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        experience.company,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: primaryColor,
                        ),
                      ),

                      if (experience.location.isNotEmpty) ...[
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 15,
                              color: Colors.grey.shade500,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                experience.location,
                                style: TextStyle(
                                  color:
                                      Colors.grey.shade600,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],

                      const SizedBox(height: 6),

                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 14,
                            color: Colors.grey.shade500,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            dateText,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),

                      if (experience.description.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Text(
                          experience.description,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            height: 1.4,
                            fontSize: 13,
                          ),
                        ),
                      ],

                      if (experience.isCurrent) ...[
                        const SizedBox(height: 10),
                        Container(
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.1),
                            borderRadius:
                                BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Currently working',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // MENU
                PopupMenuButton<String>(
                  icon: const Icon(
                    Icons.more_vert,
                    color: Colors.grey,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(14),
                  ),
                  onSelected: (value) {
                    if (value == 'edit') {
                      showExperienceForm(
                        editIndex: index,
                      );
                    } else if (value == 'delete') {
                      deleteExperience(index);
                    }
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem<String>(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit_outlined),
                          SizedBox(width: 10),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline),
                          SizedBox(width: 10),
                          Text('Delete'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
