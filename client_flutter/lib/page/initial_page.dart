import 'package:client_flutter/private/setting/image_path.dart';
import 'package:client_flutter/private/style/color_style.dart';
import 'package:client_flutter/private/style/size_style.dart';
import 'package:client_flutter/private/style/space_style.dart';
import 'package:client_flutter/private/widget/image/any_image_widget.dart';
import 'package:flutter/material.dart';

class InitialPage extends StatelessWidget {
  const InitialPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double logoSize = SizeStyle.cardBasic.width * 0.8, logoMaxSize = MediaQuery.of(context).size.width / 3;
    final Widget logoWidget = AnyImageWidget(imageColor: ColorStyle.secondary, iconSize: logoMaxSize < logoSize ? logoMaxSize : logoSize, image: ImagePath.logoTransparent);

    return Scaffold(
      backgroundColor: ColorStyle.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: SpaceStyle.allBig,
                constraints: BoxConstraints(maxWidth: logoMaxSize, maxHeight: logoSize),
                child: logoWidget,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
