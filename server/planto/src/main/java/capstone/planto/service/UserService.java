package capstone.planto.service;

import capstone.planto.domain.User;
import capstone.planto.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Optional;
import java.util.List;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;
    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }
    public boolean registerUser(User user) {
        if (userRepository.findByNick(user.getNick()).isPresent()) {
            return false; // 닉네임이 이미 존재할 경우
        }
        userRepository.save(user);
        return true;
    }

    public boolean loginUser(String nick, String pw) {
        Optional<User> user = userRepository.findByNick(nick);
        return user.isPresent() && user.get().getPw().equals(pw);
    }



    public List<User> getUsersBySearchTerm(String searchTerm) {
        return userRepository.findByNickContainingOrIdContaining(searchTerm);
    }
}
