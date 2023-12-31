import 'package:ecommerce_app_flutter/common/service/storage_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'firebase_options.dart';

class Global {
  static late StorageService storageService;
  static Future init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    storageService = await StorageService().init();
    bool isLaunched = await storageService.isFirstLaunch;

    print("Is app launched before $isLaunched");
  }
}
