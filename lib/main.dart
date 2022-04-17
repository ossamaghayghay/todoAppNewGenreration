import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
// import 'package:todo/services/notification_services.dart';
import 'package:todo/services/theme_services.dart';
import 'package:todo/ui/pages/home_page.dart';
// import 'package:todo/ui/pages/notification_screen.dart';

import 'db/db_helper.dart';
import 'ui/theme.dart';
import 'package:timezone/data/latest.dart' as tz;

// import 'ui/pages/home_page.dart';

void main() async{
  // NotifyHelper().initializationNotification();
    WidgetsFlutterBinding.ensureInitialized();
    await   DBHelper.initDb();
    await  GetStorage.init();
    tz.initializeTimeZones();
    runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme:Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeServices().theme,
      debugShowCheckedModeBanner: false,
      home:const  HomePage(),
    );
  }
}
