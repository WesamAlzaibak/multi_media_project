import 'dart:convert';
import 'dart:html' as html;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
class addPictureScreen extends StatelessWidget {

  ImagePicker picker = ImagePicker();
  XFile? image;
  late BuildContext context;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Image Picker from Gallery"),
            backgroundColor: Colors.redAccent
        ),
        body: Container(
            padding: EdgeInsets.only(top: 20, left: 20, right: 20),
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                ElevatedButton(
                    onPressed: () async {
                      uploadImage();
                    },
                    child: Text("Pick Image")
                ),
              ],)
        )
    );
  }
  void uploadImage() async {
    // Open the file picker dialog
    final html.FileUploadInputElement input = html.FileUploadInputElement();
    input.click();
    await input.onChange.first;
    final file = input.files?.first;
    final reader = html.FileReader();
    reader.readAsDataUrl(file!);
    await reader.onLoad.first;
    final imageDataUrl = reader.result as String;
    final base64Data = imageDataUrl.replaceFirst(RegExp('data:image/[^;]+;base64,'), '');
    final body = jsonEncode({
      'image': base64Data,
    });
    final response = await http.post(Uri.parse('https://faeeec9f-0ed4-4e94-b3eb-b24f08412c95.mock.pstmn.io/abd-multi-media'),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    if (response.statusCode == 200) {
      print('Image uploaded successfully');
      print(response.body);
    } else {
      print('Image upload failed');
    }
  }
}