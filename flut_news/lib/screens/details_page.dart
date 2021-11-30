import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:favorite_button/favorite_button.dart';
// import 'package:url_launcher/url_launcher.dart';
import 'home_screen.dart';

class DetailPage extends StatefulWidget {
  DetailPage(
      {Key? key,
      required this.author,
      required this.title,
      required this.imageUrl,
      required this.content,
      required this.url})
      : super(key: key);

  String author;
  String title;
  String imageUrl;
  String content;
  String url;

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    String author = widget.author;
    String title = widget.title;
    String imageUrl = widget.imageUrl;
    String content = widget.content;
    String url = widget.url;
    bool isFavorite = false;

    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                child: Image.network(
                  widget.imageUrl,
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
                    isStarred: favList.contains(title) ? true : false,
                    valueChanged: (_isFavorite) {
                      if (!favList.contains(widget.title)) {
                        setState(() {
                          isFavorite = _isFavorite;
                          favList.add(widget.title);
                        });
                      } else {
                        setState(() {
                          isFavorite = _isFavorite;
                          favList.remove(widget.title);
                        });
                      }
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
                    widget.title,
                    style:
                        TextStyle(fontSize: 27.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Text(
                    widget.content,
                    style: TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 1.0),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    "By, ${widget.author}",
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
