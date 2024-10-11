import 'package:flutter/material.dart';
import 'package:planto/model/add_friend.dart';
import 'package:planto/model/user_data.dart';
import 'package:planto/repository/add_friend.dart';
import 'package:planto/repository/user.dart';
import 'package:planto/repository/user_friend.dart';
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
  List<Friend> friendData = [];

  AddFriendRepository addFriendRepository = AddFriendRepository();
  
  _loadFriends() async {
    List<User> friends = await searchUsers("");
    List<User> real_friends = await getFriendsByUserId(currentUser);
    List<AddFriend> friends_add_request =  await addFriendRepository.listFriendsFromMe(currentUser);
    List<User> friendsToAdd = friends_add_request.map((request) {
    return User(
      userId: request.friendId,
      pw: "",
      name: request.friendName,
      nickName: request.friendNick,
      );
    }).toList();

    List<AddFriend> friends_request = await addFriendRepository.listFriendsToMe(currentUser);

    List<User> friendsFromAdd = friends_request.map((request) {
    return User(
      userId: request.friendId,
      pw: "",
      name: request.friendName,
      nickName: request.friendNick,
      );
    }).toList();

    friends.removeWhere((user) => real_friends.any((friend) => friend.userId == user.userId) || user.userId == currentUser || friendsToAdd.any((friend) => friend.userId == user.userId) || friendsFromAdd.any((friend) => friend.userId == user.userId));

    setState(() {
      friendData = friends.map((user) => Friend(
        userId: user.userId,
        friendNick: user.nickName,
        friendName: user.name,
        friendId: user.userId,
      )).toList();
    });

  }

  // static List<String> nickname = [
  //   'testAddNick1',
  //   'testAddNick2',
  //   'testAddNick3',
  //   'testAddNick4'
  // ];

  // static List<String> name = [
  //   'testAdd1',
  //   'testAdd2',
  //   'testAdd3',
  //   'testAdd4'
  // ];
  // static List<String> idList = [
  //   'testAdd1@test.com',
  //   'testAdd2@test.com',
  //   'testAdd3@test.com',
  //   'testAdd4@test.com'
  // ];

  // final List<Friend> friendData = List.generate(nickname.length, (index) => Friend(
  //   userId: 'user1',
  //   friendNick: nickname[index],
  //   friendName: name[index],
  //   friendId: idList[index],
  // ));

  List<Friend> _displayedFriendData = [];

  // void _performSearch(String query) async{

  //   List<Friend> friendsData = await _loadFriends(query);
  //   if (query.isEmpty) {
  //     _displayedFriendData = List.empty();
  //   } else {
  //     _displayedFriendData = friendsData
  //         .where((friend) =>
  //     friend.friendNick.toLowerCase().contains(query.toLowerCase()) ||
  //         friend.friendName.toLowerCase().contains(query.toLowerCase()))
  //         .toList();
  //   }

  //   setState(() {});
  // }

  void _performSearch(String query) {
    if (query.isEmpty) {
      _displayedFriendData = List.from(friendData);
    } else {
      _displayedFriendData = friendData
          .where((friend) =>
          friend.friendNick.toLowerCase().contains(query.toLowerCase()) ||
          friend.friendName.toLowerCase().contains(query.toLowerCase()) ||
          friend.friendId.toLowerCase().contains(query.toLowerCase()))
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
    _loadFriends().then((_) {
      setState(() {
        _displayedFriendData = List.from(friendData);
      });
    });
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
                onPressed: () {
                  Friend friend = Friend(
                      userId: currentUser,
                      friendId: _displayedFriendData[index].friendId,
                      friendName: _displayedFriendData[index].friendName,
                      friendNick: _displayedFriendData[index].friendNick,
                  ); // Add friend
                  _addFriend(friend);
                  _loadFriends();
                  setState(() {});
                },
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
  void _addFriend(Friend addFriend) async {
    
    bool a = await addFriendRepository.addFriend(addFriend);
    if (a) {
      print("Friend added successfully");
    } else {
      print("Failed to add friend");
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
