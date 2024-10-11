import 'package:flutter/material.dart';
import 'package:planto/model/user_data.dart';
import 'package:planto/repository/user_friend.dart';
import '../model/friend_data.dart';
import './friend_add_screen.dart';

class FriendScreen extends StatefulWidget {
  const FriendScreen({super.key});

  @override
  State<FriendScreen> createState() => _FriendScreenState();
}

class _FriendScreenState extends State<FriendScreen> {

  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();


  List<Friend> friendData = [];
  

  _loadFriends() async {
    List<User> friends = await getFriendsByUserId(currentUser);
    setState(() {
      friendData = friends.map((user) => Friend(
        userId: user.userId,
        friendNick: user.nickName,
        friendName: user.name,
        friendId: user.userId,
      )).toList();
    });
  }

  List<Friend> _displayedFriendData = [];


  @override
  void initState() {
    super.initState();
    _loadFriends().then((_) {
      setState(() {
        _displayedFriendData = List.from(friendData);
      });
    });
  
    
  }
  
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

  void showPopup(context,name,nickName,id) {
    showDialog(
        context: context,
        builder: (context){
          return Dialog(
            child: Container(
              width:MediaQuery.of(context).size.width*0.7,
              height: MediaQuery.of(context).size.height*0.5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'assets/img/defaultProfile.png',
                      width: MediaQuery.of(context).size.height*0.25,
                      height: MediaQuery.of(context).size.height*0.25,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black
                    ),
                  ),
                  Text(
                    nickName,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey
                    ),
                  ),
                  Text(
                    id,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey
                    ),
                  ),
                ],
              ),
            ),
          );
        },
    );
  }

  

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: _isSearching ? _buildSearchField() : Text("Friends"),
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
          return GestureDetector(
            onTap: (){
              showPopup(context,_displayedFriendData[index].friendName,_displayedFriendData[index].friendNick,_displayedFriendData[index].friendId);
            },
            child: Card(
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
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context)=>FriendAddScreen()));
          
        },
        tooltip: 'add Friends',
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
