class AddFriend {
  final int id;
  final String userId;
  final String friendId;
  final String friendName;
  final String friendNick;

  AddFriend({
    required this.id,
    required this.userId,
    required this.friendId,
    required this.friendName,
    required this.friendNick,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'friendId': friendId,
      'friendName': friendName,
      'friendNick': friendNick,
    };
  }

  factory AddFriend.fromJson(Map<String, dynamic> json) {
    return AddFriend(
      id: json['id'],
      userId: json['userId'],
      friendId: json['friendId'],
      friendName: json['friendName'],
      friendNick: json['friendNick'],
    );
  }
}