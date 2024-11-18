import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:studentgetx/controllers/student_controllers.dart';
import 'package:studentgetx/model/model.dart';
import 'package:studentgetx/screens/home/home_screen.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final StudentControllers controller = Get.find();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  
  File? selectedImage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:const Size.fromHeight(60), 
        child: AppBar(
          centerTitle: true,
          title: const Text(
            "Student Registration",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 24
            ),
            ),

            leading: IconButton(onPressed: () => Navigator.pop(context), 
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              )),
              flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF4A3B8B),
                  Color(0xFF4169E1),
                ],
              ),
            ),
          ),
          elevation: 0,
        )),


        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors:[
                  Color(0xFF4A3B8B),
                  Color(0xFF4169E1),
                ], )
          ),

          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            height: 160,
                            width: 160,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.black,
                                width: 3
                              ),

                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 3,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                )
                              ]
                            ),

                            child: ClipOval(
                              child: selectedImage!=null
                              ? Image.file(
                                selectedImage!,
                                fit: BoxFit.cover,
                                width: 160,
                                height: 160,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.person,size: 80,color: Colors.black,);
                                },
                              ):const Icon(Icons.person,size: 80,color: Colors.black,),
                            ),
                          ),

                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () async{
                                try{
                                  final picker =ImagePicker();
                                  final pickedImage=await picker.pickImage(source: ImageSource.gallery,imageQuality: 75);
                                  if(pickedImage!=null){
                                    setState(() {
                                      selectedImage=File(pickedImage.path);
                                    });
                                  }

                                }catch(e){
                                  if(context.mounted){
                                    showSnackBar(context, "Failed to pick Image:${e.toString()}", 
                                    Colors.red);

                                  }

                                }
                                
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle
                                ),

                                child: Icon(Icons.camera_alt,color: Colors.black,size: 24,),
                                
                              ),
                            ))
                        ],
                      ),
                    ),



                      const SizedBox(height: 20),
                  _buildTextField(
                    hint: 'Student Name',
                    icon: Icons.person_outline,
                    controller: _nameController,
                    validator: (value) {
      
                      final trimmedvalue = value?.trim();
                      if(trimmedvalue == null || trimmedvalue.isEmpty){
                        return "Please enter your name";
                      }

                      final RegExp nameRegExp = RegExp(r'^[a-zA-Z ]+$');
                      if(!nameRegExp.hasMatch(trimmedvalue)){
                        return "Full Name only contains letters";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.name,
                  ),
                  const SizedBox(height: 16),

                                    _buildTextField(
                    hint: 'Email Address',
                    icon: Icons.email_outlined,
                    controller: _emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter email address';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),


                                    _buildTextField(
                    hint: 'Phone Number',
                    icon: Icons.phone_outlined,
                    controller: _phoneController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter phone number';
                      }
                      if (value.length < 10) {
                        return 'Phone number must be at least 10 digits';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    
                  ),
                  const SizedBox(height: 16),


                   _buildTextField(
                    hint: 'Age',
                    icon: Icons.calendar_today_outlined,
                    controller: _ageController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter age';
                      }
                      int? age = int.tryParse(value);
                      if (age == null || age < 1 || age > 120) {
                        return 'Please enter a valid age';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    maxLength: 3,
                    
                  ),
                  const SizedBox(height: 16),



                  Container(
                    width: double.infinity,
                    height: 55,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Colors.black,
                          Color(0xFF4A3B8B),
                          Color(0xFF4169E1),
                          Colors.black
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed:_handleSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Add Student',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),



                  ],
                ),
              )),
            ),
        ),
    );



  }

   Widget _buildTextField({
    required String hint,
    required IconData icon,
    int maxLines = 1,
    int? maxLength,
    required TextEditingController controller,
    required String? Function(String?) validator,
    required TextInputType? keyboardType,
    
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.white.withOpacity(0.15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
        maxLines: maxLines,
        maxLength: maxLength,
        validator: validator,
        keyboardType: keyboardType,
       
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.6),
          ),
          prefixIcon: Icon(
            icon,
            color: Colors.white.withOpacity(0.6),
            size: 22,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          counterText: '', 
        ),
      ),
    );
  }


void showSnackBar(BuildContext context, String message, Color color) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message),
    duration: Duration(seconds: 2),
    backgroundColor: color,
  ));
}


// void _handle()async{
//   if(_formKey.currentState!.validate() &&
//   _nameController.text.isNotEmpty &&
//   _phoneController.text.isNotEmpty &&
//   _emailController.text.isNotEmpty &&
//   _ageController.text.isNotEmpty &&
//   selectedImage?.path.isNotEmpty == true 
//   ){
//     await registerStudent(
//       context, 
//       _nameController.text.trim(), 
//       _emailController.text.trim(),
//       int.parse(_ageController.text),
//       int.parse(_phoneController.text) ,
//        selectedImage!.path.toString(),
//        _formKey);

//        if(mounted && context.mounted){
//         await getStudent();
//         Navigator.of(context).pushReplacement(
//           MaterialPageRoute(
//             builder: (context) =>  HomeScreen(),
//             )
//             );
//        }
//   }else{
//     _nameController.clear();
//     _ageController.clear();
//     _emailController.clear();
//   }
// }


void _handleSubmit() async {
  if (_formKey.currentState!.validate() &&
      selectedImage?.path.isNotEmpty == true) {
    final student = StudentModel(
      name: _nameController.text,
      email: _emailController.text,
      phone: int.parse(_phoneController.text),
      age: int.parse(_ageController.text),
      photo: selectedImage!.path,
      id: -1,
    );

    await controller.addStudent(student);
    
    // Use Future.microtask to defer navigation
    Future.microtask(() {
      Get.offAll(() => const HomeScreen());
    });
  }
}
}