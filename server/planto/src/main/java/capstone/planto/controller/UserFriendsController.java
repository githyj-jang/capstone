package capstone.planto.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import capstone.planto.domain.UserFriends;
import capstone.planto.service.UserFriendsService;
import java.util.List;

@RestController
@RequestMapping("/user-friends")
public class UserFriendsController {

    private final UserFriendsService userFriendsService;

    @Autowired
    public UserFriendsController(UserFriendsService userFriendsService) {
        this.userFriendsService = userFriendsService;
    }

    @GetMapping("/getFriends")
    public List<UserFriends> getFriendsByUserId(@RequestParam String userId) {
        return userFriendsService.getFriendsByUserId(userId);
    }

    @PostMapping("/userFriends")
    public String addUserFriend(@RequestBody UserFriends userFriend) {
        boolean isAdded = userFriendsService.addUserFriend(userFriend);
        return isAdded ? "User friend added successfully" : "User friend already exists";
    }
}

