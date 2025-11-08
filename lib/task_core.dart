
library;

/// ----------- FLUTTER IMPORT ------------ ///
export 'package:flutter_riverpod/flutter_riverpod.dart';
export 'package:uuid/uuid.dart';
export 'package:intl/intl.dart';
export 'package:fluttericon/font_awesome_icons.dart';
export 'package:shimmer/shimmer.dart';
export 'package:sqflite/sqflite.dart';
export 'package:flutter_riverpod/legacy.dart';

/// ----------- FEATURES IMPORT ------------ ///
export 'package:task_management_app/features/data/models/tasks_model.dart';
export 'package:task_management_app/features/presentation/provider/task_repo_provider.dart';
export 'package:task_management_app/features/presentation/screens/search_screen.dart';
export 'package:task_management_app/features/presentation/screens/task_screen.dart';
export 'package:task_management_app/features/presentation/screens/task_editior_screen.dart';
export 'package:task_management_app/features/presentation/widgets/task_items.dart';
export 'package:task_management_app/features/data/repo/tasks_repo.dart';
export 'package:task_management_app/features/data/dao/tasks_dao.dart';

/// ----------- DATA IMPORT ------------ ///
export 'package:task_management_app/core/data/database_helper.dart';

/// ----------- SCREEN IMPORT -------------- ///
export 'package:task_management_app/features/presentation/screens/list_screen.dart';

/// ---------- UTILS IMPORT --------------- ///
export 'package:task_management_app/core/utils/app_responsiveness.dart';
export 'package:task_management_app/core/utils/extensions.dart'; 
export 'package:task_management_app/core/utils/custom_toast.dart'; 
export 'package:task_management_app/core/utils/custom_loader.dart';

/// ---------- THEME IMPORT --------------- ///
export 'package:task_management_app/core/theme/theme.dart';

/// ---------- WIDGETS IMPORT --------------- ///
export 'package:task_management_app/features/presentation/widgets/list%20screen%20widgets/create_list_dialog.dart';
export 'package:task_management_app/features/presentation/widgets/list%20screen%20widgets/delete_confirmation_dialog.dart';
export 'package:task_management_app/features/presentation/widgets/list%20screen%20widgets/empty_state.dart';
export 'package:task_management_app/features/presentation/widgets/list%20screen%20widgets/error_state.dart';
export 'package:task_management_app/features/presentation/widgets/list%20screen%20widgets/list_card.dart';
export 'package:task_management_app/features/presentation/widgets/list%20screen%20widgets/lists_fab.dart';
export 'package:task_management_app/features/presentation/widgets/shimmer_loading.dart';
export 'package:task_management_app/features/presentation/widgets/list%20screen%20widgets/list_app_bar.dart';
export 'package:task_management_app/features/presentation/widgets/list%20screen%20widgets/list_items_view.dart';
export 'package:task_management_app/features/presentation/widgets/search%20widgets/search_app_bar.dart';
export 'package:task_management_app/features/presentation/widgets/search%20widgets/search_result_list.dart';
export 'package:task_management_app/features/presentation/widgets/search%20widgets/search_empty.dart';
export 'package:task_management_app/features/presentation/widgets/search%20widgets/search_error.dart';
export 'package:task_management_app/features/presentation/widgets/search%20widgets/search_loading.dart';
export 'package:task_management_app/features/presentation/widgets/search%20widgets/search_no_results.dart';
export 'package:task_management_app/features/presentation/widgets/task%20editor%20widgets/editor_due_date_field.dart';
export 'package:task_management_app/features/presentation/widgets/task%20editor%20widgets/editor_input_field.dart';
export 'package:task_management_app/features/presentation/widgets/task%20editor%20widgets/editor_priority_selector_segmented.dart';
export 'package:task_management_app/features/presentation/widgets/task%20editor%20widgets/editor_simple_info_field.dart';
export 'package:task_management_app/features/presentation/widgets/task%20editor%20widgets/editor_status_segmented.dart';
export 'package:task_management_app/features/presentation/widgets/task%20editor%20widgets/editor_tag_error_state.dart';
export 'package:task_management_app/features/presentation/widgets/task%20editor%20widgets/editor_tag_management.dart';
export 'package:task_management_app/features/presentation/widgets/task%20screen%20widgets/error_state_widget.dart';
export 'package:task_management_app/features/presentation/widgets/task%20screen%20widgets/tag_filter_bar.dart';
export 'package:task_management_app/features/presentation/widgets/task%20screen%20widgets/task_header_appbar.dart';
export 'package:task_management_app/features/presentation/widgets/task%20screen%20widgets/task_list_view.dart';
export 'package:task_management_app/features/presentation/widgets/task_options_button.dart';

/// ---------- ROUTER IMPORT --------------- ///
export 'package:task_management_app/router/router.dart';
export 'package:task_management_app/router/router_path.dart';

/// ------------ ENUM IMPORTS ------------- ///
export 'package:task_management_app/core/enum/task_status.dart';
export 'package:task_management_app/core/enum/task_priority.dart';
export 'package:task_management_app/features/data/models/task_tag.dart';
export 'package:task_management_app/core/enum/sort_option.dart';
export 'package:task_management_app/core/enum/task_filter.dart';

/// ------------ MODEL IMPORT ----------- ///
export 'package:task_management_app/features/data/models/task_list.dart';

/// ----------- REPO IMPORT ------------- ///
export 'package:task_management_app/features/data/repo/list_task_stats.dart';

/// ------------ PROVIDER IMPORT -------------- ///
export 'package:task_management_app/features/presentation/provider/tasks_notifier.dart';
export 'package:task_management_app/features/presentation/provider/tag_notifier.dart';
