import 'package:flutter/material.dart';
import 'package:flutter_save_password/extensions/color_extension.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String appTitle;
  final List<Widget> actions;
  final Widget leading;

  const CustomAppBar(this.appTitle, {Key key, this.actions, this.leading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: Theme.of(context).iconTheme,
      backgroundColor: Theme.of(context).colorScheme.genelRenk,
      leading: leading,
      actions: actions,
      title: Text(appTitle),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(55.0);
}
