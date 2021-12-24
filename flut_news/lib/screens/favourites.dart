import 'dart:convert';
import 'package:flut_news/data/db/NewsDataSource.dart';
import 'package:flut_news/data/model/News.dart';
import 'package:flut_news/screens/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'details_page.dart';

class Favourites extends StatefulWidget {
  const Favourites({Key? key}) : super(key: key);

  @override
  _FavouritesState createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  final NewsDataSource dataSource = NewsDataSource();

  Future<List<News>> getFavourites() async {
    return await dataSource.getFavourites();
  }

  @override
  Widget build(BuildContext context) {
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
                setState(() {});
              },
            ),
          ],
        ),
        drawer: CustomDrawer(),
        body: FutureBuilder(
            future: getFavourites(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                final data = snapshot.data;
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: ListTile(
                        leading: Image.network(
                          data[index].imageUrl,
                          height: 50.0,
                          width: 60.0,
                          fit: BoxFit.cover,
                        ),
                        title: Text(
                          data[index].title,
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
                                title: data[index].title,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            }));
  }
}
