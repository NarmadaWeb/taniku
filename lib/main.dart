import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/welcome_screen.dart';
import 'screens/home_screen.dart';
import 'screens/pustaka_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/history_screen.dart';
import 'screens/sawahku_screen.dart';
import 'screens/diagnosis_screens.dart';
import 'screens/calculator_screen.dart';
import 'providers/app_provider.dart';
import 'widgets/widgets.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);

    return MaterialApp(
      title: 'Taniku',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.backgroundLight,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.primaryDark,
          surface: AppColors.surfaceLight,
          background: AppColors.backgroundLight,
        ),
        textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme).apply(
          bodyColor: AppColors.textMainLight,
          displayColor: AppColors.textMainLight,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.backgroundDark,
         colorScheme: const ColorScheme.dark(
          primary: AppColors.primary,
          secondary: AppColors.primaryDark,
          surface: AppColors.surfaceDark,
          background: AppColors.backgroundDark,
        ),
        textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme).apply(
          bodyColor: AppColors.textMainDark,
          displayColor: AppColors.textMainDark,
        ),
        useMaterial3: true,
      ),
      themeMode: appProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const WelcomeScreen(),
      routes: {
        '/home': (context) => const MainScaffold(),
        '/welcome': (context) => const WelcomeScreen(),
        '/history': (context) => const HistoryScreen(),
        '/calculator': (context) => const CalculatorScreen(),
        '/diagnosis/step1': (context) => const DiagnosisStep1Screen(),
        '/diagnosis/step2': (context) => const DiagnosisStep2Screen(),
        '/diagnosis/step3': (context) => const DiagnosisStep3Screen(),
        '/diagnosis/result': (context) => const DiagnosisResultScreen(),
        '/fertilizer': (context) => const FertilizerScheduleScreen(),
      },
    );
  }
}

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const DiagnosisStep1Screen(), // Direct link to diagnosis start from nav? Or wrapper?
    // Usually tabs are "Home", "Diagnosa", "Sawahku", "Pustaka", "Profil"
    // But Diagnosa is a flow. Let's make the tab a "History/Start" wrapper or just start Step 1.
    // For now, let's put a placeholder that redirects or shows recent diagnosis.
    const DiagnosisLandingScreen(),
    const SawahkuScreen(),
    const PustakaScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

class DiagnosisLandingScreen extends StatelessWidget {
  const DiagnosisLandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // This could be a landing page for diagnosis, showing history and "Start New"
    // For now, let's just redirect to Step 1 or show a simple UI
    return Scaffold(
      appBar: AppBar(title: const Text('Diagnosa')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.health_and_safety, size: 80, color: AppColors.primary),
            const SizedBox(height: 20),
            const Text('Cek Kesehatan Tanaman Padi', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Reset diagnosis state
                Provider.of<AppProvider>(context, listen: false).resetDiagnosis();
                Navigator.pushNamed(context, '/diagnosis/step1');
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.black),
              child: const Text('Mulai Diagnosa Baru'),
            )
          ],
        ),
      ),
    );
  }
}
