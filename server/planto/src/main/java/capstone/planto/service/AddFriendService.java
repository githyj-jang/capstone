package capstone.planto.service;

import capstone.planto.domain.AddFriend;
import capstone.planto.repository.AddFriendRepository;
import jakarta.transaction.Transactional;
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
    @Transactional
    public void deleteFriend(String userId, String friendId) {
        addFriendRepository.deleteByUserIdAndFriendId(userId, friendId);
    }
    public void friendDelete(String userId, String friendId) {
        addFriendRepository.deleteByUserIdAndFriendId(friendId, userId);
    }

    public List<AddFriend> listFriends(String userId) {
        return addFriendRepository.findAllByFriendId(userId);
    }

    public List<AddFriend> Friendslist(String userId) {
        return addFriendRepository.findAllByUserId(userId);
    }

    public List<AddFriend> listFriendsByFriendId(String friendId) {
        return addFriendRepository.findAllByFriendId(friendId);
    }



}
