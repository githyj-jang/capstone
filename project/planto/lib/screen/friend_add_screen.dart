import 'package:flutter/material.dart';
import 'package:planto/screen/friendRequireScreen.dart';
import '../model/friend_data.dart';

class FriendAddScreen extends StatefulWidget {
  const FriendAddScreen({super.key});

  @override
  State<FriendAddScreen> createState() => _FriendAddScreenState();
}

class _FriendAddScreenState extends State<FriendAddScreen> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  static List<String> nickname = [
    'testAddNick1',
    'testAddNick2',
    'testAddNick3',
    'testAddNick4'
  ];

  static List<String> name = [
    'testAdd1',
    'testAdd2',
    'testAdd3',
    'testAdd4'
  ];
  static List<String> idList = [
    'testAdd1@test.com',
    'testAdd2@test.com',
    'testAdd3@test.com',
    'testAdd4@test.com'
  ];

  final List<Friend> friendData =  List.generate(nickname.length,
          (index) => Friend('testNick',nickname[index],name[index],idList[index]));

  List<Friend> _displayedFriendData = [];

  // 여기에 검색 로직을 구현하세요.
  void _performSearch(String query) {
    if (query.isEmpty) {
      _displayedFriendData = List.empty();
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
    _displayedFriendData = List.empty();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: _isSearching ? _buildSearchField() : Text("Add Friends"),
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
              hoverColor: Colors.blue,
              title: Text(
                _displayedFriendData[index].friendNick,
                style:
                const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              trailing: IconButton(
                icon: Icon(Icons.add_circle_outline),
                onPressed: () {  },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context)=>FriendRequiredScreen()));
        },
        tooltip: 'Request to add friend',
        child: const Icon(Icons.add),
      ),
    );
  }
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
