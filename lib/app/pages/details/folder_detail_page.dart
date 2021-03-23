import 'package:flutter/material.dart';
import 'package:flutter_save_password/app/common__widget/account_model.dart';
import 'package:flutter_save_password/app/common__widget/custom_app_bar.dart';
import 'package:flutter_save_password/init/navigation/navigation_constants.dart';
import 'package:flutter_save_password/init/navigation/navigation_services.dart';
import 'package:flutter_save_password/models/account_model.dart';
import 'package:flutter_save_password/models/folder_model.dart';
import 'package:flutter_save_password/extensions/context_extension.dart';
import 'package:flutter_save_password/view_model/save_password_view_model.dart';
import 'package:provider/provider.dart';

class FolderDetailPage extends StatefulWidget {
  final int? folderIndex;

  const FolderDetailPage({Key? key, required this.folderIndex})
      : super(key: key);

  @override
  _FolderDetailPageState createState() => _FolderDetailPageState();
}

class _FolderDetailPageState extends State<FolderDetailPage> {
  Folder? folder;

  @override
  Widget build(BuildContext context) {
    folder = folder ??
        Provider.of<PasswordSaveViewModel>(context).folders![widget.folderIndex!];

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
      folder!.folderName,
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
        NavigationServices.instance.navigateToPage(path: NavigationConstans.ADDING_ACCOUNT_PAGE,data: folder);
      },
    );
  }

  IconButton get appBarSettingsAction {
    return IconButton(
      icon: Icon(Icons.settings),
      onPressed: () {
        NavigationServices.instance.navigateToPage(path: NavigationConstans.FOLDER_SETTINGS_PAGE,data: folder);
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
      itemCount: folder!.accounts.length,
    );
  }


  accountFavDeleteTap(Account account) {
    Provider.of<PasswordSaveViewModel>(context, listen: false)
        .deleteAccount(account);
  }
}
