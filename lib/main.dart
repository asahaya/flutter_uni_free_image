import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: PixabayPage(),
    );
  }
}

class PixabayPage extends StatefulWidget {
  const PixabayPage({Key? key}) : super(key: key);

  @override
  State<PixabayPage> createState() => _PixabayPageState();
}

class _PixabayPageState extends State<PixabayPage> {
  List imageList = [];

  Future<void> feachImage() async {
    Response response = await Dio().get(
        "https://pixabay.com/api/?key=24474456-12b32c094cd3754e35ab5af34&q=yellow+flowers&image_type=photo");
    imageList = response.data['hits'];
    print(imageList);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    feachImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3),
          itemCount: imageList.length,
          itemBuilder: (context, index) {
            Map<String, dynamic> image = imageList[index];
            Map<String, dynamic> a = imageList[index];
            return Image.network(image['previewURL']);
          }),
    );
  }
}
