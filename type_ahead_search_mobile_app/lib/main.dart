import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'app/core/theme/app_theme.dart';
import 'app/routes/app_pages.dart';
import 'app/services/dio_service.dart';
import 'app/services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Enable image caching with size restrictions
  PaintingBinding.instance.imageCache.maximumSizeBytes = 100 * 1024 * 1024; // 100 MB
  
  // Initialize services
  await initServices();
  
  runApp(const MyApp());
}

Future<void> initServices() async {
  // Initialize dio service
  Get.put<DioService>(DioService.init(), permanent: true);
  
  // Initialize storage service
  await Get.putAsync(() => StorageService.init());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'SeatGeek EventEntity Finder',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 200),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
 
      smartManagement: SmartManagement.full, // Dispose controllers when not in use
      // Default global settings to reduce animation jank
      defaultGlobalState: false,
    );
  }
}