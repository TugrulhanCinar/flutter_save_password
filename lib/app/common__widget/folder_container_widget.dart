import 'package:flutter/material.dart';

class FolderContainer extends StatelessWidget {
  final double margin;
  final Color color;
  final String containerName;
  final GestureTapCallback onTap;

  FolderContainer({
    Key key,
    this.margin: 15,
    this.color: Colors.deepOrange,
    this.containerName: "SosyalMedyaaaaaa",
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return buildBody(context);
  }

  GestureDetector buildBody(BuildContext context) {
    return GestureDetector(
      child: buildContainerAndText(context),
      onTap: onTap,
    );
  }

  Column buildContainerAndText(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 90,
          child: buildFolderContainer,
        ),
        Expanded(
          flex: 10,
          child: folderTextButton(context),
        ),
      ],
    );
  }

  Container get buildFolderContainer {
    return Container(
      margin: EdgeInsets.all(margin),
      // child: _centerTitle(context),
      decoration: _boxDecoration,
    );
  }

  Text folderTextButton(BuildContext context) {
    return Text(
      containerName,
      style: Theme.of(context).textTheme.bodyText2,
    );
  }

  BoxDecoration get _boxDecoration => BoxDecoration(
        color: color,
        boxShadow: _boxShadow,
        borderRadius: _borderRadius,
      );

  List<BoxShadow> get _boxShadow => [
        BoxShadow(
          color: Colors.grey.withOpacity(0.4),
          spreadRadius: 3,
          blurRadius: 2,
          offset: Offset(0, 3), // changes position of shadow
        ),
      ];

  BorderRadius get _borderRadius => BorderRadius.only(
      topLeft: _radius(30), bottomLeft: _radius(15), topRight: _radius(10));

  Radius _radius(double radius) => Radius.circular(radius);
}
