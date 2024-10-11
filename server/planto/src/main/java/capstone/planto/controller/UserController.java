package capstone.planto.controller;

import capstone.planto.domain.User;
import capstone.planto.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@CrossOrigin(origins = "*")
@RestController
@RequestMapping("/user")
public class UserController {

    @Autowired
    private UserService userService;
    public UserController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping("/search")
    public List<User> searchUsers(@RequestParam String searchTerm) {
        return userService.getUsersBySearchTerm(searchTerm);
    }
    @PostMapping("/register")
    public String registerUser(@RequestBody User user) {
        boolean isRegistered = userService.registerUser(user);
        return isRegistered ? "Registration successful" : "Already exists";
    }

    @PostMapping("/login")
    public String loginUser(@RequestParam String userId, @RequestParam String pw) {
        boolean isLoggedIn = userService.loginUser(userId, pw);
        return isLoggedIn ? "Login successful" : "Invalid Id or password";
    }

    @PostMapping("/changePassword")
    public String changePassword(@RequestParam String userId, @RequestParam String pw) {
        boolean isChanged = userService.changePassword(userId, pw);
        return isChanged ? "Password changed successfully" : "Invalid Id";
    }

    @GetMapping("/get")
    public User getUserById(@RequestParam String userId) {
        return userService.getUserById(userId).orElse(null);
    }


}
