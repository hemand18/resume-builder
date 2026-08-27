import 'package:flutter/material.dart';

import 'resume_preview_screen.dart';

class TemplateSelectionScreen extends StatefulWidget {
  const TemplateSelectionScreen({super.key});

  @override
  State<TemplateSelectionScreen> createState() =>
      _TemplateSelectionScreenState();
}

class _TemplateSelectionScreenState
    extends State<TemplateSelectionScreen> {
  int selectedTemplate = 0;

  static const Color primaryColor = Color(0xFF4F46E5);
  static const Color backgroundColor = Color(0xFFF8F9FC);
  static const Color textColor = Color(0xFF111827);
  static const Color secondaryTextColor = Color(0xFF6B7280);

  final List<Map<String, dynamic>> templates = [
    {
      'title': 'Classic',
      'subtitle': 'Clean & timeless',
      'icon': Icons.description_outlined,
    },
    {
      'title': 'Modern',
      'subtitle': 'Fresh & creative',
      'icon': Icons.auto_awesome_outlined,
    },
    {
      'title': 'Professional',
      'subtitle': 'Corporate & polished',
      'icon': Icons.business_center_outlined,
    },
    {
      'title': 'Minimal',
      'subtitle': 'Simple & elegant',
      'icon': Icons.article_outlined,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: false,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose Template',
              style: TextStyle(
                color: textColor,
                fontSize: 21,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Select a design for your resume',
              style: TextStyle(
                color: secondaryTextColor,
                fontSize: 12,
              ),
            ),
          ],
        ),
        iconTheme: const IconThemeData(
          color: textColor,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                20,
                10,
                20,
                20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildTemplateGrid(),
                  const SizedBox(height: 20),
                  _buildSelectedInfo(),
                ],
              ),
            ),
          ),
          _buildBottomButton(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: primaryColor.withOpacity(0.10),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.palette_outlined,
              color: primaryColor,
              size: 27,
            ),
          ),
          const SizedBox(width: 15),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Make your resume stand out',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Choose a professional layout that matches your style.',
                  style: TextStyle(
                    color: secondaryTextColor,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemplateGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: templates.length,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 0.82,
      ),
      itemBuilder: (context, index) {
        final template = templates[index];

        return _templateCard(
          index: index,
          title: template['title'] as String,
          subtitle: template['subtitle'] as String,
          icon: template['icon'] as IconData,
        );
      },
    );
  }

  Widget _templateCard({
    required int index,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final bool isSelected = selectedTemplate == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTemplate = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? primaryColor
                : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(
                isSelected ? 0.07 : 0.025,
              ),
              blurRadius: isSelected ? 14 : 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? primaryColor.withOpacity(0.07)
                        : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: _buildResumePreview(
                          index,
                          isSelected,
                        ),
                      ),
                      if (isSelected)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: const BoxDecoration(
                              color: primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 17,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 13),
              Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? primaryColor.withOpacity(0.10)
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      icon,
                      size: 18,
                      color: isSelected
                          ? primaryColor
                          : Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: textColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: const TextStyle(
                            color: secondaryTextColor,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? primaryColor.withOpacity(0.09)
                      : Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Text(
                  isSelected ? 'Selected' : 'Tap to select',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? primaryColor
                        : Colors.grey.shade600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResumePreview(
    int index,
    bool isSelected,
  ) {
    return Container(
      width: 105,
      height: 140,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: index == 1 ? 55 : 65,
            height: 7,
            decoration: BoxDecoration(
              color: isSelected
                  ? primaryColor
                  : Colors.grey.shade800,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(height: 5),
          Container(
            width: 75,
            height: 3,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: isSelected
                  ? primaryColor
                  : Colors.grey.shade600,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 6),
          _previewLine(70),
          _previewLine(85),
          _previewLine(60),
          const SizedBox(height: 10),
          Container(
            width: 45,
            height: 5,
            decoration: BoxDecoration(
              color: isSelected
                  ? primaryColor
                  : Colors.grey.shade600,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 6),
          _previewLine(82),
          _previewLine(65),
          _previewLine(75),
          const SizedBox(height: 10),
          Container(
            width: 38,
            height: 5,
            decoration: BoxDecoration(
              color: isSelected
                  ? primaryColor
                  : Colors.grey.shade600,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 6),
          _previewLine(78),
          _previewLine(55),
        ],
      ),
    );
  }

  Widget _previewLine(double width) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Container(
        width: width,
        height: 3,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildSelectedInfo() {
    final String selectedName =
        templates[selectedTemplate]['title'] as String;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 13,
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
          const Icon(
            Icons.check_circle_outline,
            color: primaryColor,
            size: 21,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '$selectedName template selected',
              style: const TextStyle(
                color: textColor,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            '${selectedTemplate + 1}/${templates.length}',
            style: const TextStyle(
              color: secondaryTextColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton() {
    return Container(
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
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ResumePreviewScreen(
                  templateIndex: selectedTemplate,
                ),
              ),
            );
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Continue to Preview',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(width: 9),
              Icon(
                Icons.arrow_forward_rounded,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}