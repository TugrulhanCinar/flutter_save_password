import 'package:flutter/material.dart';
import 'package:flutter_save_password/app/common__widget/account_model.dart';
import 'package:flutter_save_password/models/account_model.dart';
import 'package:flutter_save_password/extensions/context_extension.dart';
import 'package:flutter_save_password/view_model/save_password_view_model.dart';
import 'package:provider/provider.dart';

class PasswordSearch extends SearchDelegate<Account> {

  final BuildContext context;

  PasswordSearch(this.context);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [buildActionsIconButton];
  }

  IconButton get buildActionsIconButton {
    return IconButton(
      icon: Icon(Icons.clear),
      onPressed: () {
        query = "";
      },
    );
  }

  @override
  Widget buildLeading(BuildContext context) {

    return buildLeadingIconButton(context);
  }

  IconButton buildLeadingIconButton(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return null;
  }

  //todo
  @override
  Widget buildSuggestions(BuildContext context) {
    final passwordSaveViewModel = Provider.of<PasswordSaveViewModel>(this.context,listen: false);
    var _accounts = passwordSaveViewModel.allAccount;
    var myList = query.isEmpty
        ? _accounts
        : _accounts
        .where((element) =>
        element.accountName.toLowerCase().contains(query.toLowerCase()))
        .toList();
    print("_accounts uzunluk: " + _accounts.length.toString());
    return myList.isEmpty
        ? buildCenter(context)
        : _buildSuggestionsListView(myList);
  }

  Center buildCenter(BuildContext context) {
    return Center(
      child:
          Text('No result Found...', style: context.theme.textTheme.headline5),
    );
  }

  ListView _buildSuggestionsListView(List<Account> mylist) {
    return ListView.separated(

      itemCount: mylist.length,
      itemBuilder: (BuildContext context, int index) {
        return accountModel(context, mylist[index]);
      },
      separatorBuilder: (BuildContext context, int index) {
        return context.customHighDivider;
      },
    );
  }

  AccountModelWidget accountModel(BuildContext context, Account account) {
    return AccountModelWidget(
      context: context,
      account:account,
      customTitle: account.folderName,

    );
  }
}
