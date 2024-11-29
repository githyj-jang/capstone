import 'package:flutter/material.dart';
import 'package:planto/dto/schedule_response.dart';
import 'package:planto/model/itiinerary_data.dart';
import 'package:planto/model/plan_data.dart';
import 'package:planto/model/schedule_data.dart';
import 'package:planto/model/user_data.dart';
import 'package:planto/repository/itiinerary_repository.dart';
import 'package:planto/repository/schedule_repository.dart';
import 'package:planto/repository/user_friend.dart';
import '../model/friend_data.dart';
import './friend_add_screen.dart';

class ShareScreen extends StatefulWidget {
  const ShareScreen({Key? key, required this.travel, required this.itiinerary})
      : super(key: key);

  final Plan travel;

  final List<Itiinerary> itiinerary;

  @override
  State<ShareScreen> createState() => _ShareScreenState();
}

class _ShareScreenState extends State<ShareScreen> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  ScheduleRepository scheduleRepository = ScheduleRepository();
  ItiineraryRepository itiineraryRepository = ItiineraryRepository();

  List<Friend> friendData = [];

  _loadFriends() async {
    List<User> friends = await getFriendsByUserId(currentUser);
    setState(() {
      friendData = friends
          .map((user) => Friend(
                userId: user.userId,
                friendNick: user.nickName,
                friendName: user.name,
                friendId: user.userId,
              ))
          .toList();
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

  Future<Schedule_Response> shareTravelPlan(Schedule schedule) async{
    return await scheduleRepository.addSchedule(schedule);
  }
  Future shareItiineraryPlan(Itiinerary itiinerary) async{
    await itiineraryRepository.addItiinerary(itiinerary);
    return "Itiinerary added";
  }

  void showPopup(context, name, nickName, id) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.7,
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.white),
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'assets/img/defaultProfile.png',
                    width: MediaQuery.of(context).size.height * 0.25,
                    height: MediaQuery.of(context).size.height * 0.25,
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
                      color: Colors.black),
                ),
                Text(
                  nickName,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                ),
                Text(
                  id,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
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
            onTap: () {
              showPopup(
                  context,
                  _displayedFriendData[index].friendName,
                  _displayedFriendData[index].friendNick,
                  _displayedFriendData[index].userId);
            },
            child: Card(
              child: ListTile(
                  leading: Text(
                    _displayedFriendData[index].friendName,
                    style: TextStyle(fontSize: 15, color: Colors.grey[500]),
                  ),
                  title: Text(
                    _displayedFriendData[index].friendNick,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      Schedule updatedSchedule = new Schedule(
                        userId: _displayedFriendData[index].userId,
                        title: widget.travel.eventName,
                        startTime: widget.travel.start,
                        endTime: widget.travel.end,
                        planFlag: false,
                      );

                      print(updatedSchedule.toJson());

                      shareTravelPlan(updatedSchedule).then((newSchedule) {
                        for(Itiinerary itiinerary in widget.itiinerary){
                          Itiinerary newItiinerary = new Itiinerary(
                            scheduleId: newSchedule.id,
                            place: itiinerary.place,
                            startTime: itiinerary.startTime,
                            placeInfo: itiinerary.placeInfo,
                            route: itiinerary.route,
                            description: itiinerary.description,
                          );

                          shareItiineraryPlan(newItiinerary);
                        }
                      });
                    },
                    icon: Icon(Icons.share))),
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
