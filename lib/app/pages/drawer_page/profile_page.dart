import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_save_password/app/common__widget/custom_alert_dialog.dart';
import 'package:flutter_save_password/app/common__widget/custom_app_bar.dart';
import 'package:flutter_save_password/app/common__widget/custom_button.dart';
import 'package:flutter_save_password/app/helper/helper.dart';
import 'package:flutter_save_password/enums/assets/images/image_enums.dart';
import 'package:flutter_save_password/init/navigation/navigation_constants.dart';
import 'package:flutter_save_password/init/navigation/navigation_services.dart';
import 'package:flutter_save_password/view_model/user_view_model.dart';
import 'package:flutter_save_password/extensions/context_extension.dart';
import 'package:flutter_save_password/extensions/color_extension.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final String imageUrl =
      "https://miro.medium.com/max/1200/1*mk1-6aYaf_Bes1E3Imhc0A.jpeg";
  final picker = ImagePicker();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  File? _file;
  final String appTitle = "Profil";
  final String buttonText = "Kaydet";
  final String signOutButtonToolTip = "Çıkış";
  final String editImageButtonToolTip = "Resmi değiştir";
  final String userNameTextFormFieldLabelText = "User Name";
  final String userMailTextFormFieldLabelText = "Mail";
  String? userName, userMail, userPhoto;
  late bool chanceUserName;
  late bool chanceImage;

  var loadingGifLocaleUrl = "assets/";

  @override
  void initState() {
    super.initState();
    chanceUserName = false;
    chanceImage = false;
  }

  @override
  Widget build(BuildContext context) {
    final _userViewModel = Provider.of<UserViewModel>(context);
    if (userName == null) {
      userName = _userViewModel.user!.userName;
      userMail = _userViewModel.user!.userEmail;
      userPhoto = _userViewModel.user!.userPhotoNetwork;
    }
    return Scaffold(
      appBar: buildCustomAppBar,
      key: _scaffoldKey,
      body: Padding(
        padding: context.paddingAllLowMedium,
        child: ListView(
          children: [
            buildCircleAvatar,
            context.emptylowMediumValueWidget,
            buildMailTextFormField,
            context.emptylowMediumValueWidget,
            buildNameTextFormField,
            buildSaveButton,
          ],
        ),
      ),
    );
  }

  MyCustomButton get buildSaveButton => MyCustomButton(
        buttonText: buttonText,
        textColor: Colors.white,
        buttonColor: Theme.of(context).colorScheme.genelRenk,
        onTap: saveButtonOnTap,
      );

  CustomAppBar get buildCustomAppBar => CustomAppBar(
        appTitle,
        actions: appBarActions,
        leading: appbarLeadingButton,
      );

  Widget get appbarLeadingButton => IconButton(
        tooltip: signOutButtonToolTip,
        icon: Icon(Icons.arrow_back),
        onPressed: onWillPop,
      );

  void onWillPop() {
    if (chanceImage || chanceUserName) {
      MyCustomDialog(
        content:
            Text("Değişikliği kaydetmediniz devam etmek istiyor musunuz ? "),
        actions: onWillPopActions,
      ).goster(context);
    } else {
      Navigator.pop(context);
    }
  }

  List<Widget> get onWillPopActions => [buttonBar];

  Widget get buttonBar => ButtonBar(
        children: [
          MyCustomButton(
            buttonText: "Çık",
            onTap: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
          MyCustomButton(
            buttonText: "Vazgeç",
            onTap: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
        ],
      );

  List<Widget> get appBarActions => [
        IconButton(
          tooltip: signOutButtonToolTip,
          icon: Icon(Icons.exit_to_app),
          onPressed: appBarActionOnPress,
        )
      ];

  Widget get buildCircleAvatar => GestureDetector(
        onTap: editUserFoto,
        //child: ClipOval(child: _file == null ? buildFadeInImage : fileImage),
        child: Container(
          width: context.width / 3,
          height: context.height / 3,
          child: _file == null ? networkProfileImage : fileImage,
        ),
      );

  Widget get fileImage {
    return ClipOval(
      child: FadeInImage(
        placeholder: FileImage(_file!),
        fit: BoxFit.cover,
        image: FileImage(_file!),
      ),
    );
  }

  Widget get networkProfileImage => ClipOval(
        child: FadeInImage.assetNetwork(
          placeholder: LOADING_GIF,
          fit: BoxFit.cover,
          image: userPhoto!,
        ),
      );

  TextFormField get buildNameTextFormField => TextFormField(
        initialValue: userName,
        onChanged: (text) {
          chanceUserName = true;
          userName = text;
        },
        enabled: true,
        style: _textStyle,
        decoration: inputDecoration,
      );

  TextFormField get buildMailTextFormField => TextFormField(
        initialValue: userMail,
        enabled: false,
        style: _textStyle,
        decoration: inputDecoration,
      );

  TextStyle get _textStyle =>
      Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.redAccent);

  InputDecoration get inputDecoration => InputDecoration(
        labelStyle: TextStyle(color: Colors.redAccent),
        focusedBorder: _outlineInputBorder,
        enabledBorder: _outlineInputBorder,
        border: _outlineInputBorder,
      );

  OutlineInputBorder get _outlineInputBorder => OutlineInputBorder(
        borderSide: BorderSide(color: Colors.redAccent),
        borderRadius: context.borderLowRadiusHCircular,
      );

  appBarActionOnPress() {
    try {
      Provider.of<UserViewModel>(context, listen: false).signOut();
      NavigationServices.instance
          .navigateToPageClear(path: NavigationConstans.LANDING_PAGE);
    } catch (e) {
      MyCustomDialog(
        title: Center(child: Text("Hata")),
        content: Text("Bir hata oluştu: " + e.toString()),
        actions: [
          Container(
            padding: context.paddingAllLowMedium,
            width: context.width,
            child: MyCustomButton(
              buttonColor: Theme.of(context).colorScheme.genelRenk,
              buttonText: "Tamam",
              onTap: () {
                Navigator.pop(context);
              },
            ),
          )
        ],
      ).goster(context);
    }
  }

  editUserFoto() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return editUserfotoBody;
      },
    );
  }

  Container get editUserfotoBody => Container(
        height: context.height / 5,
        child: Column(
          children: [
            listTileCamera,
            context.customLowDivider,
            listTileGalery,
          ],
        ),
      );

  ListTile get listTileGalery => ListTile(
        leading: Icon(Icons.image),
        title: Text("Galeriden seç"),
        onTap: _galery,
      );

  ListTile get listTileCamera => ListTile(
        leading: Icon(Icons.camera),
        title: Text("Kameradan çek"),
        onTap: _camera,
      );

  _camera() async {
    var _image = await picker.getImage(source: ImageSource.camera);
    if (_image != null) {
      setState(() {
        _file = File(_image.path);
        chanceImage = true;
      });
    }
    Navigator.pop(context);
  }

  _galery() async {
    var _image = await picker.getImage(source: ImageSource.gallery);
    if (_image != null) {
      setState(() {
        _file = File(_image.path);
        chanceImage = true;
      });
    }
    Navigator.pop(context);
  }

  saveButtonOnTap() async {
    if (chanceUserName) {
      var userViewmodel = Provider.of<UserViewModel>(context, listen: false);
      var currentUser = userViewmodel.user!;
      currentUser.userName = userName;
      userViewmodel.updateUserData(currentUser);
    }
    if (chanceImage) {
      showDialogForLoading();
      var result = await Provider.of<UserViewModel>(context, listen: false)
          .updateUserImage(_file);
      Navigator.pop(context);
      result == null
          ? Helper.showDefaultSnackBar(context, "İşlem başarılı")
          : showCustomDialog();
    }
  }

  showCustomDialog() {
    MyCustomDialog(
      content: Text("Bir hata oluştu"),
      actions: [
        MyCustomButton(
          buttonText: "tamam",
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ],
    ).goster(context);
  }

  showDialogForLoading() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Container(
          width: context.width / 5,
          height: context.height / 5,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
