import 'package:flutter/material.dart';

import '../../main.dart';

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
                      width: 3.0,
                      color: Colors.blueAccent,
                    ),
                  ),
                  child: ClipOval(
                    child: Icon(Icons.person),
                  ),
                ),
                SizedBox(width: 6.0),
                Text(
                  'UserName',
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 25.0,
            ),
            _buildDrawerItems(
                Icon(Icons.panorama_photosphere), 'World News', () {}),
            _buildDrawerItems(
                Icon(Icons.panorama_wide_angle_outlined), 'Local  News', () {}),
            _buildDrawerItems(
                Icon(Icons.new_releases_rounded), 'Whats New', () {}),
            Expanded(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: _buildDrawerItems(
                  Icon(Icons.logout),
                  'LogOut',
                  () => Navigator.pushReplacement(
                    context,
                    new MaterialPageRoute(
                      builder: (BuildContext context) => new MyApp(),
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
