import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

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

  Future<void> feachImage(String textSearch) async {
    Response response = await Dio().get(
        "https://pixabay.com/api/?key=24474456-12b32c094cd3754e35ab5af34&q=$textSearch&image_type=photo&per_page=100");
    imageList = response.data['hits'];
    print(imageList);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    feachImage('tv');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: TextFormField(
          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
          ),
          onFieldSubmitted: (taptext) {
            print(taptext);
            feachImage(taptext);
          },
        ),
      ),
      body: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3),
          itemCount: imageList.length,
          itemBuilder: (context, index) {
            Map<String, dynamic> image = imageList[index];

            return InkWell(
              onTap: () async {
                Directory dir = await getTemporaryDirectory();

                Response res = await Dio().get(image['webformatURL'],
                    options: Options(
                      responseType: ResponseType.bytes,
                    ));
                File imageFile =
                    await File("${dir.path}/image.png").writeAsBytes(res.data);

                await Share.shareFiles([imageFile.path]);
              },
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    image['previewURL'],
                    fit: BoxFit.cover,
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      color: Colors.white.withOpacity(0.3),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.thumb_up_alt_outlined,
                          ),
                          Text(image['likes'].toString()),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
