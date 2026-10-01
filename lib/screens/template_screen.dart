import 'package:flutter/material.dart';

import 'resume_preview_screen.dart';

class TemplateScreen extends StatefulWidget {
  const TemplateScreen({super.key});

  @override
  State<TemplateScreen> createState() => _TemplateScreenState();
}

class _TemplateScreenState extends State<TemplateScreen> {
  int selectedTemplate = 0;

  final List<Map<String, dynamic>> templates = [
    {
      'name': 'Classic',
      'description': 'Clean and traditional resume design',
      'icon': Icons.description_outlined,
      'color': Colors.black,
    },
    {
      'name': 'Modern',
      'description': 'Modern design with blue accents',
      'icon': Icons.auto_awesome_outlined,
      'color': Colors.blue,
    },
    {
      'name': 'Professional',
      'description': 'Professional dark header design',
      'icon': Icons.business_center_outlined,
      'color': Colors.indigo,
    },
    {
      'name': 'Minimal',
      'description': 'Simple and elegant resume design',
      'icon': Icons.minimize_outlined,
      'color': Colors.grey,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Choose Template',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choose Your Resume Template',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Select a template for your professional resume.',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 25),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: templates.length,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 0.85,
              ),
              itemBuilder: (context, index) {
                final template = templates[index];

                final String templateName =
                    template['name'] as String;

                final String templateDescription =
                    template['description'] as String;

                final IconData templateIcon =
                    template['icon'] as IconData;

                final Color templateColor =
                    template['color'] as Color;

                final bool isSelected =
                    selectedTemplate == index;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedTemplate = index;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: isSelected
                            ? templateColor
                            : Colors.grey.shade300,
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius:
                                  BorderRadius.circular(10),
                            ),
                            child: Icon(
                              templateIcon,
                              size: 60,
                              color: templateColor,
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        Text(
                          templateName,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          templateDescription,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),

                        const SizedBox(height: 10),

                        if (isSelected)
                          Icon(
                            Icons.check_circle,
                            color: templateColor,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResumePreviewScreen(
                        templateIndex: selectedTemplate,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.preview),
                label: const Text(
                  'Preview Resume',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}