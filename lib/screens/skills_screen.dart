import 'package:flutter/material.dart';

import '../models/resume_controller.dart';
import 'projects_screen.dart';

class SkillsScreen extends StatefulWidget {
  const SkillsScreen({super.key});

  @override
  State<SkillsScreen> createState() => _SkillsScreenState();
}

class _SkillsScreenState extends State<SkillsScreen> {
  List<String> get skillsList =>
      ResumeController.instance.resume.skills;

  final TextEditingController skillController =
      TextEditingController();

  static const Color primaryColor = Color(0xFF4F46E5);
  static const Color backgroundColor = Color(0xFFF8FAFC);

  // ============================================================
  // ADD SKILL
  // ============================================================

  bool addSkill() {
    final skill = skillController.text.trim();

    if (skill.isEmpty) {
      return false;
    }

    final alreadyExists = skillsList.any(
      (existingSkill) =>
          existingSkill.toLowerCase() == skill.toLowerCase(),
    );

    if (alreadyExists) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'This skill has already been added.',
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );

      return false;
    }

    setState(() {
      skillsList.add(skill);
      skillController.clear();
    });

    return true;
  }

  // ============================================================
  // DELETE SKILL
  // ============================================================

  void deleteSkill(int index) {
    final deletedSkill = skillsList[index];

    setState(() {
      skillsList.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$deletedSkill removed'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () {
            setState(() {
              skillsList.insert(
                index.clamp(0, skillsList.length),
                deletedSkill,
              );
            });
          },
        ),
      ),
    );
  }

  // ============================================================
  // SHOW ADD SKILL DIALOG
  // ============================================================

  void _showAddSkillDialog() {
    skillController.clear();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          titlePadding: const EdgeInsets.fromLTRB(
            24,
            24,
            24,
            8,
          ),
          contentPadding: const EdgeInsets.fromLTRB(
            24,
            10,
            24,
            8,
          ),
          actionsPadding: const EdgeInsets.fromLTRB(
            16,
            4,
            16,
            16,
          ),
          title: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.code_outlined,
                  color: primaryColor,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Add Skill',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: TextField(
            controller: skillController,
            autofocus: true,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) {
              final added = addSkill();

              if (added) {
                Navigator.pop(dialogContext);
              }
            },
            decoration: InputDecoration(
              labelText: 'Skill',
              hintText: 'e.g. Flutter',
              prefixIcon: const Icon(
                Icons.code_outlined,
              ),
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
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                final added = addSkill();

                if (added) {
                  Navigator.pop(dialogContext);
                }
              },
              child: const Text(
                'Add Skill',
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
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    skillController.dispose();
    super.dispose();
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
              'Skills',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Step 3 of 6',
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
                6,
                (index) {
                  return Expanded(
                    child: Container(
                      margin: EdgeInsets.only(
                        right: index == 5 ? 0 : 6,
                      ),
                      height: 5,
                      decoration: BoxDecoration(
                        color: index <= 2
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

          // ======================================================
          // CONTENT
          // ======================================================

          Expanded(
            child: skillsList.isEmpty
                ? _buildEmptyState()
                : _buildSkillsList(),
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
                    onPressed: _showAddSkillDialog,
                    icon: const Icon(Icons.add),
                    label: const Text(
                      'Add Skill',
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
                    onPressed: skillsList.isEmpty
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ProjectsScreen(),
                              ),
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor:
                          Colors.grey.shade300,
                      disabledForegroundColor:
                          Colors.grey.shade600,
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
                Icons.code_outlined,
                size: 48,
                color: primaryColor,
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Showcase your skills',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              'Add technical and professional skills '
              'that you want employers to notice on your resume.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                height: 1.5,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 28),

            ElevatedButton.icon(
              onPressed: _showAddSkillDialog,
              icon: const Icon(Icons.add),
              label: const Text(
                'Add Your First Skill',
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
                  borderRadius:
                      BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // SKILLS LIST
  // ============================================================

  Widget _buildSkillsList() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        20,
        10,
        20,
        20,
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          // ======================================================
          // HEADER CARD
          // ======================================================

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.circular(18),
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
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color:
                        primaryColor.withValues(alpha: 0.1),
                    borderRadius:
                        BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.code_outlined,
                    color: primaryColor,
                    size: 26,
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Your Skills',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${skillsList.length} '
                        '${skillsList.length == 1 ? 'skill' : 'skills'} added',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color:
                        primaryColor.withValues(alpha: 0.1),
                    borderRadius:
                        BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${skillsList.length}',
                    style: const TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          Text(
            'Add the skills you want to highlight '
            'on your resume.',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 18),

          // ======================================================
          // SKILLS
          // ======================================================

          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: List.generate(
              skillsList.length,
              (index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey.shade200,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color:
                            Colors.black.withValues(alpha: 0.025),
                        blurRadius: 6,
                        offset:
                            const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Chip(
                    backgroundColor: Colors.white,
                    surfaceTintColor:
                        Colors.transparent,
                    side: BorderSide.none,
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 7,
                    ),
                    avatar: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color:
                            primaryColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        size: 15,
                        color: primaryColor,
                      ),
                    ),
                    label: Text(
                      skillsList[index],
                      style: const TextStyle(
                        fontWeight:
                            FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    deleteIcon: Icon(
                      Icons.close,
                      size: 17,
                      color: Colors.grey.shade500,
                    ),
                    onDeleted: () {
                      deleteSkill(index);
                    },
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          // ======================================================
          // TIP CARD
          // ======================================================

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color:
                  Colors.amber.withValues(alpha: 0.08),
              borderRadius:
                  BorderRadius.circular(14),
              border: Border.all(
                color:
                    Colors.amber.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: Colors.amber.shade800,
                  size: 22,
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Text(
                    'Tip: Add skills that match the jobs '
                    'you are applying for. Include both '
                    'technical and professional skills.',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 13,
                      height: 1.4,
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
}