import 'package:aurora_v1/features/dashboard/domain/entities/plant.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

class GrowActionsPopupMenu {
  static OverlayEntry? _overlayEntry;

  static void show({
    required BuildContext context,
    required Offset position,
    required Plant grow,
  }) {
    _overlayEntry?.remove();

    final screenSize = MediaQuery.of(context).size;
    const double popupWidth = 164;
    const double popupHeight = 300;

    double dx = position.dx - popupWidth;
    double dy = position.dy;

    // Clamp to screen bounds
    if (dx < 8) dx = 8;
    if (dy + popupHeight > screenSize.height) {
      dy = screenSize.height - popupHeight - 8;
    }

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Dismiss area
          GestureDetector(
            onTap: dismiss,
            behavior: HitTestBehavior.translucent,
            child: Container(color: Colors.transparent),
          ),
          Positioned(
            left: dx,
            top: dy,
            width: popupWidth,
            child: Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildActionItem(
                    context,
                    title: 'Edit',
                    color: Colors.black,
                    onTap: () {
                      dismiss();
                      context.push('/strain/edit/confirm', extra: grow);
                    },
                  ),
                  _buildDivider(),
                  _buildActionItem(
                    context,
                    title: 'Add Grow',
                    color: Colors.black,
                    onTap: () {
                      dismiss();
                      context.push('/add_grow');
                    },
                  ),
                  _buildDivider(),
                  _buildActionItem(
                    context,
                    title: 'Share',
                    color: Colors.teal,
                    onTap: () {
                      Fluttertoast.showToast(
                        msg: "Share feature is not implemented yet.",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM,
                      );
                      dismiss();
                      // Insert sharing logic here
                    },
                  ),
                  _buildDivider(),
                  _buildActionItem(
                    context,
                    title: 'Delete',
                    color: Colors.red,
                    onTap: () {
                      dismiss();
                      context.push('/strain/delete', extra: grow);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  static Widget _buildActionItem(
    BuildContext context, {
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: () {
        dismiss();
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  static Widget _buildDivider() =>
      const Divider(thickness: 1, color: Colors.grey);

  static void dismiss() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
