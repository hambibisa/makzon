import 'package:hive/hive.dart';

part 'product_model.g.dart';

@HiveType(typeId: 0)
class Product extends HiveObject {
  @HiveField(0)
    late String id;

      @HiveField(1)
        late String name;

          @HiveField(2)
            late double price; // سعر البيع

              @HiveField(3)
                late int quantity;

                  @HiveField(4)
                    String? imageUrl;

                      @HiveField(5) // <-- هذا هو الحقل الجديد والمهم
                        late double purchasePrice; // سعر الشراء
                        }
                        