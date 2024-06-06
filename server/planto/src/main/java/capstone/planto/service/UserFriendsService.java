package capstone.planto.service;

import capstone.planto.domain.User;
import org.springframework.beans.factory.annotation.Autowired;
import capstone.planto.domain.UserFriends;
import capstone.planto.repository.UserFriendsRepository;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Optional;

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
    public boolean addUserFriend(UserFriends userFriend) {
        // 동일한 userId와 friendNick을 가진 데이터가 있는지 확인
        Optional<UserFriends> existingUserFriend = userFriendsRepository.findByUserIdAndFriendNick(userFriend.getUserId(), userFriend.getFriendId());

        if (existingUserFriend.isPresent()) {
            // 이미 존재하는 경우, false 반환
            return false;
        } else {
            // 존재하지 않는 경우, 데이터 저장
            userFriendsRepository.save(userFriend);
            return true;
        }
    }
}
