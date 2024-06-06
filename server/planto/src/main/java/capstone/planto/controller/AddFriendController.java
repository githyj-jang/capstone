package capstone.planto.controller;

import capstone.planto.domain.AddFriend;
import capstone.planto.service.AddFriendService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/friend")
public class AddFriendController {

    @Autowired
    private AddFriendService addFriendService;

    @PostMapping("/add")
    public String addFriend(@RequestBody AddFriend addFriend) {
        boolean isSuccess = addFriendService.addFriend(addFriend);
        return isSuccess ? "Friend added successfully" : "Friend already exists";
    }

    @DeleteMapping("/delete")
    public String deleteFriend(@RequestParam String userId, @RequestParam String friendId) {
        addFriendService.deleteFriend(userId, friendId);
        return "Friend deleted successfully";
    }

    @GetMapping("/list")
    public List<AddFriend> listFriends(@RequestParam String userId) {
        return addFriendService.listFriends(userId);
    }
}
