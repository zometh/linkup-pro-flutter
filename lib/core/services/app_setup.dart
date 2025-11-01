

import 'package:app_links/app_links.dart';

import 'package:linkup_pro/core/services/get_it_setup.dart';

Future<void> setup() async{
  setupGetIt();


}
setupDeepLinking(){
  // AppLinks is singleton
  final appLinks = AppLinks();
  appLinks.uriLinkStream.listen((Uri? uri) {
    if (uri != null) {
      // Handle the deep link URI as needed
    }
  });
}

