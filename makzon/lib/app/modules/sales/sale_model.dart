import 'package:hive/hive.dart';

part 'sale_model.g.dart';

@HiveType(typeId: 2) // <-- ID جديد ومختلف
class Sale extends HiveObject {
  @HiveField(0)
    late String id;

      @HiveField(1)
        late List<String> productIds; // قائمة بمعرفات المنتجات المباعة

          @HiveField(2)
            late List<int> quantities; // كمية كل منتج

              @HiveField(3)
                late List<double> prices; // سعر كل منتج عند البيع

                  @HiveField(4)
                    late double totalAmount; // إجمالي الفاتورة

                      @HiveField(5)
                        late DateTime saleDate; // تاريخ البيع

                          @HiveField(6)
                            late bool isCredit; // هل هي فاتورة آجلة؟

                              @HiveField(7)
                                String? clientId; // معرف العميل إذا كانت آجلة
                                }
