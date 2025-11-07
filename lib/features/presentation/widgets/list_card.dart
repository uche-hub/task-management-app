import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../task_core.dart';

class ListCard extends StatelessWidget {
  final TaskList list;
  final VoidCallback onTap;
  final VoidCallback onRename;
  final VoidCallback onDelete;

  const ListCard({
    super.key,
    required this.list,
    required this.onTap,
    required this.onRename,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final delay = 400 + (50 * (list.id.hashCode % 5));

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: delay),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      builder: (_, value, child) => Transform.translate(
        offset: Offset(0, ResponsiveSize.height(50) * (1 - value)),
        child: Opacity(opacity: value, child: child),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: ResponsiveSize.width(4)),
          decoration: _cardDecoration(cs),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(ResponsiveSize.width(24)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: ResponsiveSize.width(24),
                  vertical: ResponsiveSize.height(18),
                ),
                leading: _avatar(cs),
                title: Text(
                  list.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: ResponsiveSize.fontSize(18),
                    letterSpacing: -0.3,
                  ),
                ),
                subtitle: _subtitle(),
                trailing: _popup(cs),
              ),
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration(ColorScheme cs) => BoxDecoration(
        borderRadius: BorderRadius.circular(ResponsiveSize.width(24)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.95),
            Colors.white.withOpacity(0.85),
          ],
        ),
        boxShadow: [
          BoxShadow(color: cs.primary.withOpacity(0.15), blurRadius: 20, offset: const Offset(0, 8)),
          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 2)),
        ],
        border: Border.all(color: Colors.white.withOpacity(0.4), width: 1.5),
      );

  Widget _avatar(ColorScheme cs) => Hero(
        tag: 'list-avatar-${list.id}',
        child: Container(
          padding: EdgeInsets.all(ResponsiveSize.width(12)),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(colors: [cs.primary, cs.primary.withOpacity(0.8)]),
            boxShadow: [
              BoxShadow(color: cs.primary.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 4)),
            ],
          ),
          child: const Icon(Icons.format_list_bulleted_rounded, color: Colors.white, size: 28),
        ),
      );

  Widget _subtitle() => Padding(
        padding: EdgeInsets.only(top: ResponsiveSize.height(4)),
        child: Row(children: [
          Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
          SizedBox(width: ResponsiveSize.width(4)),
          Text(
            'Created ${_format(list.createdAt)}',
            style: TextStyle(color: Colors.grey[700], fontSize: ResponsiveSize.fontSize(13)),
          ),
        ]),
      );

  Widget _popup(ColorScheme cs) => PopupMenuButton<String>(
        icon: Icon(Icons.more_vert_rounded, color: Colors.grey[700]),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 10,
        itemBuilder: (_) => [
          _item('rename', 'Rename', Icons.edit_outlined, cs.primary),
          _item('delete', 'Delete', Icons.delete_outline, Colors.red),
        ],
        onSelected: (v) => v == 'rename' ? onRename() : onDelete(),
      );

  PopupMenuItem<String> _item(String value, String text, IconData icon, Color color) {
    return PopupMenuItem(
      value: value,
      child: Row(children: [
        Container(
          padding: EdgeInsets.all(ResponsiveSize.width(6)),
          decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, size: 18, color: color),
        ),
        SizedBox(width: ResponsiveSize.width(12)),
        Text(text,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                color: value == 'delete' ? Colors.red : null)),
      ]),
    );
  }

  String _format(DateTime d) {
    final diff = DateTime.now().difference(d);
    if (diff.inDays == 0) return 'today';
    if (diff.inDays == 1) return 'yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    return '${d.day}/${d.month}/${d.year}';
  }
}