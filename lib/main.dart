import 'package:matic_wallet/data/repository/account_repository.dart';
import 'package:matic_wallet/model/wallet_model.dart';
import 'package:matic_wallet/pages/home/home_page.dart';
import 'package:matic_wallet/pages/login_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:matic_wallet/pages/profile_page.dart';

Future<void> main() async {
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  MaterialColor getMaterialColor(Color color) {
    final int red = color.red;
    final int green = color.green;
    final int blue = color.blue;
    final Map<int, Color> shades = {
      50: Color.fromRGBO(red, green, blue, .1),
      100: Color.fromRGBO(red, green, blue, .2),
      200: Color.fromRGBO(red, green, blue, .3),
      300: Color.fromRGBO(red, green, blue, .4),
      400: Color.fromRGBO(red, green, blue, .5),
      500: Color.fromRGBO(red, green, blue, .6),
      600: Color.fromRGBO(red, green, blue, .7),
      700: Color.fromRGBO(red, green, blue, .8),
      800: Color.fromRGBO(red, green, blue, .9),
      900: Color.fromRGBO(red, green, blue, 1),
    };
    return MaterialColor(color.value, shades);
  }

  @override
  Widget build(BuildContext context) {
    List<WalletModel> accounts = AccountRepository.fetchWallet();
    if (kDebugMode) {
      print(accounts);
    }
    return GetMaterialApp(
      title: 'Matic Wallet',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        // primarySwatch: getMaterialColor(const Color(0xFF141414)),
        // useMaterial3: true,
      ),
      home: accounts.isNotEmpty ? const MainPage() : const LoginPage(),
      // home: accounts.isNotEmpty ? const HomePage() : const LoginPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int index = 0;
  final screens = [
    const HomePage(),
    const ProfilePage(),
    const ProfilePage(),
    const ProfilePage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: index, children: screens),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
            indicatorColor: Colors.blue.shade100,
            labelTextStyle: MaterialStateProperty.all(
              const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            )),
        child: NavigationBar(
          height: 60,
          backgroundColor: const Color(0xFFf1f5fb),
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          animationDuration: const Duration(seconds: 1),
          selectedIndex: index,
          onDestinationSelected: (index) => setState(() => this.index = index),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.favorite_outline),
              selectedIcon: Icon(Icons.favorite),
              label: 'Feed',
            ),
            NavigationDestination(
              icon: Icon(Icons.chat_bubble_outline),
              selectedIcon: Icon(Icons.chat_bubble),
              label: 'Chat',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Profile',
            )
          ],
        ),
      ),
    );
  }
}
