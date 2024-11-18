import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:studentgetx/functions/db_function.dart';
import 'package:studentgetx/model/model.dart';

Future<void> registerStudent(
  BuildContext context,
  String name,
  String email,
  int age,
  int phone,
  String image,
  GlobalKey<FormState> formKey
)async{
  if(image.isEmpty){
    return;
  }

  if(
    formKey.currentState!.validate() &&
    name.isNotEmpty &&
    email.isNotEmpty &&
    phone!=null&&
    age != null
  
  ){
    final add = StudentModel(
      name: name, 
      email: email, 
      phone: phone, 
      age: age, 
      photo: image,
      id: -1
      );

      addStudent(add);
      showSnackBar(context, "Registered Successfully", Colors.green);
      Navigator.pop(context);
  }
}



void showSnackBar(BuildContext context, String message, Color color) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message),
    duration: const Duration(seconds: 2),
    backgroundColor: color,
  ));
}

Future<void> editStudent(
  BuildContext context,
  String name,
  String email,
  int phone,
  int age,
  File? image,
  int id
)async{

  try{
    final editbox = await Hive.openBox<StudentModel>('student');
    final existingStudent = editbox.values.firstWhere(
      (element) => element.id==id,
      orElse: () => throw Exception("Student not found"),
      );

      existingStudent.name = name;
      existingStudent.phone = phone;
      existingStudent.email = email;
      existingStudent.age = age;
      existingStudent.photo = image!.path;


      await editbox.put(id, existingStudent);
      await getStudent();

      if(context.mounted){
        showSnackBar(context, "Updated Successfully", Colors.black);
        Navigator.pop(context);
      }
  }catch(e){
    if(context.mounted){
      showSnackBar(context, "Update failed: ${e.toString()}", Colors.red);
    }
  }
}


void delete(BuildContext context, int ? id){
  showDialog(
    context: context, 
    builder: (context) {
      return AlertDialog(
        backgroundColor: const Color.fromARGB(255, 2, 19, 34),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side:const BorderSide(
            color: Color.fromARGB(255, 2, 30, 53),
            width: 1
          )
        ),

        title: const Text(
          "Delete Student",
          style: TextStyle(
            color: Colors.red,
            fontSize: 20,
            fontWeight: FontWeight.bold
          ),
          ),

          content: Text("Are you sure you want to remove this student?",
          style: TextStyle(

            color: Colors.white.withOpacity(0.8),
            fontSize: 16
          ),
          ),


          actions: [
            TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.white.withOpacity(0.8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text(
              "CANCEL",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
            ),
          ),


          Container(
            margin: const EdgeInsets.only(left: 8,right: 8),
            child: ElevatedButton(
              onPressed: () {
              dlt(context, id);
            }, 
             style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            child:const Text("Delete",
            style: TextStyle(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
            ) 
            ),
          )

          ],

                  actionsPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),

      );
    },);



}



Future<void> dlt(context, int? id)async{
  final remove= await Hive.openBox<StudentModel>('student');
  remove.delete(id);
  getStudent();
  showSnackBar(context, "Deleted", Colors.red);
  Navigator.pop(context);
}