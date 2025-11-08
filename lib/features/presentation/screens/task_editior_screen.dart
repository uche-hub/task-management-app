import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_management_app/core/enum/task_priority.dart';
import 'package:task_management_app/core/enum/task_status.dart';
import 'package:task_management_app/features/data/models/task_tag.dart';
import 'package:task_management_app/features/presentation/provider/tag_notifier.dart';
import 'package:task_management_app/features/presentation/provider/tasks_notifier.dart';
import 'package:task_management_app/features/presentation/widgets/task%20editor%20widgets/editor_due_date_field.dart';
import 'package:task_management_app/features/presentation/widgets/task%20editor%20widgets/editor_input_field.dart';
import 'package:task_management_app/features/presentation/widgets/task%20editor%20widgets/editor_priority_selector_segmented.dart';
import 'package:task_management_app/features/presentation/widgets/task%20editor%20widgets/editor_simple_info_field.dart';
import 'package:task_management_app/features/presentation/widgets/task%20editor%20widgets/editor_status_segmented.dart';
import 'package:task_management_app/features/presentation/widgets/task%20editor%20widgets/editor_tag_error_state.dart';
import 'package:task_management_app/features/presentation/widgets/task%20editor%20widgets/editor_tag_management.dart';

import '../../../task_core.dart';

class TaskEditorScreen extends ConsumerStatefulWidget {
  final String listId;
  final Task? task;

  const TaskEditorScreen({super.key, required this.listId, this.task});

  @override
  ConsumerState<TaskEditorScreen> createState() => _TaskEditorScreenState();
}

class _TaskEditorScreenState extends ConsumerState<TaskEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _uuid = const Uuid();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime? _selectedDueDate;
  TaskPriority _selectedPriority = TaskPriority.medium;
  TaskStatus _selectedStatus = TaskStatus.todo;
  List<Tag> _selectedTags = [];
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description ?? '';
      _selectedDueDate = widget.task!.dueDate;
      _selectedPriority = widget.task!.priority;
      _selectedStatus = widget.task!.status;
      _selectedTags = List.from(widget.task!.tags);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tagsAsync = ref.watch(tagsProvider);
    final colorScheme = Theme.of(context).colorScheme;
    ResponsiveSize.init(context);

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLowest,
      appBar: _buildAppBar(context, colorScheme),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(ResponsiveSize.width(20)),
          children: [
            _buildSectionTitle('Title', colorScheme),
            SizedBox(height: ResponsiveSize.height(8)),
            EditorInputField(
              controller: _titleController,
              hintText: 'e.g., Website cover design',
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            SizedBox(height: ResponsiveSize.height(24)),

            _buildSectionTitle('Description', colorScheme),
            SizedBox(height: ResponsiveSize.height(8)),
            EditorInputField(
              controller: _descriptionController,
              hintText: 'Enter task description',
              maxLines: 4,
            ),
            SizedBox(height: ResponsiveSize.height(24)),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: EditorDueDateField(
                    selectedDate: _selectedDueDate,
                    onDateSelected: (date) => setState(() => _selectedDueDate = date),
                  ),
                ),
                SizedBox(width: ResponsiveSize.width(16)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('Priority Level', colorScheme),
                      SizedBox(height: ResponsiveSize.height(8)),
                      EditorSimpleInfoField(
                        label: _selectedPriority.toString().split('.').last.capitalize(),
                        icon: Icons.flag_rounded,
                        color: _getPriorityColor(_selectedPriority),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveSize.height(24)),

            _buildSectionTitle('Select Priority', colorScheme),
            SizedBox(height: ResponsiveSize.height(8)),
            EditorPrioritySelectorSegmented(
              selectedPriority: _selectedPriority,
              onPrioritySelected: (priority) => setState(() => _selectedPriority = priority),
            ),
            SizedBox(height: ResponsiveSize.height(24)),

            _buildSectionTitle('Tags', colorScheme),
            SizedBox(height: ResponsiveSize.height(8)),
            tagsAsync.when(
              loading: () => Center(child: CustomLoader()),
              error: (_, __) => const EditorTagErrorState(),
              data: (tags) => EditorTagManagement(
                ref: ref,
                tags: tags,
                selectedTags: _selectedTags,
                onSelectionChanged: (selected) => setState(() => _selectedTags = selected),
                uuid: _uuid,
              ),
            ),
            SizedBox(height: ResponsiveSize.height(24)),

            _buildSectionTitle('Task Status', colorScheme),
            SizedBox(height: ResponsiveSize.height(8)),
            EditorStatusSegmented(
              selectedStatus: _selectedStatus,
              onStatusChanged: (status) => setState(() => _selectedStatus = status),
            ),
            SizedBox(height: ResponsiveSize.height(32)),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, ColorScheme cs) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () => Navigator.pop(context),
        child: Text('Cancel', style: TextStyle(color: cs.primary, fontSize: 16)),
      ),
      title: Text(
        widget.task == null ? 'New Task' : 'Edit Task',
        style: TextStyle(fontWeight: FontWeight.w600, color: cs.onSurface),
      ),
      centerTitle: true,
      actions: [
        CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _isSaving ? null : _saveTask,
          child: _isSaving
              ? const CustomLoader()
              : Text('Done', style: TextStyle(color: cs.primary, fontWeight: FontWeight.w600)),
        ),
        const SizedBox(width: 12),
      ],
    );
  }

  Widget _buildSectionTitle(String title, ColorScheme cs) {
    return Text(
      title,
      style: TextStyle(
        fontSize: ResponsiveSize.fontSize(15),
        fontWeight: FontWeight.w500,
        color: cs.onSurfaceVariant,
      ),
    );
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return Colors.red;
      case TaskPriority.medium:
        return Colors.orange;
      case TaskPriority.low:
        return Colors.blue;
    }
  }

  Future<void> _saveTask() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final task = Task(
        id: widget.task?.id ?? _uuid.v4(),
        listId: widget.listId,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        dueDate: _selectedDueDate,
        priority: _selectedPriority,
        status: _selectedStatus,
        createdAt: widget.task?.createdAt ?? DateTime.now(),
        tags: _selectedTags,
      );

      if (widget.task == null) {
        await ref.read(taskRepositoryProvider).createTask(task);
        if (mounted) showCustomToast(context, message: 'Task created successfully!', isSuccess: true);
      } else {
        await ref.read(taskRepositoryProvider).updateTask(task);
        if (mounted) showCustomToast(context, message: 'Task updated successfully!', isSuccess: true);
      }

      ref.invalidate(tasksProvider(widget.listId));
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      setState(() => _isSaving = false);
      if (mounted) {
        showCustomToast(context, message: 'Error saving task: $e', isSuccess: false);
      }
    }
  }
}
