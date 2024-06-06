package capstone.planto.controller;

import capstone.planto.domain.User;
import capstone.planto.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

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
        return isRegistered ? "Registration successful" : "Nick already exists";
    }

    @PostMapping("/login")
    public String loginUser(@RequestParam String userId, @RequestParam String pw) {
        boolean isLoggedIn = userService.loginUser(userId, pw);
        return isLoggedIn ? "Login successful" : "Invalid Id or password";
    }
}
