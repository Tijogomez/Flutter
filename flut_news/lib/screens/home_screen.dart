import 'package:flut_news/screens/news/NewsBloc.dart';
import 'package:flut_news/screens/news/NewsEvents.dart';
import 'package:flut_news/screens/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'details_page.dart';
import '../data/model/News.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _bloc = NewsBloc();

  @override
  void initState() {
    super.initState();
    _bloc.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
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
        title: const Text(
          'FlutNews-Today',
          style: TextStyle(
            color: Colors.blueAccent,
            fontWeight: FontWeight.bold,
            letterSpacing: 5.0,
          ),
        ),
      ),
      drawer: CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Focus(
                  onFocusChange: (hasFocus) {},
                  child: StreamBuilder<String>(
                    stream: _bloc.searchQuery,
                    initialData: "",
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      return TextField(
                        onChanged: (text) {
                          _bloc.eventsSink.add(SearchQueryChanged(text));
                        },
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 15.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: const BorderSide(width: 0.8),
                          ),
                          hintText: 'Search News',
                          prefixIcon: const Icon(
                            Icons.search,
                            size: 30.0,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Available Categories',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.0,
                      ),
                    ),
                    StreamBuilder<String>(
                      stream: _bloc.selectedCategory,
                      initialData: "",
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Container(
                            height: 50.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.blue[100],
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _bloc.newsCategories.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final categories = _bloc.newsCategories;
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 1.0),
                                    child: Center(
                                      child: Card(
                                        color:
                                            snapshot.data == categories[index]
                                                ? Colors.white
                                                : Colors.blueAccent,
                                        child: InkWell(
                                          onTap: () {
                                            _bloc.eventsSink.add(
                                                NewsCategoryChanged(index));
                                          },
                                          splashColor: Colors.white30,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              categories[index],
                                              style: TextStyle(
                                                color: snapshot.data ==
                                                        categories[index]
                                                    ? Colors.blueAccent
                                                    : Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'Selected Category',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),
                  StreamBuilder<List<News>>(
                    stream: _bloc.newsList,
                    initialData: const [],
                    builder: (BuildContext context,
                        AsyncSnapshot<List<News>> snapshot) {
                      final _snapshotData = snapshot.data;
                      if (_snapshotData == null) {
                        return const Padding(
                          padding: EdgeInsets.only(top: 50.0),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      } else {
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: _snapshotData.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              child: ListTile(
                                leading: Image.network(
                                  _snapshotData[index].imageUrl!,
                                  height: 50.0,
                                  width: 60.0,
                                  fit: BoxFit.cover,
                                ),
                                title: Text(
                                  _snapshotData[index].title.toString(),
                                  style: const TextStyle(
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
                                            title: _snapshotData[index].title),
                                      ));
                                },
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
