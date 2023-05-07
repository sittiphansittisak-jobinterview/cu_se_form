import 'package:client_flutter/private/complex_widget/app_bar_widget.dart';
import 'package:flutter/material.dart';

class ApplicationFormPage extends StatelessWidget {
  const ApplicationFormPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const PreferredSizeWidget appBarWidget = AppBarWidget();
    
    return Scaffold(
      appBar: appBarWidget,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [],
          ),
        ),
      ),
    );
  }
}
