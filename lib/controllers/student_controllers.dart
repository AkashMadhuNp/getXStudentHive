import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:studentgetx/model/model.dart';

class StudentControllers extends GetxController {
  final RxList<StudentModel> students = <StudentModel>[].obs;
  final RxList<StudentModel> filteredStudents = <StudentModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    ever(students, (_) => _updateFilteredList()); // React to students list changes
    getAllStudents();
  }

  void _updateFilteredList() {
    if (searchQuery.value.isEmpty) {
      filteredStudents.assignAll(students);
    } else {
      searchStudent(searchQuery.value);
    }
  }

  Future<void> getAllStudents() async {
    try {
      isLoading.value = true;
      final box = await Hive.openBox<StudentModel>('student');
      final studentsList = box.values.toList();
      students.assignAll(studentsList);
      _updateFilteredList();
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to load Students: ${e.toString()}",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Future<void> addStudent(StudentModel student) async {
  //   try {
  //     isLoading.value = true;
  //     final box = await Hive.openBox<StudentModel>('student');
  //     final id = await box.add(student);
      
  //     final updatedStudent = StudentModel(
  //       name: student.name,
  //       email: student.email,
  //       phone: student.phone,
  //       age: student.age,
  //       photo: student.photo,
  //       id: id,
  //     );
      
  //     await box.put(id, updatedStudent);
      
  //     // Update the local lists immediately
  //     students.add(updatedStudent);
      
  //     Get.snackbar(
  //       "Success",
  //       "Student added Successfully",
  //       backgroundColor: Colors.green,
  //       colorText: Colors.white,
  //     );
  //   } catch (e) {
  //     Get.snackbar(
  //       "Error",
  //       "Failed to add student: ${e.toString()}",
  //       backgroundColor: Colors.red,
  //       colorText: Colors.white,
  //     );
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

Future<StudentModel> addStudent(StudentModel student) async {
  try {
    isLoading.value = true;
    final box = await Hive.openBox<StudentModel>('student');
    final id = await box.add(student);
    
    final updatedStudent = StudentModel(
      name: student.name,
      email: student.email,
      phone: student.phone,
      age: student.age,
      photo: student.photo,
      id: id,
    );
    
    await box.put(id, updatedStudent);
    
    // Update the local lists immediately
    students.add(updatedStudent);
    
    // Use Get.snackbar with context-independent method
    Get.snackbar(
      "Success",
      "Student added Successfully",
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
    
    // Return the added student
    return updatedStudent;
  } catch (e) {
    Get.snackbar(
      "Error",
      "Failed to add student: ${e.toString()}",
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
    rethrow;
  } finally {
    isLoading.value = false;
  }
}
  Future<void> updateStudent(StudentModel student) async {
    try {
      isLoading.value = true;
      final box = await Hive.openBox<StudentModel>('student');
      await box.put(student.id, student);
      
      // Update the local list immediately
      final index = students.indexWhere((s) => s.id == student.id);
      if (index != -1) {
        students[index] = student;
      }
      
      Get.snackbar(
        "Success",
        "Student updated Successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to update student: ${e.toString()}",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteStudent(int id) async {
    try {
      isLoading.value = true;
      final box = await Hive.openBox<StudentModel>('student');
      await box.delete(id);
      
      // Update the local list immediately
      students.removeWhere((student) => student.id == id);
      
      Get.snackbar(
        "Success",
        "Student deleted Successfully",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to delete student: ${e.toString()}",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void searchStudent(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredStudents.assignAll(students);
    } else {
      filteredStudents.assignAll(students.where((student) {
        final nameMatch = student.name?.toLowerCase().contains(query.toLowerCase()) ?? false;
        final emailMatch = student.email?.toLowerCase().contains(query.toLowerCase()) ?? false;
        return nameMatch || emailMatch;
      }).toList());
    }
  }
}