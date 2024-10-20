import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';

// import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

import 'dart:ui' as ui;

import 'package:share_extend/share_extend.dart';

import '../../controller/db_controller.dart';
import 'home_page.dart';

// import 'package:share_extend/share_extend.dart';

class ThoughtScreen extends StatelessWidget {
  final RxString quote;
  final RxString author;
  const ThoughtScreen({super.key, required this.quote, required this.author});

  @override
  Widget build(BuildContext context) {
    final DataController dataController = Get.find<DataController>();
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    // final quote = dataController.quotes[SelectIndex];
    return SafeArea(
        child: Obx(
      () => Scaffold(
        body: Column(
          children: [
            Stack(
              children: [
                RepaintBoundary(
                  key: imgkey[SelectIndex],
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: height * 0.9 + 47,
                      width: width * 0.9 + 100,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(
                            dataController.backgroundImage.value,
                          ),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            quote.value,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 25,
                              shadows: [
                                Shadow(
                                  color: Colors.black38,
                                  blurRadius: 15,
                                )
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              '-${author.value}  ',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 25,
                                shadows: [
                                  Shadow(
                                    color: Colors.black38,
                                    blurRadius: 15,
                                  )
                                ],
                              ),
                            ),
                          ),
                          // SizedBox(height: height * 0.1,),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () async {
                          RenderRepaintBoundary boundary = imgkey[SelectIndex]
                              .currentContext!
                              .findRenderObject() as RenderRepaintBoundary;

                          ui.Image image = await boundary.toImage();
                          ByteData? bytedata = await image.toByteData(
                              format: ui.ImageByteFormat.png);
                          Uint8List img = bytedata!.buffer.asUint8List();

                          final path = await getApplicationDocumentsDirectory();
                          File file = File("${path.path}/img.png");
                          file.writeAsBytes(img);
                          ShareExtend.share(file.path, "image");
                        },
                        child: Icon(
                          Icons.share,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                backgroundColor: Colors.teal.shade50,
                                title: Text(
                                  'Save this image ?',
                                  style: TextStyle(color: Colors.white),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Back'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      RenderRepaintBoundary boundary =
                                          imgkey[SelectIndex]
                                                  .currentContext!
                                                  .findRenderObject()
                                              as RenderRepaintBoundary;

                                      ui.Image image = await boundary.toImage();
                                      ByteData? bytedata =
                                          await image.toByteData(
                                              format: ui.ImageByteFormat.png);
                                      Uint8List img =
                                          bytedata!.buffer.asUint8List();
                                      ImageGallerySaver.saveImage(img);
                                      Navigator.pop(context);
                                    },
                                    child: Text('Save'),
                                  )
                                ],
                              );
                            },
                          );
                        },
                        child: Icon(
                          Icons.file_download_outlined,
                          color: Colors.white,
                          size: 35,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return SizedBox(
                                width: double.infinity,
                                height: 200,
                                child: Column(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        'Background image',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 25),
                                      ),
                                    ),
                                    Expanded(
                                        child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: [
                                          ...List.generate(
                                            ColorsList.length,
                                            (index) => Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: InkWell(
                                                onTap: () {
                                                  colorIndex = index;
                                                },
                                                child: Container(
                                                  height: height * 0.06,
                                                  width: width * 0.1,
                                                  color: ColorsList[index],
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ))
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: Icon(
                          Icons.color_lens_outlined,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          RenderRepaintBoundary boundary = imgkey[SelectIndex]
                              .currentContext!
                              .findRenderObject() as RenderRepaintBoundary;

                          ui.Image image = await boundary.toImage();
                          ByteData? bytedata = await image.toByteData(
                              format: ui.ImageByteFormat.png);
                          Uint8List img = bytedata!.buffer.asUint8List();

                          final path = await getApplicationDocumentsDirectory();
                          File file = File("${path.path}/img.png");
                          file.writeAsBytes(img);
                          ShareExtend.share(file.path, "image");
                          int location = WallpaperManager
                              .BOTH_SCREEN; //can be Home/Lock Screen
                          bool result =
                              await WallpaperManager.setWallpaperFromFile(
                                  file.path, location);
                          Navigator.pop(context);
                          //
                        },
                        icon: Icon(
                          Icons.wallpaper,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    ));
  }
}

final DataController dataController = Get.put(DataController());

List<GlobalKey> imgkey =
    List.generate(dataController.quotes.length, (index) => GlobalKey());

// GlobalKey imgKey = GlobalKey();

Icon first = Icon(Icons.favorite_border);
Icon second = Icon(Icons.favorite);
bool selectImg = true;
// String Si = '${Save[select][inde]['img']}';
int inde = 0;

List imgList = [
  'assets/img/2.jpeg',
  'assets/img/3.jpg',
  'assets/img/4.jpeg',
  'assets/img/5.jpg',
  'assets/img/6.jpeg',
  'assets/img/7.jpeg',
  'assets/img/8.jpeg',
  'assets/img/9.jpeg',
  'assets/img/11.jpeg',
];

List ColorsList = [
  Colors.black,
  Colors.blue,
  Colors.pink,
  Colors.red,
  Colors.amber,
  Colors.brown,
  Colors.deepPurple,
  Colors.teal,
  Colors.white,
];

var colorIndex = 0;
// RxColor color = Colors.white.obs;
