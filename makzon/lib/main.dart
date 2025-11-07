import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart'; // <-- السطر 1: استيراد

// --- استيراد النماذج (Models) ---
import 'app/modules/products/product_model.dart';
import 'app/modules/clients/client_model.dart';

// --- استيراد الشاشات والويدجتس ---
import 'app/widgets/custom_bottom_nav.dart';
import 'app/modules/home/home_screen.dart';
import 'app/modules/sales/sale_model.dart';
import 'app/modules/products/products_screen.dart';
import 'app/modules/sales/sales_screen.dart';
import 'app/modules/clients/clients_screen.dart';
import 'app/modules/reports/reports_screen.dart';
import 'app/modules/settings/settings_screen.dart';

Future<void> main() async {
  // 1. التأكد من تهيئة Flutter
  WidgetsFlutterBinding.ensureInitialized();

  // --- هذا هو الكود الجديد والمهم ---
  // 2. اطلب إذن الوصول إلى التخزين
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    await Permission.storage.request();
  }
  // ---------------------------------

  // 3. تهيئة Hive
  await Hive.initFlutter();

  // 4. تسجيل جميع "المحولات" (Adapters)
  Hive.registerAdapter(ProductAdapter());
  Hive.registerAdapter(ClientAdapter());
  Hive.registerAdapter(SaleAdapter());

  // 5. فتح جميع "الصناديق" (Boxes)
  await Hive.openBox<Product>('products');
  await Hive.openBox<Client>('clients');
  await Hive.openBox<Sale>('sales'); // <-- هذا السطر كان ناقصًا وأضفته

  // 6. تشغيل التطبيق
  runApp(const MakzonApp());
}

//
// ... باقي الكود الخاص بك يبقى كما هو بدون أي تغيير ...
//
class MakzonApp extends StatelessWidget {
  const MakzonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Makzon',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        fontFamily: 'Cairo',
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 1,
        ),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    ProductsScreen(),
    SalesScreen(),
    ClientsScreen(),
    ReportsScreen(),
    SettingsScreen(),
  ];

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTap: _onTap,
      ),
    );
  }
}
