import 'package:flut_news/data/UserSource.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../profile_page.dart';

import '../../main.dart';
import '../dashboard.dart';

class CustomDrawer extends StatelessWidget {
  _buildDrawerItems(Icon icon, String title, Function onTap) {
    return ListTile(
      leading: icon,
      onTap: () {
        onTap();
      },
      title: Text(
        title,
        style: TextStyle(
          fontSize: 20.0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: EdgeInsets.only(top: 30.0),
        child: Column(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 100.0,
                  width: 100.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 1.5,
                      color: Colors.grey,
                    ),
                  ),
                  child: ClipOval(
                    child: Image.network(
                      user!.imageUrl,
                      height: 50,
                      width: 50,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text(
                    "#" + user!.username,
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            _buildDrawerItems(Icon(Icons.home), 'Home', () {
              controller.index = 0;
            }),
            _buildDrawerItems(Icon(Icons.favorite), 'Favourites', () {
              controller.index = 1;
            }),
            _buildDrawerItems(Icon(Icons.account_box), 'Profile Page', () {
              controller.index = 2;
            }),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 80.0),
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: _buildDrawerItems(
                    Icon(Icons.logout),
                    'LogOut',
                    () => Navigator.of(context, rootNavigator: true)
                        .pushReplacement(
                      new CupertinoPageRoute(
                        builder: (BuildContext context) => new MyApp(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
