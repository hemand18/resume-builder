import 'package:flutter/material.dart';

import '../models/resume.dart';
import '../models/resume_controller.dart';
import 'experience_screen.dart';

class EducationScreen extends StatefulWidget {
  const EducationScreen({super.key});

  @override
  State<EducationScreen> createState() => _EducationScreenState();
}

class _EducationScreenState extends State<EducationScreen> {
  List<Education> get educationList =>
      ResumeController.instance.resume.education;

  // ============================================================
  // ADD / EDIT EDUCATION
  // ============================================================

  void showEducationForm({int? editIndex}) {
    final bool isEditing = editIndex != null;

    final Education? existingEducation =
        isEditing ? educationList[editIndex] : null;

    final degreeController = TextEditingController(
      text: existingEducation?.degree ?? '',
    );

    final institutionController = TextEditingController(
      text: existingEducation?.institution ?? '',
    );

    final locationController = TextEditingController(
      text: existingEducation?.location ?? '',
    );

    final startYearController = TextEditingController(
      text: existingEducation?.startYear ?? '',
    );

    final endYearController = TextEditingController(
      text: existingEducation?.endYear ?? '',
    );

    final gradeController = TextEditingController(
      text: existingEducation?.grade ?? '',
    );

    final descriptionController = TextEditingController(
      text: existingEducation?.description ?? '',
    );

    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(28),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 12,
              bottom:
                  MediaQuery.of(bottomSheetContext).viewInsets.bottom + 20,
            ),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Drag handle
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

                    // Header
                    Row(
                      children: [
                        Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            color: Colors.indigo.withValues(alpha: 0.10),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.school_outlined,
                            color: Colors.indigo,
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Text(
                            isEditing
                                ? 'Edit Education'
                                : 'Add Education',
                            style: const TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),

                        IconButton(
                          onPressed: () {
                            Navigator.pop(bottomSheetContext);
                          },
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Degree
                    TextFormField(
                      controller: degreeController,
                      decoration: const InputDecoration(
                        labelText: 'Degree / Course',
                        hintText:
                            'e.g. Bachelor of Computer Applications',
                        prefixIcon: Icon(Icons.school_outlined),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your degree';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 15),

                    // Institution
                    TextFormField(
                      controller: institutionController,
                      decoration: const InputDecoration(
                        labelText: 'Institution',
                        hintText: 'e.g. ABC College',
                        prefixIcon:
                            Icon(Icons.account_balance_outlined),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your institution';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 15),

                    // Location
                    TextFormField(
                      controller: locationController,
                      decoration: const InputDecoration(
                        labelText: 'Location',
                        hintText: 'e.g. Chennai, Tamil Nadu',
                        prefixIcon:
                            Icon(Icons.location_on_outlined),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter the location';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 15),

                    // Years
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: startYearController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Start Year',
                              hintText: '2023',
                              prefixIcon:
                                  Icon(Icons.calendar_today_outlined),
                            ),
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
                          child: TextFormField(
                            controller: endYearController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'End Year',
                              hintText: '2026',
                              prefixIcon:
                                  Icon(Icons.calendar_today_outlined),
                            ),
                            validator: (value) {
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

                    const SizedBox(height: 15),

                    // Grade
                    TextFormField(
                      controller: gradeController,
                      decoration: const InputDecoration(
                        labelText: 'CGPA / Percentage',
                        hintText: 'e.g. 8.5 CGPA or 85%',
                        prefixIcon: Icon(Icons.grade_outlined),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // Description
                    TextFormField(
                      controller: descriptionController,
                      maxLines: 4,
                      maxLength: 500,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        hintText:
                            'Add relevant academic details, achievements, etc.',
                        prefixIcon:
                            Icon(Icons.description_outlined),
                        alignLabelWithHint: true,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Save
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (!formKey.currentState!.validate()) {
                            return;
                          }

                          final Education newEducation = Education(
                            degree: degreeController.text.trim(),
                            institution:
                                institutionController.text.trim(),
                            location:
                                locationController.text.trim(),
                            startYear:
                                startYearController.text.trim(),
                            endYear:
                                endYearController.text.trim(),
                            grade: gradeController.text.trim(),
                            description:
                                descriptionController.text.trim(),
                          );

                          setState(() {
                            if (isEditing) {
                              educationList[editIndex] =
                                  newEducation;
                            } else {
                              educationList.add(newEducation);
                            }
                          });

                          Navigator.pop(bottomSheetContext);
                        },
                        icon: Icon(
                          isEditing
                              ? Icons.check_rounded
                              : Icons.add_rounded,
                        ),
                        label: Text(
                          isEditing
                              ? 'Update Education'
                              : 'Add Education',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // DELETE EDUCATION
  // ============================================================

  void deleteEducation(int index) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Delete Education?',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Are you sure you want to delete this education entry?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                setState(() {
                  educationList.removeAt(index);
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
      appBar: AppBar(
        title: const Text('Education'),
      ),

      body: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              18,
              20,
              8,
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.indigo.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.school_outlined,
                    color: Colors.indigo,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Your Education',
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Add your academic background',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // List / Empty State
          Expanded(
            child: educationList.isEmpty
                ? _buildEmptyState()
                : _buildEducationList(),
          ),

          // Bottom buttons
          Container(
            padding: const EdgeInsets.fromLTRB(
              20,
              10,
              20,
              20,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      showEducationForm();
                    },
                    icon: const Icon(Icons.add_rounded),
                    label: const Text(
                      'Add Education',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: educationList.isEmpty
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ExperienceScreen(),
                              ),
                            );
                          },
                    icon: const Icon(
                      Icons.arrow_forward_rounded,
                    ),
                    label: const Text(
                      'Save & Continue',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
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
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.indigo.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.school_outlined,
                size: 45,
                color: Colors.indigo,
              ),
            ),

            const SizedBox(height: 22),

            const Text(
              'No education added yet',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Add your degree, college, location, '
              'academic dates, and grade to continue.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 24),

            ElevatedButton.icon(
              onPressed: () {
                showEducationForm();
              },
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add Education'),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // EDUCATION LIST
  // ============================================================

  Widget _buildEducationList() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(
        20,
        8,
        20,
        20,
      ),
      itemCount: educationList.length,
      itemBuilder: (context, index) {
        final Education education = educationList[index];

        String dateText = '';

        if (education.startYear.isNotEmpty &&
            education.endYear.isNotEmpty) {
          dateText =
              '${education.startYear} - ${education.endYear}';
        } else if (education.startYear.isNotEmpty) {
          dateText = education.startYear;
        } else if (education.endYear.isNotEmpty) {
          dateText = education.endYear;
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Colors.grey.shade200,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.indigo.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.school_outlined,
                  color: Colors.indigo,
                ),
              ),

              const SizedBox(width: 14),

              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      education.degree,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      education.institution,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    if (education.location.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 15,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              education.location,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],

                    if (dateText.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 14,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            dateText,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],

                    if (education.grade.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.indigo.withValues(alpha: 0.08),
                          borderRadius:
                              BorderRadius.circular(8),
                        ),
                        child: Text(
                          education.grade,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.indigo,
                          ),
                        ),
                      ),
                    ],

                    if (education.description.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        education.description,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade700,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Menu
              PopupMenuButton<String>(
                padding: EdgeInsets.zero,
                onSelected: (value) {
                  if (value == 'edit') {
                    showEducationForm(
                      editIndex: index,
                    );
                  } else if (value == 'delete') {
                    deleteEducation(index);
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
        );
      },
    );
  }
}