import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/chat_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/about_screen.dart'; // Import halaman About yang baru

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Pastikan URL dan Anon Key Supabase sudah kamu isi dengan benar
  await Supabase.initialize(
    url: 'https://xxxxxxxxxx.supabase.co',
    anonKey: 'copy-API-anonKeyAnda',
  );

  runApp(const SakuPintarApp());
}

class SakuPintarApp extends StatelessWidget {
  const SakuPintarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Saku Pintar',
      debugShowCheckedModeBanner: false, // Menghilangkan pita "DEBUG" di pojok kanan atas
      theme: ThemeData(
        primarySwatch: Colors.teal, 
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          elevation: 2,
        ),
      ),
      home: const MainNavigation(), // Kita mulai dari halaman navigasi utama
    );
  }
}

// Widget untuk mengelola Bottom Navigation Bar
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  // Index 0 = Dashboard, Index 1 = Chat, Index 2 = About
  int _selectedIndex = 0;

  // Daftar layar yang akan ditampilkan sesuai index
  final List<Widget> _screens = [
    const DashboardScreen(),
    const ChatScreen(),
    const AboutScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens, // IndexedStack menjaga state (memory) tiap layar agar tidak refresh terus saat pindah tab
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_rounded),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_rounded),
            label: 'Asisten AI',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_rounded),
            label: 'About',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey.shade400,
        backgroundColor: Colors.white,
        elevation: 10,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
      ),
    );
  }
}
