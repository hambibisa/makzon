import 'package:flutter/material.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
    final Function(int) onTap;

      const CustomBottomNav({
          super.key,
              required this.currentIndex,
                  required this.onTap,
                    });

                      @override
                        Widget build(BuildContext context) {
                            return BottomNavigationBar(
                                  currentIndex: currentIndex,
                                        onTap: onTap,
                                              selectedItemColor: Colors.green.shade700,
                                                    unselectedItemColor: Colors.grey.shade600,
                                                          type: BottomNavigationBarType.fixed,
                                                                backgroundColor: Colors.white,
                                                                      elevation: 8.0,
                                                                            items: const [
                                                                                    BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "الرئيسية"),
                                                                                            BottomNavigationBarItem(icon: Icon(Icons.inventory_2_outlined), label: "المنتجات"),
                                                                                                    BottomNavigationBarItem(icon: Icon(Icons.point_of_sale_outlined), label: "المبيعات"),
                                                                                                            BottomNavigationBarItem(icon: Icon(Icons.people_outline), label: "العملاء"),
                                                                                                                    BottomNavigationBarItem(icon: Icon(Icons.bar_chart_outlined), label: "التقارير"),
                                                                                                                            BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: "الإعدادات"),
                                                                                                                                  ],
                                                                                                                                      );
                                                                                                                                        }
                                                                                                                                        }
                                                                                                                                        