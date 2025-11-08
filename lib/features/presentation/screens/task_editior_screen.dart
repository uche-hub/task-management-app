import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_management_app/core/enum/task_priority.dart';
import 'package:task_management_app/core/enum/task_status.dart';
import 'package:task_management_app/features/data/models/task_tag.dart';
import '../../../task_core.dart';
import '../widgets/task editor widgets/editor_tag_management.dart';
import '../widgets/task editor widgets/editor_priority_selector_segmented.dart'; 

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
            // --- Title Field ---
            Text(
              'Title',
              style: TextStyle(
                fontSize: ResponsiveSize.fontSize(15),
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: ResponsiveSize.height(8)),
            _buildInputField(
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

            // --- Description Field ---
            Text(
              'Description',
              style: TextStyle(
                fontSize: ResponsiveSize.fontSize(15),
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: ResponsiveSize.height(8)),
            _buildInputField(
              controller: _descriptionController,
              hintText: 'Enter task description',
              maxLines: 4,
            ),
            SizedBox(height: ResponsiveSize.height(24)),

            // --- Due Date & Priority Info ---
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildDueDateSection(context, colorScheme)),
                SizedBox(width: ResponsiveSize.width(16)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Priority Level',
                        style: TextStyle(
                          fontSize: ResponsiveSize.fontSize(15),
                          fontWeight: FontWeight.w500,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(height: ResponsiveSize.height(8)),
                      _buildSimpleInfoField(
                        context,
                        cs: colorScheme,
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

            // --- Priority Selector (Full width) ---
            Text(
              'Select Priority',
              style: TextStyle(
                fontSize: ResponsiveSize.fontSize(15),
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: ResponsiveSize.height(8)),
            EditorPrioritySelectorSegmented( 
              selectedPriority: _selectedPriority,
              onPrioritySelected: (priority) => setState(() => _selectedPriority = priority),
            ),
            SizedBox(height: ResponsiveSize.height(24)),

            // --- Tags ---
            Text(
              'Tags',
              style: TextStyle(
                fontSize: ResponsiveSize.fontSize(15),
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: ResponsiveSize.height(8)),
            tagsAsync.when(
              loading: () => Center(child: CustomLoader()),
              error: (_, __) => _buildTagErrorState(colorScheme), 
              data: (tags) => EditorTagManagement(
                ref: ref,
                tags: tags,
                selectedTags: _selectedTags,
                onSelectionChanged: (selected) => setState(() => _selectedTags = selected),
                uuid: _uuid,
              ),
            ),
            SizedBox(height: ResponsiveSize.height(24)),

            // --- Status Selector (RE-ADDED SECTION) ---
            Text(
              'Task Status',
              style: TextStyle(
                fontSize: ResponsiveSize.fontSize(15),
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: ResponsiveSize.height(8)),
            _buildStatusSegmentedControl(colorScheme),
            
            SizedBox(height: ResponsiveSize.height(32)),
          ],
        ),
      ),
    );
  }

  // --- UI Helper Methods ---

  AppBar _buildAppBar(BuildContext context, ColorScheme cs) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () => Navigator.pop(context),
        child: Text(
          'Cancel',
          style: TextStyle(
            color: cs.primary,
            fontSize: ResponsiveSize.fontSize(16),
          ),
        ),
      ),
      title: Text(
        widget.task == null ? 'New Task' : 'Edit Task',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: ResponsiveSize.fontSize(18),
          color: cs.onSurface,
        ),
      ),
      centerTitle: true,
      actions: [
        CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _isSaving ? null : _saveTask,
          child: _isSaving
              ? SizedBox(
                  width: ResponsiveSize.width(24),
                  height: ResponsiveSize.height(24),
                  child: CustomLoader(),
                )
              : Text(
                  'Done',
                  style: TextStyle(
                    color: cs.primary,
                    fontSize: ResponsiveSize.fontSize(16),
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
        SizedBox(width: ResponsiveSize.width(12)),
      ],
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    String? hintText,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(ResponsiveSize.radius(12)),
        border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        style: TextStyle(
          fontSize: ResponsiveSize.fontSize(16),
          color: colorScheme.onSurface,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7)),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: ResponsiveSize.width(16),
            vertical: ResponsiveSize.height(14),
          ),
        ),
        validator: validator,
        textCapitalization: TextCapitalization.sentences,
      ),
    );
  }

  Widget _buildSimpleInfoField(
    BuildContext context, {
    required ColorScheme cs,
    required String label,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveSize.width(16),
        vertical: ResponsiveSize.height(12),
      ),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(ResponsiveSize.radius(12)),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: ResponsiveSize.fontSize(16),
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
          Icon(
            icon,
            size: ResponsiveSize.icon(20),
            color: color.withValues(alpha: 0.7),
          ),
        ],
      ),
    );
  }

  Widget _buildDueDateSection(BuildContext context, ColorScheme cs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Due date',
          style: TextStyle(
            fontSize: ResponsiveSize.fontSize(15),
            fontWeight: FontWeight.w500,
            color: cs.onSurfaceVariant,
          ),
        ),
        SizedBox(height: ResponsiveSize.height(8)),
        GestureDetector(
          onTap: () => _pickDueDate(context),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveSize.width(16),
              vertical: ResponsiveSize.height(12),
            ),
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(ResponsiveSize.radius(12)),
              border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedDueDate == null
                        ? 'Select date'
                        : DateFormat('dd MMM').format(_selectedDueDate!),
                    style: TextStyle(
                      fontSize: ResponsiveSize.fontSize(16),
                      fontWeight: FontWeight.w500,
                      color: _selectedDueDate == null ? cs.onSurfaceVariant : cs.onSurface,
                    ),
                  ),
                ),
                Icon(
                  Icons.calendar_today_rounded,
                  size: ResponsiveSize.icon(20),
                  color: cs.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _pickDueDate(BuildContext context) async {
    final now = DateTime.now();
    final initialDate = _selectedDueDate ?? now;

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: now,
      lastDate: DateTime(now.year + 5),
      builder: (context, child) {
        final cs = Theme.of(context).colorScheme;
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: cs.copyWith(
              primary: cs.primary,
              onPrimary: Colors.white, 
              surface: cs.surface, 
              onSurface: cs.onSurface, 
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: cs.primary, 
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && pickedDate != _selectedDueDate) {
      setState(() => _selectedDueDate = pickedDate);
    }
  }

  Widget _buildStatusSegmentedControl(ColorScheme cs) {
    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(ResponsiveSize.radius(16)),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: SegmentedButton<TaskStatus>(
        segments: TaskStatus.values.map((status) {
          final label = status.toString().split('.').last.capitalize();
          final icon = status == TaskStatus.done ? Icons.check_circle_rounded : status == TaskStatus.inProgress ? Icons.pending_rounded : Icons.radio_button_unchecked_rounded;
          
          return ButtonSegment(
            value: status,
            label: Text(label, style: TextStyle(fontSize: ResponsiveSize.fontSize(14))),
            icon: Icon(icon, size: ResponsiveSize.icon(18)),
          );
        }).toList(),
        selected: {_selectedStatus},
        onSelectionChanged: (Set<TaskStatus> newSelection) {
          setState(() => _selectedStatus = newSelection.first);
        },
        style: SegmentedButton.styleFrom(
          selectedBackgroundColor: cs.primary,
          selectedForegroundColor: Colors.white,
          side: BorderSide.none,
          padding: EdgeInsets.symmetric(vertical: ResponsiveSize.height(8)),
          textStyle: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildTagErrorState(ColorScheme cs) {
    return Container(
      padding: EdgeInsets.all(ResponsiveSize.width(16)),
      decoration: BoxDecoration(
        color: cs.errorContainer.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(ResponsiveSize.radius(12)),
        border: Border.all(color: cs.error),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline_rounded, color: cs.error),
          SizedBox(width: ResponsiveSize.width(12)),
          Text(
            'Could not load tags',
            style: TextStyle(color: cs.error, fontSize: ResponsiveSize.fontSize(15)),
          ),
        ],
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

  // --- SAVE TASK (Core Logic) ---
  Future<void> _saveTask() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

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
        status: _selectedStatus, // Using selected status
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
      
      if (mounted) {
        Navigator.pop(context, true); 
      }
    } catch (e) {
      setState(() => _isSaving = false);
      if (mounted) {
        showCustomToast(context, message: 'Error saving task: ${e.toString()}', isSuccess: false);
      }
    }
  }
}