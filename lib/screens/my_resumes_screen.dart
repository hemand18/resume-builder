import 'package:flutter/material.dart';

import '../controllers/resume_controller.dart';
import '../models/resume.dart';
import 'resume_builder_screen.dart';

class MyResumesScreen extends StatefulWidget {
  const MyResumesScreen({super.key});

  @override
  State<MyResumesScreen> createState() => _MyResumesScreenState();
}

class _MyResumesScreenState extends State<MyResumesScreen> {
  final ResumeController _controller = ResumeController.instance;

  List<Resume> _resumes = [];
  bool _isLoading = true;
  bool _isCreating = false;
  String? _busyResumeId;

  @override
  void initState() {
    super.initState();
    _loadResumes();
  }

  // ============================================================
  // LOAD RESUMES
  // ============================================================

  Future<void> _loadResumes() async {
    final resumes = await _controller.getAllResumes();

    if (!mounted) return;

    setState(() {
      _resumes = resumes;
      _isLoading = false;
    });
  }

  // ============================================================
  // CREATE RESUME
  // ============================================================

  Future<void> _createResume() async {
    if (_isCreating) return;

    final String? resumeTitle = await _showCreateResumeDialog();

    if (resumeTitle == null || resumeTitle.trim().isEmpty) {
      return;
    }

    if (!mounted) return;

    setState(() {
      _isCreating = true;
    });

    _controller.createNewResume(
      title: resumeTitle.trim(),
    );

    await _controller.saveResume();

    if (!mounted) return;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ResumeBuilderScreen(),
      ),
    );

    if (!mounted) return;

    setState(() {
      _isCreating = false;
    });

    await _loadResumes();
  }

  // ============================================================
  // CREATE RESUME DIALOG
  // ============================================================

  Future<String?> _showCreateResumeDialog() async {
    final titleController = TextEditingController();

    final String? title = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Create New Resume'),
          content: TextField(
            controller: titleController,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              labelText: 'Resume name',
              hintText: 'e.g. Data Analyst Resume',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.description_outlined),
            ),
            onSubmitted: (value) {
              final trimmedTitle = value.trim();

              if (trimmedTitle.isNotEmpty) {
                Navigator.pop(dialogContext, trimmedTitle);
              }
            },
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
                final trimmedTitle = titleController.text.trim();

                if (trimmedTitle.isEmpty) {
                  return;
                }

                Navigator.pop(dialogContext, trimmedTitle);
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );

    titleController.dispose();

    return title;
  }

  // ============================================================
  // OPEN RESUME
  // ============================================================

  Future<void> _openResume(Resume resume) async {
    if (_busyResumeId != null) return;

    setState(() {
      _busyResumeId = resume.id;
    });

    await _controller.loadResume(resume.id);

    if (!mounted) return;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ResumeBuilderScreen(),
      ),
    );

    if (!mounted) return;

    setState(() {
      _busyResumeId = null;
    });

    await _loadResumes();
  }

  // ============================================================
  // RENAME RESUME
  // ============================================================

  Future<void> _renameResume(Resume resume) async {
    if (_busyResumeId != null) return;

    final controller = TextEditingController(
      text: resume.title,
    );

    final String? newTitle = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Rename Resume'),
          content: TextField(
            controller: controller,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              labelText: 'Resume title',
              hintText: 'Enter resume title',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (value) {
              final title = value.trim();

              if (title.isNotEmpty) {
                Navigator.pop(dialogContext, title);
              }
            },
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
                final title = controller.text.trim();

                if (title.isEmpty) {
                  return;
                }

                Navigator.pop(dialogContext, title);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    controller.dispose();

    if (newTitle == null || newTitle.isEmpty) {
      return;
    }

    if (!mounted) return;

    setState(() {
      _busyResumeId = resume.id;
    });

    await _controller.loadResume(resume.id);

    _controller.resume.title = newTitle;

    await _controller.saveResume();

    if (!mounted) return;

    setState(() {
      _busyResumeId = null;
    });

    await _loadResumes();
  }

  // ============================================================
  // DELETE RESUME
  // ============================================================

  Future<void> _deleteResume(Resume resume) async {
    if (_busyResumeId != null) return;

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Resume?'),
          content: Text(
            'Are you sure you want to delete "${resume.title}"?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    if (!mounted) return;

    setState(() {
      _busyResumeId = resume.id;
    });

    await _controller.deleteResume(resume.id);

    if (!mounted) return;

    setState(() {
      _busyResumeId = null;
    });

    await _loadResumes();
  }

  // ============================================================
  // DUPLICATE RESUME
  // ============================================================

  Future<void> _duplicateResume(Resume resume) async {
    if (_busyResumeId != null) return;

    setState(() {
      _busyResumeId = resume.id;
    });

    await _controller.duplicateResume(resume.id);

    if (!mounted) return;

    setState(() {
      _busyResumeId = null;
    });

    await _loadResumes();
  }

  // ============================================================
  // TEMPLATE NAME
  // ============================================================

  String _getTemplateName(String templateId) {
    switch (templateId.toLowerCase()) {
      case 'modern':
        return 'Modern';

      case 'professional':
        return 'Professional';

      case 'minimal':
        return 'Minimal';

      case 'classic':
      default:
        return 'Classic';
    }
  }

  // ============================================================
  // TEMPLATE ICON
  // ============================================================

  IconData _getTemplateIcon(String templateId) {
    switch (templateId.toLowerCase()) {
      case 'modern':
        return Icons.auto_awesome_outlined;

      case 'professional':
        return Icons.business_center_outlined;

      case 'minimal':
        return Icons.article_outlined;

      case 'classic':
      default:
        return Icons.description_outlined;
    }
  }

  // ============================================================
  // DATE FORMAT
  // ============================================================

  String _formatUpdatedDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return 'Updated just now';
    }

    if (difference.inMinutes < 60) {
      return 'Updated ${difference.inMinutes}m ago';
    }

    if (difference.inHours < 24) {
      return 'Updated ${difference.inHours}h ago';
    }

    if (difference.inDays == 1) {
      return 'Updated yesterday';
    }

    if (difference.inDays < 7) {
      return 'Updated ${difference.inDays}d ago';
    }

    return 'Updated '
        '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Resumes',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isCreating ? null : _createResume,
        icon: _isCreating
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              )
            : const Icon(Icons.add),
        label: Text(
          _isCreating ? 'Creating...' : 'Create Resume',
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _resumes.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: _loadResumes,
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(
                      20,
                      20,
                      20,
                      100,
                    ),
                    itemCount: _resumes.length,
                    itemBuilder: (context, index) {
                      final resume = _resumes[index];

                      return _buildResumeCard(resume);
                    },
                  ),
                ),
    );
  }

  // ============================================================
  // EMPTY STATE
  // ============================================================

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.description_outlined,
              size: 70,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 20),
            const Text(
              'No resumes yet',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Create your first professional resume.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 25),
            ElevatedButton.icon(
              onPressed: _isCreating ? null : _createResume,
              icon: const Icon(Icons.add),
              label: Text(
                _isCreating ? 'Creating...' : 'Create Resume',
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // RESUME CARD
  // ============================================================

  Widget _buildResumeCard(Resume resume) {
    final bool isBusy = _busyResumeId == resume.id;

    final String templateName = _getTemplateName(
      resume.templateId,
    );

    final IconData templateIcon = _getTemplateIcon(
      resume.templateId,
    );

    final bool hasPersonalName =
        resume.personalInfo.name.trim().isNotEmpty;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 1,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: isBusy ? null : () => _openResume(resume),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ------------------------------------------------
              // TOP ROW
              // ------------------------------------------------

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 25,
                    child: isBusy
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : Icon(templateIcon),
                  ),
                  const SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          resume.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),

                        Row(
                          children: [
                            Icon(
                              Icons.palette_outlined,
                              size: 15,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              '$templateName Template',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  if (!isBusy)
                    PopupMenuButton<String>(
                      padding: EdgeInsets.zero,
                      onSelected: (value) {
                        if (value == 'open') {
                          _openResume(resume);
                        } else if (value == 'rename') {
                          _renameResume(resume);
                        } else if (value == 'duplicate') {
                          _duplicateResume(resume);
                        } else if (value == 'delete') {
                          _deleteResume(resume);
                        }
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(
                          value: 'open',
                          child: ListTile(
                            leading: Icon(Icons.edit_outlined),
                            title: Text('Open'),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                        PopupMenuItem(
                          value: 'rename',
                          child: ListTile(
                            leading: Icon(Icons.drive_file_rename_outline),
                            title: Text('Rename'),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                        PopupMenuItem(
                          value: 'duplicate',
                          child: ListTile(
                            leading: Icon(Icons.copy_outlined),
                            title: Text('Duplicate'),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: ListTile(
                            leading: Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                            ),
                            title: Text('Delete'),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ],
                    ),
                ],

              ),

              const SizedBox(height: 16),

              // ------------------------------------------------
              // PERSONAL INFORMATION
              // ------------------------------------------------

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .surfaceContainerHighest
                      .withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: 18,
                      color: Colors.grey.shade700,
                    ),
                    const SizedBox(width: 9),
                    Expanded(
                      child: Text(
                        hasPersonalName
                            ? resume.personalInfo.name
                            : 'No name added',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: hasPersonalName
                              ? FontWeight.w500
                              : FontWeight.normal,
                          color: hasPersonalName
                              ? null
                              : Colors.grey.shade600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // ------------------------------------------------
              // BOTTOM INFORMATION
              // ------------------------------------------------

              Row(
                children: [
                  Icon(
                    Icons.access_time_outlined,
                    size: 15,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      _formatUpdatedDate(resume.updatedAt),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),

                  if (!isBusy)
                    TextButton.icon(
                      onPressed: () => _openResume(resume),
                      icon: const Icon(
                        Icons.edit_outlined,
                        size: 17,
                      ),
                      label: const Text('Open'),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}