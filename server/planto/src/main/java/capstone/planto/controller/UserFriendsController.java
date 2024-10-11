package capstone.planto.controller;

import capstone.planto.domain.AddFriend;
import capstone.planto.domain.User;
import capstone.planto.service.AddFriendService;
import capstone.planto.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import capstone.planto.domain.UserFriends;
import capstone.planto.service.UserFriendsService;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

@CrossOrigin(origins = "*")
@RestController
@RequestMapping("/user-friends")
public class UserFriendsController {
    @Autowired
    private UserFriendsService userFriendsService;
    @Autowired
    private AddFriendService addFriendService;
    @Autowired
    private UserService userService;



    @GetMapping("/getFriends")
    public List<User> getFriendsByUserId(@RequestParam String userId) {
        List<UserFriends> userFriendsList = userFriendsService.getFriendsByUserId(userId);
        if (userFriendsList.isEmpty()) {
            System.out.println("No friends found for userId: " + userId);
        }
        return userFriendsList.stream()
                .map(userFriend -> {
                    User user = userService.getUserById(userFriend.getFriendId()).orElse(null);
                    if (user == null) {
                        System.out.println("No user found for friendId: " + userFriend.getFriendId());
                    }
                    return user;
                })
                .filter(Objects::nonNull)
                .map(friend -> {
                    User user = new User();
                    user.setUserId(friend.getUserId());
                    user.setName(friend.getName());
                    user.setNick(friend.getNick());
                    user.setPw(" ");
                    return user;
                })
                .collect(Collectors.toList());
    }

    @PostMapping("/userFriends")
    public String addUserFriend(@RequestBody UserFriends userFriend) {
        UserFriends userFriends = new UserFriends();
        userFriends.setUserId(userFriend.getUserId());
        userFriends.setFriendId(userFriend.getFriendId());
        boolean isAdded = userFriendsService.addUserFriend(userFriends);
        if (isAdded) {
            addFriendService.deleteFriend(userFriend.getFriendId(),userFriend.getUserId());
            addFriendService.friendDelete(userFriend.getUserId(),userFriend.getFriendId());
        }
        return isAdded ? "User friend added successfully" : "User friend already exists";
    }

    @PostMapping("/deleteFriend")
    public String deleteFriend(@RequestParam String userId, @RequestParam String friendId) {
        boolean isDeleted = userFriendsService.deleteUserFriend(userId, friendId);
        return isDeleted ? "Friend deleted successfully" : "Friend does not exist";
    }
}

