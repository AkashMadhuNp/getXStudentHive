import 'dart:io';

import 'package:flutter/material.dart';

void bottomSheet(
  BuildContext context,
  String name,
  String email,
  int phone,
  int age,
  String photo
){
  showModalBottomSheet(
    context: context, 
    builder: (BuildContext context) {
      return Container(
        height: 450,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 19, 2, 85),
              Colors.blue.shade200
            ]),

            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(30),
              topLeft: Radius.circular(30)
            )
        ),

        child: Column(
          children: [
            const SizedBox(height: 20,),
            CircleAvatar(
              radius: 80,
              backgroundColor: Colors.white.withOpacity(0.1),
              backgroundImage: FileImage(File(photo)),
              child: photo.isEmpty
              ? const Icon(
                Icons.person,
                size: 50,
                color: Colors.white,):null,
            ),

            const SizedBox(height: 16,),

            Text(
              name.toUpperCase(),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),


            const SizedBox(height: 8,),

            Text(
              phone.toString(),
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),


            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C2C2E),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.person,
                            color: Color(0xFF2C2C2E),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            age.toString(),
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF2C2C2E),
                            ),
                            
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.center,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.email,
                              color: Color(0xFF2C2C2E),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              email,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF2C2C2E),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }, 
    );
}