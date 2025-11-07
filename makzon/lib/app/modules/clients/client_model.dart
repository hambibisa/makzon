import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'client_model.g.dart';

@HiveType(typeId: 2)
class Client extends HiveObject {
    @HiveField(0)
      late String id;

        @HiveField(1)
          late String name;

            @HiveField(2) // الحقل الجديد
              late double debt;

                @HiveField(3)
                  late String phone;

                    Client({required this.name, required this.phone}) {
                          id = const Uuid().v4();
                              debt = 0.0; // تهيئة الدين بصفر
                    }
}
