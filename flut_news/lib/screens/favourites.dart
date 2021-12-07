import 'dart:convert';

import 'package:flut_news/screens/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'details_page.dart';

class Favourites extends StatefulWidget {
  const Favourites({Key? key}) : super(key: key);

  @override
  _FavouritesState createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  List favourites = [];

  void _getFavs() =>
      {favourites = allNews.where((news) => news.isFavourite).toList()};

  @override
  void initState() {
    super.initState();
    _getFavs();
  }

  @override
  Widget build(BuildContext context) {
    if (favourites.length > 0) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Theme.of(context).primaryColor,
          ),
          title: Text(
            'Your Fav',
            style: TextStyle(
              color: Colors.blueAccent,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                setState(() {
                  _getFavs();
                });
              },
            ),
          ],
        ),
        drawer: CustomDrawer(),
        body: ListView.builder(
          shrinkWrap: true,
          itemCount: favourites.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child: ListTile(
                leading: Image.network(
                  favourites[index].imageUrl,
                  height: 50.0,
                  width: 60.0,
                  fit: BoxFit.cover,
                ),
                title: Text(
                  favourites[index].title,
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailPage(
                          author: favourites[index].author,
                          title: favourites[index].title,
                          imageUrl: favourites[index].imageUrl,
                          content: favourites[index].content,
                          isFavourite: favourites[index].isFavourite,
                          onFavouriteClick: ((isFavourite) =>
                              {favourites[index].isFavourite = isFavourite})),
                    ),
                  );
                },
              ),
            );
          },
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Theme.of(context).primaryColor,
          ),
          title: Text(
            'Your Fav',
            style: TextStyle(
              color: Colors.blueAccent,
            ),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    _getFavs();
                  });
                },
                icon: Icon(Icons.refresh))
          ],
        ),
        drawer: CustomDrawer(),
        body: Center(
          child: Text(
            'No Favourites',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
        ),
      );
    }
  }
}
