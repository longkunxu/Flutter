import 'package:flutter/material.dart';

class DrawerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.all(0.0), //去掉顶端的灰色条
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: null,
            accountEmail: null,
            currentAccountPicture: null,
            //圆形头像
            // currentAccountPicture:CircleAvatar(
            //   backgroundImage: AssetImage('image path'),
            // ),
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('images/bg_account_switcher.png'),
              ),
            ),
          ),
          ListTile(
            title: Text(
              '首页',
              style: TextStyle(color: Colors.blue[600]),
            ),
            leading: ImageIcon(
              AssetImage('images/quantum_ic_home_black_24.png'),
              color: Colors.blue[600],
            ),
            onTap: () {},
          ),
          ListTile(
            title: Text(
              '翻译收藏夹',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            leading: ImageIcon(
              AssetImage('images/quantum_ic_stars_black_24.png'),
            ),
            onTap: () {},
          ),
          ListTile(
            title: Text(
              '离线翻译',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            leading: ImageIcon(
              AssetImage('images/quantum_ic_offline_pin_black_24.png'),
            ),
            onTap: () {},
          ),
          ListTile(
            title: Text(
              '设置',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            leading: ImageIcon(
              AssetImage('images/quantum_ic_settings_black_24.png'),
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
