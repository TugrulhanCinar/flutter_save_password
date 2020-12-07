import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_save_password/app/common__widget/account_model.dart';
import 'package:flutter_save_password/app/pages/add_account_page.dart';
import 'package:flutter_save_password/extensions/context_extension.dart';
import 'package:flutter_save_password/models/account_model.dart';
import 'package:flutter_save_password/models/folder_model.dart';
import 'package:flutter_save_password/view_model/save_password_view_model.dart';
import 'package:provider/provider.dart';

import 'folder_settings_page.dart';

class DetailsPage extends StatefulWidget {
  // final Folder folder;
  final int folderIndex;

  const DetailsPage({Key key, this.folderIndex}) : super(key: key);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  List<Account> accountsList;
  Folder _folder;

  @override
  Widget build(BuildContext context) {
    final _savePasswordModel = Provider.of<PasswordSaveViewModel>(context);
    _folder = _savePasswordModel.folders[widget.folderIndex];
    accountsList = _folder.accounts;
    return Scaffold(
      appBar: context.appBar(
        _folder.folderName,
        actions: appBarActions,
      ),
      body: buildListView,
    );
  }

  ListView get buildListView {
    return ListView.separated(
      itemCount: accountsList.length,
      separatorBuilder: (context, index) => context.emptylowMediumValueWidget,
      itemBuilder: (context, index) => buildAccountModel(index, context),
    );
  }

  AccountModelWidget buildAccountModel(int index, BuildContext context) =>
      AccountModelWidget(
        account: accountsList[index],
        context: context,
      );

  List<Widget> get appBarActions => [appBarAddAction, appBarFolderSettings];

  IconButton get appBarAddAction {
    return IconButton(
      icon: Icon(Icons.add),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddAccountPage(folder: _folder),
          ),
        );
      },
    );
  }

  IconButton get appBarFolderSettings {
    return IconButton(
      icon: Icon(Icons.settings),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
             return FolderSetingsPage(
                folder: _folder,
              );
            },
          ),
        );
      },
    );
  }
}
