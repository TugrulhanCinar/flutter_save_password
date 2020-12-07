import 'package:flutter/material.dart';
import 'package:flutter_save_password/app/common__widget/account_model.dart';
import 'package:flutter_save_password/models/account_model.dart';
import 'package:flutter_save_password/extensions/context_extension.dart';
import 'package:flutter_save_password/view_model/save_password_view_model.dart';
import 'package:provider/provider.dart';

class FavoriteAccountsPage extends StatefulWidget {
  @override
  _FavoriteAccountsPageState createState() => _FavoriteAccountsPageState();
}

class _FavoriteAccountsPageState extends State<FavoriteAccountsPage> {
  List<Account> favoriteAccountList;

  @override
  Widget build(BuildContext context) {
    final String appbarText = "Favoriler";

    return Scaffold(
      appBar: context.appBar(
        appbarText,
      ),
      body: Consumer<PasswordSaveViewModel>(
        builder: (context, cart, child) {

          if (cart.state == PasswordState.Busy) {
            return CircularProgressIndicator();
          } else {
            favoriteAccountList = cart.allFavoriteAccount;
            return buildListView;
          }
        },
      ),
    );
  }

  ListView get buildListView {
    return ListView.separated(
      itemCount: favoriteAccountList.length,
      separatorBuilder: (context, index) => context.emptylowMediumValueWidget,
      itemBuilder: (context, index) => buildAccountModel(index, context),
    );
  }

  AccountModelWidget buildAccountModel(int index, BuildContext context) =>
      AccountModelWidget(
        account: favoriteAccountList[index],
        context: context,
        customTitle: favoriteAccountList[index].folderName,
      );
}
