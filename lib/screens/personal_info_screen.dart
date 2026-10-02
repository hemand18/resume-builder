import 'package:flutter/material.dart';

import 'education_screen.dart';
import '../controllers/resume_controller.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final locationController = TextEditingController();
  final linkedinController = TextEditingController();
  final githubController = TextEditingController();
  final summaryController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final personalInfo =
        ResumeController.instance.resume.personalInfo;

    nameController.text = personalInfo.name;
    emailController.text = personalInfo.email;
    phoneController.text = personalInfo.phone;
    locationController.text = personalInfo.location;
    linkedinController.text = personalInfo.linkedin;
    githubController.text = personalInfo.github;
    summaryController.text = personalInfo.summary;

    nameController.addListener(_onPersonalInfoChanged);
    emailController.addListener(_onPersonalInfoChanged);
    phoneController.addListener(_onPersonalInfoChanged);
    locationController.addListener(_onPersonalInfoChanged);
    linkedinController.addListener(_onPersonalInfoChanged);
    githubController.addListener(_onPersonalInfoChanged);
    summaryController.addListener(_onPersonalInfoChanged);
  }

  void _updatePersonalInfoModel() {
    final personalInfo =
        ResumeController.instance.resume.personalInfo;

    personalInfo.name = nameController.text.trim();
    personalInfo.email = emailController.text.trim();
    personalInfo.phone = phoneController.text.trim();
    personalInfo.location = locationController.text.trim();
    personalInfo.linkedin = linkedinController.text.trim();
    personalInfo.github = githubController.text.trim();
    personalInfo.summary = summaryController.text.trim();
  }

  void _onPersonalInfoChanged() {
    _updatePersonalInfoModel();
    ResumeController.instance.scheduleAutosave();
  }

  @override
  void dispose() {
    nameController.removeListener(_onPersonalInfoChanged);
    emailController.removeListener(_onPersonalInfoChanged);
    phoneController.removeListener(_onPersonalInfoChanged);
    locationController.removeListener(_onPersonalInfoChanged);
    linkedinController.removeListener(_onPersonalInfoChanged);
    githubController.removeListener(_onPersonalInfoChanged);
    summaryController.removeListener(_onPersonalInfoChanged);

    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    locationController.dispose();
    linkedinController.dispose();
    githubController.dispose();
    summaryController.dispose();

    super.dispose();
  }

  Future<void> saveAndContinue() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _updatePersonalInfoModel();

    await ResumeController.instance.saveNow();

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EducationScreen(),
      ),
    );
  }

  InputDecoration fieldDecoration({
    required String label,
    required IconData icon,
    String? hint,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon),
    );
  }

  Widget sectionTitle({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.indigo.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: Colors.indigo,
            size: 22,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget field({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: fieldDecoration(
        label: label,
        icon: icon,
        hint: hint,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Information'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sectionTitle(
                title: 'Tell us about yourself',
                subtitle:
                    'Add your basic details to create a professional resume.',
                icon: Icons.person_outline,
              ),

              const SizedBox(height: 28),

              // BASIC INFORMATION
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: Colors.grey.shade200,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Basic Information',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Your name and contact details',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 18),

                    field(
                      controller: nameController,
                      label: 'Full Name',
                      icon: Icons.person_outline,
                      hint: 'e.g. Hemand Kumar',
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your name';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 15),

                    field(
                      controller: emailController,
                      label: 'Email',
                      icon: Icons.email_outlined,
                      hint: 'e.g. example@gmail.com',
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your email';
                        }

                        final email = value.trim();

                        if (!email.contains('@') ||
                            !email.contains('.')) {
                          return 'Enter a valid email';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 15),

                    field(
                      controller: phoneController,
                      label: 'Phone',
                      icon: Icons.phone_outlined,
                      hint: 'e.g. +91 9876543210',
                      keyboardType: TextInputType.phone,
                    ),

                    const SizedBox(height: 15),

                    field(
                      controller: locationController,
                      label: 'Location',
                      icon: Icons.location_on_outlined,
                      hint: 'e.g. Chennai, India',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // ONLINE PROFILES
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: Colors.grey.shade200,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Online Profiles',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Add links to your professional profiles',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 18),

                    field(
                      controller: linkedinController,
                      label: 'LinkedIn',
                      icon: Icons.link,
                      hint: 'https://linkedin.com/in/yourname',
                      keyboardType: TextInputType.url,
                    ),

                    const SizedBox(height: 15),

                    field(
                      controller: githubController,
                      label: 'GitHub',
                      icon: Icons.code,
                      hint: 'https://github.com/yourusername',
                      keyboardType: TextInputType.url,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // SUMMARY
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: Colors.grey.shade200,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.short_text,
                          color: Colors.indigo,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Professional Summary',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    Text(
                      'Write a short introduction about your skills and career goals.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      controller: summaryController,
                      maxLines: 6,
                      maxLength: 500,
                      decoration: const InputDecoration(
                        hintText:
                            'Example: Motivated BCA graduate with skills in Python, SQL, Flutter and data analytics...',
                        alignLabelWithHint: true,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // CONTINUE BUTTON
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: saveAndContinue,
                  icon: const Icon(Icons.arrow_forward_rounded),
                  label: const Text(
                    'Save & Continue',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Center(
                child: Text(
                  'You can edit these details later',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}