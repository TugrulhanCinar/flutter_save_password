import 'package:flutter/material.dart';
import 'package:flutter_save_password/app/common__widget/account_model.dart';
import 'package:flutter_save_password/app/common__widget/custom_app_bar.dart';
import 'package:flutter_save_password/models/account_model.dart';
import 'package:flutter_save_password/view_model/save_password_view_model.dart';
import 'package:provider/provider.dart';

class FavoritePage extends StatefulWidget {
  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final String appBarTitle = "Favoriler";
  late List<Account> favoriteAccount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(appBarTitle),
      body: buildBody,
    );
  }

  Consumer<PasswordSaveViewModel> get buildBody {
    return Consumer<PasswordSaveViewModel>(
      builder: (context, cart, child) {
        if (cart.state == PasswordState.Busy) {
          return circularProgressIndicator;
        } else {
          favoriteAccount = cart.allFavoriteAccount;
          return ListView.builder(
            itemCount: cart.allFavoriteAccount.length,
            itemBuilder: (BuildContext context, int index) {
              return AccountModelWidget(
                account: favoriteAccount[index],
                customTitle: favoriteAccount[index].folderName,
              );
            },
          );
        }
      },
    );
  }

  Widget get circularProgressIndicator =>
      Center(child: CircularProgressIndicator());
}
