import 'package:flutter/material.dart';
import 'package:flutter_save_password/app/common__widget/custom_app_bar.dart';
import 'package:flutter_save_password/extensions/context_extension.dart';
import 'package:flutter_save_password/extensions/color_extension.dart';
import 'package:flutter_save_password/models/folder_model.dart';
import 'package:flutter_save_password/view_model/save_password_view_model.dart';
import 'package:provider/provider.dart';

class AddingFolderPage extends StatefulWidget {
  @override
  _AddingFolderPageState createState() => _AddingFolderPageState();
}

class _AddingFolderPageState extends State<AddingFolderPage> {
  final buttonText = "Oluştur";
  final labelText = "Dosya ismi";
  final appBarTitle = "Klasör Oluştur";
  final _scafoldKey = GlobalKey<ScaffoldState>();
  final _textEditingController = TextEditingController();
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scafoldKey,
      appBar: appBar,
      body: _columnBody,
    );
  }

  Widget get appBar => CustomAppBar(appBarTitle);

  Widget get _columnBody => Container(
        padding: context.paddingAllLowMedium,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _textField,
            context.emptylowMediumValueWidget,
            _selectColorsWidget,
            context.emptylowMediumValueWidget,
            _createButton,
          ],
        ),
      );

  Widget get _createButton => RaisedButton(
        color: Colors.deepOrange,
        onPressed: _createButtonOnTap,
        child: _createButtonContainer,
      );

  Widget get _createButtonContainer => Container(
        width: context.width,
        alignment: Alignment.center,
        child: _createButtonContainerText,
      );

  Widget get _createButtonContainerText => Text(buttonText,
      style: context.theme.textTheme.subtitle1.copyWith(color: Colors.white));

  Widget get _textField => TextField(
        maxLength: 10,
        controller: _textEditingController,
        style: TextStyle(color: Colors.red),
        maxLines: 15,
        minLines: 1,
        decoration:
            context.customInputDecoration(labelText, color: Colors.deepOrange),
      );

  Widget get _selectColorsWidget => Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: Theme.of(context)
          .colorScheme
          .allFolderColor
          .asMap()
          .map((key, value) => MapEntry(
              key,
              InkWell(
                onTap: () {
                  setState(() {
                    selectedIndex = key;
                  });
                },
                child: Padding(
                  padding: context.paddingAllLowValue,
                  child: CircleAvatar(
                    child:
                        key == selectedIndex ? Icon(Icons.check) : Container(),
                    backgroundColor: value,
                  ),
                ),
              )))
          .values
          .toList());

  SnackBar snackBar(String text) =>  SnackBar(
    backgroundColor: Theme.of(context).colorScheme.genelRenk,
    content: Row(
      children: <Widget>[
        Icon(Icons.thumb_up),
        SizedBox(
          width: 20,
        ),
        Expanded(
          child: Text(text),
        ),
      ],
    ),
  );

  void _createButtonOnTap() async {
    String text = _textEditingController.text;
    if (text.length > 1 && text.length < 15) {
      final folder = Provider.of<PasswordSaveViewModel>(context, listen: false);
      var selectedColor = context.theme.colorScheme.allFolderColor[selectedIndex];
      var result = await folder.saveFolder(Folder(_textEditingController.text, selectedColor));
      if (result) {
        Navigator.pop(context);
      }
    }
  }

}
