// lib/task_core.dart

library;

/// ----------- FLUTTER IMPORT ------------ ///
export 'package:flutter_riverpod/flutter_riverpod.dart';
export 'package:uuid/uuid.dart';
export 'package:intl/intl.dart';
export 'package:fluttericon/font_awesome_icons.dart';
export 'package:shimmer/shimmer.dart';

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
export 'package:task_management_app/core/utils/extensions.dart'; // <--- ADDED
export 'package:task_management_app/core/utils/custom_toast.dart'; // <--- ADDED
export 'package:task_management_app/core/utils/custom_loader.dart'; // <--- ADDED

/// ---------- THEME IMPORT --------------- ///
export 'package:task_management_app/core/theme/theme.dart'; // <--- ADDED

/// ---------- WIDGETS IMPORT --------------- ///
export 'package:task_management_app/features/presentation/widgets/list%20screen%20widgets/create_list_dialog.dart';
export 'package:task_management_app/features/presentation/widgets/list%20screen%20widgets/delete_confirmation_dialog.dart';
export 'package:task_management_app/features/presentation/widgets/list%20screen%20widgets/empty_state.dart';
export 'package:task_management_app/features/presentation/widgets/list%20screen%20widgets/error_state.dart';
export 'package:task_management_app/features/presentation/widgets/list%20screen%20widgets/list_card.dart';
export 'package:task_management_app/features/presentation/widgets/list%20screen%20widgets/lists_fab.dart';
export 'package:task_management_app/features/presentation/widgets/shimmer_loading.dart';

/// ---------- ROUTER IMPORT --------------- ///
export 'package:task_management_app/router/router.dart';
export 'package:task_management_app/router/router_path.dart';