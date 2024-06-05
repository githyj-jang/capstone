package capstone.planto.service;

import capstone.planto.domain.AddFriend;
import capstone.planto.repository.AddFriendRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class AddFriendService {

    @Autowired
    private AddFriendRepository addFriendRepository;

    public boolean addFriend(AddFriend addFriend) {
        if (addFriendRepository.findByUserIdAndFriendNickAndFriendId(addFriend.getUserId(), addFriend.getFriendNick(), addFriend.getFriendId()).isPresent()) {
            return false; // 이미 데이터가 존재하는 경우
        }
        addFriendRepository.save(addFriend);
        return true;
    }

    public void deleteFriend(String userId, String friendId) {
        addFriendRepository.deleteByUserIdAndFriendId(userId, friendId);
    }

    public List<AddFriend> listFriends(String userId) {
        return addFriendRepository.findAllByUserId(userId);
    }
}
