
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

  Future<void> _loadResumes() async {
    try {
      final resumes = await _controller.getAllResumes();

      if (!mounted) return;

      setState(() {
        _resumes = resumes;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      _showMessage('Unable to load resumes. Please try again.');
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _createResume() async {
    if (_isCreating || _busyResumeId != null) return;

    final title = await _showCreateResumeDialog();

    if (title == null || title.trim().isEmpty || !mounted) return;

    setState(() => _isCreating = true);

    try {
      _controller.createNewResume(title: title.trim());
      await _controller.saveResume();

      if (!mounted) return;

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const ResumeBuilderScreen(),
        ),
      );
    } catch (_) {
      _showMessage('Unable to create the resume. Please try again.');
    } finally {
      if (mounted) {
        setState(() => _isCreating = false);
        await _loadResumes();
      }
    }
  }

  Future<String?> _showCreateResumeDialog() async {
    final titleController = TextEditingController();

    try {
      return await showDialog<String>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            icon: const Icon(Icons.description_outlined, size: 32),
            title: const Text('Create new resume'),
            content: TextField(
              controller: titleController,
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.done,
              maxLength: 60,
              decoration: const InputDecoration(
                labelText: 'Resume name',
                hintText: 'e.g. Data Analyst Resume',
                prefixIcon: Icon(Icons.edit_outlined),
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  Navigator.pop(dialogContext, value.trim());
                }
              },
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Cancel'),
              ),
              FilledButton.icon(
                onPressed: () {
                  final title = titleController.text.trim();

                  if (title.isNotEmpty) {
                    Navigator.pop(dialogContext, title);
                  }
                },
                icon: const Icon(Icons.add),
                label: const Text('Create'),
              ),
            ],
          );
        },
      );
    } finally {
      titleController.dispose();
    }
  }

  Future<void> _openResume(Resume resume) async {
    if (_busyResumeId != null || _isCreating) return;

    setState(() => _busyResumeId = resume.id);

    try {
      await _controller.loadResume(resume.id);

      if (!mounted) return;

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const ResumeBuilderScreen(),
        ),
      );
    } catch (_) {
      _showMessage('Unable to open this resume.');
    } finally {
      if (mounted) {
        setState(() => _busyResumeId = null);
        await _loadResumes();
      }
    }
  }

  Future<void> _renameResume(Resume resume) async {
    if (_busyResumeId != null || _isCreating) return;

    final titleController = TextEditingController(text: resume.title);

    String? newTitle;

    try {
      newTitle = await showDialog<String>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text('Rename resume'),
            content: TextField(
              controller: titleController,
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.done,
              maxLength: 60,
              decoration: const InputDecoration(
                labelText: 'Resume title',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  Navigator.pop(dialogContext, value.trim());
                }
              },
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () {
                  final title = titleController.text.trim();

                  if (title.isNotEmpty) {
                    Navigator.pop(dialogContext, title);
                  }
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      );
    } finally {
      titleController.dispose();
    }

    if (newTitle == null || newTitle.trim().isEmpty || !mounted) {
      return;
    }

    setState(() => _busyResumeId = resume.id);

    try {
      await _controller.loadResume(resume.id);
      _controller.resume.title = newTitle.trim();
      await _controller.saveResume();

      _showMessage('Resume renamed successfully.');
    } catch (_) {
      _showMessage('Unable to rename this resume.');
    } finally {
      if (mounted) {
        setState(() => _busyResumeId = null);
        await _loadResumes();
      }
    }
  }

  Future<void> _deleteResume(Resume resume) async {
    if (_busyResumeId != null || _isCreating) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          icon: Icon(
            Icons.delete_outline,
            color: Theme.of(context).colorScheme.error,
            size: 32,
          ),
          title: const Text('Delete resume?'),
          content: Text(
            'Are you sure you want to delete "${resume.title}"? '
            'This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    setState(() => _busyResumeId = resume.id);

    try {
      await _controller.deleteResume(resume.id);
      _showMessage('Resume deleted.');
    } catch (_) {
      _showMessage('Unable to delete this resume.');
    } finally {
      if (mounted) {
        setState(() => _busyResumeId = null);
        await _loadResumes();
      }
    }
  }

  Future<void> _duplicateResume(Resume resume) async {
    if (_busyResumeId != null || _isCreating) return;

    setState(() => _busyResumeId = resume.id);

    try {
      final duplicate = await _controller.duplicateResume(resume.id);

      if (duplicate != null) {
        _showMessage('Resume duplicated successfully.');
      } else {
        _showMessage('Unable to duplicate this resume.');
      }
    } catch (_) {
      _showMessage('Unable to duplicate this resume.');
    } finally {
      if (mounted) {
        setState(() => _busyResumeId = null);
        await _loadResumes();
      }
    }
  }

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

  String _formatUpdatedDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.isNegative || difference.inSeconds < 60) {
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ResumeCraft',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            tooltip: 'Refresh resumes',
            onPressed: _isLoading ? null : _loadResumes,
            icon: const Icon(Icons.refresh),
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isCreating || _busyResumeId != null
            ? null
            : _createResume,
        icon: _isCreating
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.add),
        label: Text(_isCreating ? 'Creating...' : 'Create Resume'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadResumes,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 110),
                children: [
                  _buildHeader(colors),
                  const SizedBox(height: 24),
                  if (_resumes.isEmpty)
                    _buildEmptyState(colors)
                  else ...[
                    Row(
                      children: [
                        Text(
                          'Your resumes',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${_resumes.length} saved',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    for (final resume in _resumes)
                      _buildResumeCard(resume),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildHeader(ColorScheme colors) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colors.primary,
            Color.lerp(colors.primary, colors.tertiary, 0.55)!,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.description_outlined,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Build your next opportunity.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create, customize, and manage your professional resumes in one place.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              const Icon(
                Icons.folder_open_outlined,
                color: Colors.white,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                '${_resumes.length} ${_resumes.length == 1 ? 'resume' : 'resumes'} saved',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ColorScheme colors) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 34, 24, 30),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Column(
        children: [
          Container(
            width: 104,
            height: 104,
            decoration: BoxDecoration(
              color: colors.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.post_add_rounded,
              size: 48,
              color: colors.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 22),
          Text(
            'Your next chapter starts here',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 10),
          Text(
            'You haven’t created a resume yet. Start with your details, '
            'add your experience, and choose a template that fits your goals.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colors.onSurfaceVariant,
                  height: 1.5,
                ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _isCreating ? null : _createResume,
            icon: const Icon(Icons.add),
            label: const Text('Create your first resume'),
          ),
          const SizedBox(height: 12),
          Text(
            'Your resumes are saved on this device.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildResumeCard(Resume resume) {
    final colors = Theme.of(context).colorScheme;
    final isBusy = _busyResumeId == resume.id;
    final templateName = _getTemplateName(resume.templateId);
    final hasName = resume.personalInfo.name.trim().isNotEmpty;

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 0,
      color: colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: colors.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: isBusy ? null : () => _openResume(resume),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 54,
                    height: 58,
                    decoration: BoxDecoration(
                      color: colors.primaryContainer,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: isBusy
                        ? const Padding(
                            padding: EdgeInsets.all(16),
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : Icon(
                            _getTemplateIcon(resume.templateId),
                            color: colors.onPrimaryContainer,
                            size: 27,
                          ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 3),
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
                          const SizedBox(height: 7),
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Icon(
                                Icons.palette_outlined,
                                size: 15,
                                color: colors.onSurfaceVariant,
                              ),
                              Text(
                                '$templateName template',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: colors.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (!isBusy)
                    PopupMenuButton<String>(
                      tooltip: 'Resume options',
                      onSelected: (value) {
                        switch (value) {
                          case 'open':
                            _openResume(resume);
                            break;
                          case 'rename':
                            _renameResume(resume);
                            break;
                          case 'duplicate':
                            _duplicateResume(resume);
                            break;
                          case 'delete':
                            _deleteResume(resume);
                            break;
                        }
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(
                          value: 'open',
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Icon(Icons.edit_outlined),
                            title: Text('Open'),
                          ),
                        ),
                        PopupMenuItem(
                          value: 'rename',
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Icon(Icons.drive_file_rename_outline),
                            title: Text('Rename'),
                          ),
                        ),
                        PopupMenuItem(
                          value: 'duplicate',
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Icon(Icons.copy_outlined),
                            title: Text('Duplicate'),
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                            ),
                            title: Text('Delete'),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 13,
                ),
                decoration: BoxDecoration(
                  color: colors.surfaceContainerHighest.withValues(alpha: 0.45),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: 19,
                      color: colors.onSurfaceVariant,
                    ),
                    const SizedBox(width: 9),
                    Expanded(
                      child: Text(
                        hasName ? resume.personalInfo.name : 'No name added',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight:
                              hasName ? FontWeight.w500 : FontWeight.normal,
                          color: hasName ? null : colors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.access_time_outlined,
                    size: 15,
                    color: colors.onSurfaceVariant,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      _formatUpdatedDate(resume.updatedAt),
                      style: TextStyle(
                        fontSize: 12,
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ),
                  if (!isBusy)
                    TextButton.icon(
                      onPressed: () => _openResume(resume),
                      icon: const Icon(Icons.arrow_forward_rounded, size: 17),
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