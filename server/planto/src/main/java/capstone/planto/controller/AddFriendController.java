package capstone.planto.controller;

import capstone.planto.domain.AddFriend;
import capstone.planto.domain.User;
import capstone.planto.service.AddFriendService;
import capstone.planto.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@CrossOrigin(origins = "*")
@RestController
@RequestMapping("/friend")
public class AddFriendController {

    @Autowired
    private AddFriendService addFriendService;
    @Autowired
    private UserService userService;

    @PostMapping("/add")
    public String addFriend(@RequestBody AddFriend addFriend) {
        boolean isSuccess = addFriendService.addFriend(addFriend);
        return isSuccess ? "Friend added successfully" : "Friend already exists";
    }

    @DeleteMapping("/fromme/delete")
    public String deleteFriend(@RequestParam String userId, @RequestParam String friendId) {
        addFriendService.deleteFriend(userId, friendId);
        return "Friend deleted successfully";
    }

    @DeleteMapping("/tome/delete")
    public String Frienddelete(@RequestParam String userId, @RequestParam String friendId) {
        addFriendService.friendDelete(userId, friendId);
        return "Friend deleted successfully";
    }

    @GetMapping("/tome/list")
    public List<AddFriend> listFriends(@RequestParam String userId) {
        List<AddFriend> friends = addFriendService.listFriends(userId);
        for (AddFriend friend : friends) {
            friend.setFriendId(userId);
            Optional<User> user = userService.getUserById(String.valueOf(friend.getUserId()));
            friend.setFriendId(user.get().getUserId() );
            friend.setFriendName(user.get().getName());
            friend.setFriendNick(user.get().getNick());
        }
        return friends;
    }
    @GetMapping("/fromme/list")
    public List<AddFriend> Friendslist(@RequestParam String userId) {
        return addFriendService.Friendslist(userId);
    }

}
