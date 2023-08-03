import 'package:flutter/material.dart';
import 'package:shopping/features/admin/services/admin_services.dart';

enum MenuProductOptions { preview, edit, delete }

class MenuProduct extends StatefulWidget {
  final VoidCallback onDelete;
  final VoidCallback onPreview;
  final VoidCallback onEdit;
  const MenuProduct(
      {super.key,
      required this.onPreview,
      required this.onEdit,
      required this.onDelete});

  @override
  State<MenuProduct> createState() => _MenuProductState();
}

class _MenuProductState extends State<MenuProduct> {
  MenuProductOptions? selectedMenu;
  final AdminServices adminServices = AdminServices();

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuProductOptions>(
      offset: const Offset(0, -140),
      initialValue: selectedMenu,
      // Callback that sets the selected popup menu item.
      onSelected: (MenuProductOptions item) {
        setState(() {
          selectedMenu = item;
        });
        if (selectedMenu == MenuProductOptions.delete) {
          widget.onDelete();
        } else if (selectedMenu == MenuProductOptions.preview) {
          widget.onPreview();
        } else if (selectedMenu == MenuProductOptions.edit) {
          widget.onEdit();
        }
      },
      itemBuilder: (BuildContext context) =>
          <PopupMenuEntry<MenuProductOptions>>[
        const PopupMenuItem<MenuProductOptions>(
          value: MenuProductOptions.preview,
          child: Text('Preview'),
        ),
        const PopupMenuItem<MenuProductOptions>(
          value: MenuProductOptions.edit,
          child: Text('Edit'),
        ),
        const PopupMenuItem<MenuProductOptions>(
          value: MenuProductOptions.delete,
          child: Text('Delete'),
        ),
      ],
    );
  }
}
