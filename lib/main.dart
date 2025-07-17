import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ExpenzoApp());
}

class ExpenzoApp extends StatelessWidget {
  const ExpenzoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expenzo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE91E63),
          brightness: Brightness.light,
        ),
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
      ),
      home: const ResponsiveWrapper(child: HomeScreen()),
    );
  }
}

class ResponsiveWrapper extends StatelessWidget {
  final Widget child;
  
  const ResponsiveWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Set responsive breakpoints
        final screenWidth = constraints.maxWidth;
        
        // Store screen size in theme extension for global access
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaleFactor: _getTextScaleFactor(screenWidth),
          ),
          child: child,
        );
      },
    );
  }

  double _getTextScaleFactor(double screenWidth) {
    if (screenWidth < 360) return 0.85; // Small phones
    if (screenWidth < 414) return 0.9;  // Medium phones
    if (screenWidth < 768) return 1.0;  // Large phones
    return 1.1; // Tablets
  }
}
