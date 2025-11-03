import 'package:flutter/material.dart';
import 'app/widgets/custom_bottom_nav.dart';
import 'app/modules/home/home_screen.dart';
import 'app/modules/products/products_screen.dart';
import 'app/modules/sales/sales_screen.dart';
import 'app/modules/clients/clients_screen.dart';
import 'app/modules/reports/reports_screen.dart';
import 'app/modules/settings/settings_screen.dart';

void main() {
  runApp(const MakzonApp());
  }

  class MakzonApp extends StatelessWidget {
    const MakzonApp({super.key});

      @override
        Widget build(BuildContext context) {
            return MaterialApp(
                  title: 'Makzon',
                        debugShowCheckedModeBanner: false,
                              theme: ThemeData(
                                      primarySwatch: Colors.green,
                                              scaffoldBackgroundColor: const Color(0xFFF5F5F5), // خلفية رمادية فاتحة
                                                      fontFamily: 'Cairo', // سنضيف الخط لاحقًا
                                                              appBarTheme: const AppBarTheme(
                                                                        backgroundColor: Colors.green,
                                                                                  foregroundColor: Colors.white, // لون النص والأيقونات في AppBar
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
                                                                                                                                                                                                                                                            