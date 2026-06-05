import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/property/presentation/providers/property_provider.dart';
import 'features/property/presentation/pages/landing_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  /* 
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint("Firebase initialization failed: $e");
  }
  */

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PropertyProvider()),
      ],
      child: MaterialApp(
        title: 'PropeMange',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF004840), // propemange Green
            primary: const Color(0xFF004840),
          ),
          useMaterial3: true,
          fontFamily: 'OpenSans', // Common on property apps
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
          cardTheme: const CardThemeData(
            surfaceTintColor: Colors.white,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
          ),
        ),
        home: const LandingView(),
      ),
    );
  }
}
