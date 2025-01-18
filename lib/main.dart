import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ud_app/upload_page.dart';
import 'package:ud_app/dashboard_page.dart';

void main() async {
  //setup supabase
  await Supabase.initialize(
    url: 'https://fzmgliviczwrxvoltxtq.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ6bWdsaXZpY3p3cnh2b2x0eHRxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzcyMTAxNzUsImV4cCI6MjA1Mjc4NjE3NX0.PRUEPl5bEX-cKur6PFlMY5gnt2Z3mMpSzhNBauGWaOA',
    debug: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Supabase',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => const UploadPage(),
        '/dashboard': (context) => const DashboardPage(),
      },
    );
  }
}
