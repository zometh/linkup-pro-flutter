import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:linkup_pro/core/widgets/custom_text.dart';

class NoDataWidget extends StatefulWidget {
  const NoDataWidget({super.key});

@override
State<NoDataWidget> createState() => _NoDataWidgetState();

}
class _NoDataWidgetState extends State<NoDataWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 50),
          Icon(
            Icons.inbox,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 20),
           CustomText(text: "no_data_found".tr(), fontSize: 15),
          const SizedBox(height: 20),
          IconButton(onPressed: () => setState(() {

          }), icon: Icon(FontAwesomeIcons.arrowsRotate))
        ],
      ),
    );
  }
}
