
import 'package:hive/hive.dart';
part 'model.g.dart';

@HiveType(typeId: 1)
class StudentModel {
  @HiveField(0)
  String? name;

  @HiveField(1)
  String? email;

  @HiveField(2)
  int? phone;

  @HiveField(3)
  int? age;

  @HiveField(4)
  String? photo;
  
  @HiveField(5)
  int? id;

  StudentModel({
    required this.name,
    required this.email, 
    required this.phone,
    required this.age,
    required this.photo,
    this.id,
  });
}