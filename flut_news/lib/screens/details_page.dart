import 'package:flut_news/data/News.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:favorite_button/favorite_button.dart';
// import 'package:url_launcher/url_launcher.dart';
import 'home_screen.dart';

class DetailPage extends StatefulWidget {
  DetailPage(
      {Key? key,
      required this.imageUrl,
      required this.content,
      required this.title,
      required this.author,
      required this.isFavourite,
      required this.onFavouriteClick})
      : super(key: key);

  String imageUrl, title, content, author;
  bool isFavourite;
  Function onFavouriteClick;

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    String imageUrl = widget.imageUrl,
        title = widget.title,
        content = widget.content,
        author = widget.author;
    bool isFavourite = widget.isFavourite;

    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                child: Image.network(
                  imageUrl,
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
                    isStarred: isFavourite,
                    valueChanged: (_isFavorite) {
                      setState(() {
                        widget.onFavouriteClick(!isFavourite);
                      });
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
                    title,
                    style:
                        TextStyle(fontSize: 27.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Text(
                    content,
                    style: TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 1.0),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    "By, $author",
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  RichText(
                    text: TextSpan(
                      text: "Source: ",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          recognizer: new TapGestureRecognizer()
                            ..onTap = () {
                              // launch(widget.url);
                            },
                          text: 'InShots',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.blue),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
