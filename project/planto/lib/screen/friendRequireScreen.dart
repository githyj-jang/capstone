import 'package:flutter/material.dart';

import '../model/friend_data.dart';


class FriendRequiredScreen extends StatefulWidget {
  const FriendRequiredScreen({super.key});

  @override
  State<FriendRequiredScreen> createState() => _FriendRequiredScreenState();
}

class _FriendRequiredScreenState extends State<FriendRequiredScreen> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  static List<String> nickname = [
    'testRequiredNick1',
    'testRequiredNick2',
    'testRequiredNick3',
    'testRequiredNick4'
  ];

  static List<String> name = [
    'testRequired1',
    'testRequired2',
    'testRequired3',
    'testRequired4'
  ];
  static List<String> idList = [
    'testRequired1@test.com',
    'testRequired2@test.com',
    'testRequired3@test.com',
    'testRequired4@test.com'
  ];

  final List<Friend> friendData =  List.generate(nickname.length,
          (index) => Friend('testNick',nickname[index],name[index],idList[index]));

  List<Friend> _displayedFriendData = [];

  // 여기에 검색 로직을 구현하세요.
  void _performSearch(String query) {
    if (query.isEmpty) {
      _displayedFriendData = List.from(friendData);
    } else {
      _displayedFriendData = friendData
          .where((friend) =>
      friend.friendNick.toLowerCase().contains(query.toLowerCase()) ||
          friend.friendName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

    setState(() {});
  }
  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: "Search...",
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.grey),
      ),
      style: TextStyle(color: Colors.black, fontSize: 16.0),
      onChanged: (query) => _performSearch(query),
    );
  }



  @override
  void initState() {
    super.initState();
    _displayedFriendData = List.from(friendData);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: _isSearching ? _buildSearchField() : Text("친구요청"),
        actions: <Widget>[
          IconButton(
            icon: Icon(_isSearching ? Icons.cancel : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  _performSearch('');
                }
              });
            },
          )
        ],
      ),
      body: ListView.builder(
        itemCount: _displayedFriendData.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: Text(
                _displayedFriendData[index].friendName,
                style: TextStyle(fontSize: 15, color: Colors.grey[500]),
              ),
              title: Text(
                _displayedFriendData[index].friendNick,
                style:
                const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              trailing: IconButton(
                icon: Icon(Icons.add_task),
                onPressed: () {  },
              ),
            ),
          );
        },
      ),
    );
  }
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
