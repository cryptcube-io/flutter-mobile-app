import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'services/logger_service.dart';
import 'adapters/app_info_hive_adapter.dart';
import 'presentation/pages/auth/signin_page.dart';
import 'presentation/pages/navbar/home_page.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  SystemChannels.textInput.invokeMethod('TextInput.hide');

  await LoggerService.initializeLogger();

  await Hive.initFlutter();
  Hive.registerAdapter(AppPrivacyInfoAdapter());
  
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OAuth Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const SignInPage(),
    );
  }
}