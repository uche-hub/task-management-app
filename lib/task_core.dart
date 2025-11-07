
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

/// ---------- WIDGETS IMPORT --------------- ///
export 'package:task_management_app/features/presentation/widgets/create_list_dialog.dart';
export 'package:task_management_app/features/presentation/widgets/delete_confirmation_dialog.dart';
export 'package:task_management_app/features/presentation/widgets/empty_state.dart';
export 'package:task_management_app/features/presentation/widgets/error_state.dart';
export 'package:task_management_app/features/presentation/widgets/list_card.dart';
export 'package:task_management_app/features/presentation/widgets/lists_fab.dart';
export 'package:task_management_app/features/presentation/widgets/shimmer_loading.dart';

/// ---------- ROUTER IMPORT --------------- ///
export 'package:task_management_app/router/router.dart';
export 'package:task_management_app/router/router_path.dart';