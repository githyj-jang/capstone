package capstone.planto.service;

import org.springframework.beans.factory.annotation.Autowired;
import capstone.planto.domain.UserFriends;
import capstone.planto.repository.UserFriendsRepository;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Optional;

@Service
public class UserFriendsService {
    @Autowired
    private UserFriendsRepository userFriendsRepository;


    public List<UserFriends> getFriendsByUserId(String userId) {
        return userFriendsRepository.findByUserId(userId);
    }
    public boolean addUserFriend(UserFriends userFriend) {
        // 동일한 userId와 friendNick을 가진 데이터가 있는지 확인
        Optional<UserFriends> existingUserFriend = userFriendsRepository.findByUserIdAndFriendId(userFriend.getUserId(), userFriend.getFriendId());

        if (existingUserFriend.isPresent()) {
            // 이미 존재하는 경우, false 반환
            return false;
        } else {
            // 존재하지 않는 경우, 데이터 저장
            userFriendsRepository.save(userFriend);
            UserFriends userFriendtoFriend = new UserFriends();
            userFriendtoFriend.setUserId(userFriend.getFriendId());
            userFriendtoFriend.setFriendId(userFriend.getUserId());
            userFriendsRepository.save(userFriendtoFriend);

            return true;
        }
    }

    public boolean deleteUserFriend(String userId, String friendId) {
        // 동일한 userId와 friendNick을 가진 데이터가 있는지 확인
        Optional<UserFriends> existingUserFriend = userFriendsRepository.findByUserIdAndFriendId(userId, friendId);

        if (existingUserFriend.isPresent()) {
            // 이미 존재하는 경우, 데이터 삭제
            userFriendsRepository.delete(existingUserFriend.get());
            return true;
        } else {
            // 존재하지 않는 경우, false 반환
            return false;
        }
    }


}
