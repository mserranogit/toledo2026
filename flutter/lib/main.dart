import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/toledo_theme.dart';
import 'presentation/screens/main_shell.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Configurar barra de estado inmersiva
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(
    const ProviderScope(
      child: ToledoApp(),
    ),
  );
}

class ToledoApp extends StatelessWidget {
  const ToledoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toledo 2026',
      debugShowCheckedModeBanner: false,
      theme: ToledoTheme.lightTheme,
      home: const MainShell(),
    );
  }
}
