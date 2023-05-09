import 'package:client_flutter/path/page_path.dart';
import 'package:client_flutter/private/complex_widget/drawer_widget.dart';
import 'package:client_flutter/private/setting/image_path.dart';
import 'package:client_flutter/private/style/color_style.dart';
import 'package:client_flutter/private/style/font_size_style.dart';
import 'package:client_flutter/private/style/sized_box_style.dart';
import 'package:client_flutter/private/style/space_style.dart';
import 'package:client_flutter/private/widget/card/image_card_widget.dart';
import 'package:client_flutter/private/widget/text/text_widget.dart';
import 'package:client_flutter/private/complex_widget/app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IndexPage extends StatelessWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const PreferredSizeWidget appBarWidget = AppBarWidget();
    const Widget drawerWidget = DrawerWidget();
    const Widget topicWidget = TextWidget(text: "ยินดีต้อนรับสู่ CU SE", color: ColorStyle.light, fontSize: FontSizeStyle.large, isBold: true);
    const Widget subTopicWidget = TextWidget(text: "กรุณาเลือกแบบฟอร์มที่ต้องการสร้าง", color: ColorStyle.light, fontSize: FontSizeStyle.basic);
    final Widget applicationFormMenuWidget = ImageCardWidget(title: 'แบบฟอร์มประกอบการสมัครหลักสูตร SE', bgColor: ColorStyle.applicationFormMenu, image: ImagePath.applicationFormMenu, onClick: () => Get.toNamed(PagePath.applicationForm));

    return Scaffold(
      appBar: appBarWidget,
      endDrawer: drawerWidget,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                alignment: Alignment.topCenter,
                padding: SpaceStyle.allBasic,
                color: ColorStyle.primary,
                width: double.infinity,
                child: Column(
                  children: const [
                    SizedBoxStyle.heightLarge,
                    topicWidget,
                    SizedBoxStyle.heightSmall,
                    subTopicWidget,
                    SizedBoxStyle.heightLarge,
                  ],
                ),
              ),
              SizedBoxStyle.heightBasic,
              Wrap(
                children: [
                  applicationFormMenuWidget,
                ].map((e) => Padding(padding: SpaceStyle.allBasic, child: e)).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
