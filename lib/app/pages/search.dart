import 'package:flutter/material.dart';
import 'package:flutter_save_password/app/common__widget/account_model.dart';
import 'package:flutter_save_password/models/account_model.dart';
import 'package:flutter_save_password/view_model/save_password_view_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'file:///E:/flutterProject/flutter_canli_skor/lib/extensions/context_extension.dart';

class AccountSearch extends SearchDelegate<Account> {
  List<Account> _accounts;
  final BuildContext context;
  AccountSearch(this.context);

  final formatter = DateFormat('dd-MM-yyyy');


  @override
  List<Widget> buildActions(BuildContext context) {
    //addAllCurrentMatch();
    return [
      buildActionsIconButton
    ];
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

  @override
  Widget buildSuggestions(BuildContext context) {
    final passwordModel = Provider.of<PasswordSaveViewModel>(this.context);
    _accounts = passwordModel.allAccount;
    final mylist = query.isEmpty
        ? _accounts
        : _accounts
            .where(
              (element) =>
                  element.accountName.toLowerCase().contains(query.toLowerCase()))
            .toList();
    return mylist.isEmpty
        ? buildCenter(context)
        : _buildSuggestionsListView(mylist);
  }

  Center buildCenter(BuildContext context) {
    return Center(
          child: Text('No result Found...',
              style: context.theme.textTheme.headline5
                  .copyWith(color: Colors.black)),
        );
  }

  ListView _buildSuggestionsListView(List<Account> mylist) {
    return ListView.separated(
          shrinkWrap: true,
          itemCount: mylist.length,
          itemBuilder: (BuildContext context, int index) {
            return AccountModelWidget(
              account: mylist[index],
              customTitle: mylist[index].folderName,
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return context.customDivider;
          },
        );
  }

}
