import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:studentgetx/model/model.dart';

ValueNotifier<List<StudentModel>> studentList = ValueNotifier([]);

Future<void> addStudent(StudentModel value)async{
  final studentDb = await Hive.openBox<StudentModel>('student');
  final id = await studentDb.add(value);
  final studentdata = studentDb.get(id);
  await studentDb.put(id, StudentModel(
    name: studentdata!.name, 
    email: studentdata.email, 
    phone: studentdata.phone, 
    age: studentdata.age, 
    photo: studentdata.photo,
    id: id,
    ));
    getStudent();
}


Future<void> getStudent()async{
  final studentDb = await Hive.openBox<StudentModel>('student');
  studentList.value.clear();
  studentList.value.addAll(studentDb.values);
  studentList.notifyListeners();
}