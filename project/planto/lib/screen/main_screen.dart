import 'package:flutter/material.dart';
import 'package:planto/screen/calendar_screen.dart';
import 'package:planto/screen/friend_screen.dart';
import 'package:planto/screen/map_screen.dart';
import 'package:planto/screen/plan_add_screen.dart';
import 'package:planto/screen/plan_screen.dart';
import 'package:planto/screen/travel_add_screen.dart';
import 'package:planto/screen/travel_screen.dart';
import 'package:planto/screen/user_detail_screen.dart';

class MainScreen extends StatefulWidget {

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    CalendarScreen(),
    PlanScreen(),
    TravelScreen(),
    MapScreen(),
  ];

  static const List<Widget> _addWidgetOptions = <Widget>[
    PlanAddScreen(),
    PlanAddScreen(),
    TravelAddScreen(),
    PlanAddScreen()
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/img/defaultProfile.png'),
                backgroundColor: Colors.white,
              ),
              accountName: Text("testNick"),
              accountEmail: Text("test@test.com"),
            ),
            ListTile(
              leading: Icon(
                  Icons.manage_accounts, // 버튼에 포함될 아이콘 설정
                  color: Colors.grey[850]),
              title: Text('회원정보'), // 버튼에 포함될 텍스트 설정
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context)=>UserDetailScreen()));
              },
            ),
            ListTile(
              leading: Icon(
                  Icons.face, // 버튼에 포함될 아이콘 설정
                  color: Colors.grey[850]),
              title: Text('친구 관리'), // 버튼에 포함될 텍스트 설정
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context)=>FriendScreen()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.logout, // 버튼에 포함될 아이콘 설정
                color: Colors.grey[850],
              ),
              title: Text(
                '로그아웃',
              ), // 버튼에 포함될 텍스트 설정
              onTap: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),

          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Planto'),

      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: '달력',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: '일정',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_travel),
            label: '여행',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: '지도',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
      floatingActionButton: (_selectedIndex == 1 || _selectedIndex == 2)
          ? FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) => _addWidgetOptions.elementAt(_selectedIndex)));
        },
        tooltip: 'add Plan',
        child: const Icon(Icons.add),
      )
          : null, // _selectedIndex가 1 또는 2가 아닐 때 null을 반환하여 숨김

    );
  }

}
