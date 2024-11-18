import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studentgetx/controllers/student_controllers.dart';
import 'package:studentgetx/model/model.dart';
import 'package:studentgetx/screens/detailScreen/detail.dart';
import 'package:studentgetx/screens/editScreen/edit.dart';
import 'package:studentgetx/screens/registration/registration.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();
  final StudentControllers controller = Get.put(StudentControllers());
  Timer? debouncer;

  

  @override
  void dispose() {
    debouncer?.cancel();
    searchController.dispose();
    super.dispose();
  }

 Future<void> delete(BuildContext context, int? id) async {
  if (id == null) return;
  
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: const Color.fromARGB(255, 2, 19, 34),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: const BorderSide(
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
        content: Text(
          "Are you sure you want to remove this student?",
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
            margin: const EdgeInsets.only(left: 8, right: 8),
            child: ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                await controller.deleteStudent(id);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Delete",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
        actionsPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      );
    },
  );
}


  void _navigateToEdit(BuildContext context, StudentModel student) {
    try {
      Get.to(
        () => EditScreen(student: student),
        transition: Transition.rightToLeft,
      )?.then((_) {
        controller.getAllStudents();
      });
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to open edit screen: ${e.toString()}",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Widget _buildStudentCard(StudentModel student) {
    return GestureDetector(
      onTap: () => bottomSheet(
        context,
        student.name!,
        student.email!,
        student.phone!,
        student.age!,
        student.photo!,
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 19, 2, 85),
              Color.fromARGB(255, 19, 2, 85),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Profile Image
              Hero(
                tag: 'student_${student.id}',
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Colors.white, Color(0xFF1E90FF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  padding: const EdgeInsets.all(2),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    backgroundImage: student.photo != null && student.photo!.isNotEmpty
                        ? FileImage(File(student.photo!))
                        : null,
                    child: student.photo == null || student.photo!.isEmpty
                        ? const Icon(Icons.person, size: 30, color: Color(0xFF6B48FF))
                        : null,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Student Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student.name ?? "No name",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      student.email ?? "No email",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Action Buttons
              Row(
                children: [
                  IconButton(
                    onPressed: () => _navigateToEdit(context, student),
                    icon: const Icon(Icons.edit, color: Colors.white),
                    tooltip: "Edit Student",
                  ),
                  IconButton(
                    onPressed: () => delete(context, student.id!),
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    tooltip: "Delete Student",
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 19, 2, 85),
              Color(0xFF4A3B8B),
              Color(0xFF4169E1),
            ],
          ),
        ),
        child: SafeArea(
          child: Obx(
            () => controller.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () => controller.getAllStudents(),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          // Welcome Section
                          Row(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                                child: const Icon(Icons.person, color: Colors.white, size: 30),
                              ),
                              const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Welcome Back",
                                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white),
                                  ),
                                  Text(
                                    "Student Portal",
                                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          // Search Bar
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 2,
                              ),
                            ),
                            child: TextField(
                              controller: searchController,
                              onChanged: (value) => controller.searchStudent(value),
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: "Search Students....",
                                hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Colors.white.withOpacity(0.7),
                                ),
                                suffixIcon: searchController.text.isNotEmpty
                                    ? IconButton(
                                        icon: Icon(
                                          Icons.clear,
                                          color: Colors.white.withOpacity(0.7),
                                        ),
                                        onPressed: () {
                                          searchController.clear();
                                          controller.searchStudent('');
                                        },
                                      )
                                    : null,
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Student List
                          Obx(
                            () => controller.filteredStudents.isEmpty
                                ? Center(
                                    child: Text(
                                      controller.searchQuery.value.isNotEmpty
                                          ? 'No matching students found'
                                          : 'No students available',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.7),
                                        fontSize: 16,
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: controller.filteredStudents.length,
                                    itemBuilder: (context, index) {
                                      return _buildStudentCard(controller.filteredStudents[index]);
                                    },
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF6B48FF), Color(0xFF1E90FF)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          backgroundColor: Colors.transparent,
          elevation: 0,
          onPressed: () => Get.to(() => const RegistrationPage()),
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text(
            "Add Student",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}