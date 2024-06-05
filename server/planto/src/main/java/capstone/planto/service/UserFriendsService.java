package capstone.planto.service;

import org.springframework.beans.factory.annotation.Autowired;
import capstone.planto.domain.UserFriends;
import capstone.planto.repository.UserFriendsRepository;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class UserFriendsService {

    private final UserFriendsRepository userFriendsRepository;

    @Autowired
    public UserFriendsService(UserFriendsRepository userFriendsRepository) {
        this.userFriendsRepository = userFriendsRepository;
    }

    public List<UserFriends> getFriendsByUserId(String userId) {
        return userFriendsRepository.findByUserId(userId);
    }
}
