import 'package:flut_news/data/db/NewsDataSource.dart';
import 'package:flut_news/data/model/News.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:favorite_button/favorite_button.dart';
// import 'package:url_launcher/url_launcher.dart';
import 'home_screen.dart';

class DetailPage extends StatefulWidget {
  DetailPage({Key? key, required this.title}) : super(key: key);

  String title;

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final NewsDataSource dataSource = NewsDataSource();

  Future<News> getNewsByTitle() async {
    return await dataSource.getNewsByTitle(widget.title);
  }

  void updateNewsFavourite(bool isFav) async {
    await dataSource.updateNewsFavourite(widget.title, isFav);
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: FutureBuilder(
        future: getNewsByTitle(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final News data = snapshot.data;
            return Column(
              children: [
                Stack(
                  children: [
                    Container(
                      child: Image.network(
                        data.imageUrl!,
                        height: 200.0,
                        width: 200.0,
                        fit: BoxFit.cover,
                      ),
                      height: 300.0,
                      width: double.infinity,
                    ),
                    Positioned(
                      bottom: 10.0,
                      right: 10.0,
                      child: Center(
                        child: StarButton(
                          isStarred: data.isFavourite,
                          valueChanged: (_isFavourite) {
                            updateNewsFavourite(_isFavourite);
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      top: statusBarHeight + 10.0,
                      left: 10.0,
                      child: Center(
                        child: Container(
                          child: CircleAvatar(
                            backgroundColor: Colors.black.withOpacity(0.5),
                            child: IconButton(
                              icon: Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            radius: 20.0,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 15.0,
                ),
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.title,
                          style: TextStyle(
                              fontSize: 27.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Text(
                          data.content,
                          style: TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 1.0),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          "By, ${data.author}",
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }
}
