import 'package:hive/hive.dart';
part 'client_model.g.dart';

@HiveType(typeId: 1) // <-- ID فريد للعميل
class Client extends HiveObject {
  @HiveField(0)
    late String id;
      @HiveField(1)
        late String name;
          @HiveField(2)
            String? phone;
              @HiveField(3)
                String? address;
                  @HiveField(4)
                    late double totalDebt;
                    }