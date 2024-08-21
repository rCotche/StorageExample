import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:storage_example_firebase/utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //Represents a reference to a Google Cloud Storage object
  List<Reference> uploadedFiles = [];

  @override
  void initState() {
    super.initState();
    getUploadedFiles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Firebase Storage",
        ),
        centerTitle: true,
      ),
      body: _buildUi(),
      floatingActionButton: _uploadMediaButton(context),
    );
  }

  Widget _uploadMediaButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        File? selectedImage = await getImageFromGallery(context);
        // print("file: $selectedImage");
        // print(
        //     "bytes : ${selectedImage?.length()}; mo : ${(selectedImage?.length() as int) * 0.000001}");
        if (selectedImage != null) {
          bool success = await uploadFileForUser(selectedImage);
          if (success) {
            getUploadedFiles();
          }
        }
      },
      child: const Icon(
        Icons.upload,
      ),
    );
  }

  Widget _buildUi() {
    if (uploadedFiles.isEmpty) {
      return const Center(
        child: Text("No file uploaded yet"),
      );
    }
    return ListView.builder(
      itemCount: uploadedFiles.length,
      itemBuilder: (context, index) {
        Reference ref = uploadedFiles[index];
        return FutureBuilder(
          future: ref.getDownloadURL(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListTile(
                leading: Image.network(snapshot.data!),
                title: Text(
                  ref.name,
                ),
              );
            }
            return Container();
          },
        );
      },
    );
  }

  void getUploadedFiles() async {
    List<Reference>? result = await getUserUploadFiles();
    if (result != null) {
      setState(() {
        uploadedFiles = result;
      });
    }
  }
}
