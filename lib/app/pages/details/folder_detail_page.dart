import 'package:flutter/material.dart';
import 'package:flutter_save_password/app/common__widget/account_model.dart';
import 'package:flutter_save_password/app/common__widget/custom_app_bar.dart';
import 'file:///E:/flutterProject/flutter_save_password/lib/app/pages/add/adding_account.dart';
import 'file:///E:/flutterProject/flutter_save_password/lib/app/pages/details/folder_settings_page.dart';
import 'package:flutter_save_password/models/account_model.dart';
import 'package:flutter_save_password/models/folder_model.dart';
import 'package:flutter_save_password/extensions/context_extension.dart';
import 'package:flutter_save_password/view_model/save_password_view_model.dart';
import 'package:provider/provider.dart';

class FolderDetailPage extends StatefulWidget {

  final int folderIndex;

  const FolderDetailPage({Key key, @required this.folderIndex})
      : super(key: key);

  @override
  _FolderDetailPageState createState() => _FolderDetailPageState();
}

class _FolderDetailPageState extends State<FolderDetailPage> {
  Folder folder;

  @override
  Widget build(BuildContext context) {
    folder = folder ??
        Provider.of<PasswordSaveViewModel>(context).folders[widget.folderIndex];

    return Scaffold(
      appBar: buildCustomAppBar(context),
      body: buildListView,
    );
  }

  @override
  void initState() {
    super.initState();
    //folder = widget.folder;
  }

  CustomAppBar buildCustomAppBar(BuildContext context) {
    return CustomAppBar(
      folder.folderName,
      actions: appBarActions(context),
    );
  }

  List<Widget> appBarActions(BuildContext context) {
    return [
      appBarAddingActions(context),
      appBarSettingsAction,
    ];
  }

  IconButton appBarAddingActions(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.add),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddingAccountPage(
              folder: folder,
            ),
          ),
        );
      },
    );
  }

  IconButton get appBarSettingsAction {
    return IconButton(
      icon: Icon(Icons.settings),
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => FolderSetingsPage(
                      folder: folder,
                    )));
      },
    );
  }

  ListView get buildListView {
    return ListView.separated(
      itemBuilder: (contextt, index) {
        return AccountModelWidget(
          folderIndex: widget.folderIndex,
          accountIndex: index,
        );
      },
      separatorBuilder: (context, index) {
        return context.customLowDivider;
      },
      itemCount: folder.accounts.length,
    );
  }

  accountFavOnTap(Account account) {
    Provider.of<PasswordSaveViewModel>(context, listen: false)
        .updateFavoriteState(account);
  }

  accountFavDeleteTap(Account account) {
    Provider.of<PasswordSaveViewModel>(context, listen: false)
        .deleteAccount(account);
  }
}
