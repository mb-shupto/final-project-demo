import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'providers/inventory_provider.dart';
import 'screens/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } on UnsupportedError catch (e) {
    // Log and continue — this avoids a hard crash while you configure Firebase for this platform.
    // Note: Firestore calls will likely fail until proper platform options are provided.
    // You can print, log, or handle this as needed.
    debugPrint('Firebase initialization skipped: $e');
  } catch (e) {
    // Other initialization errors
    debugPrint('Firebase initialization error: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => InventoryProvider(),
      child: MaterialApp(
        title: 'Store Inventory Tracker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 4,
          ),
        ),
        home: const DashboardScreen(),
      ),
    );
  }
}
