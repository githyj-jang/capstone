package capstone.planto.repository;

import capstone.planto.domain.AddFriend;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface AddFriendRepository extends JpaRepository<AddFriend, String> {
    Optional<AddFriend> findByUserIdAndFriendNickAndFriendId(String userId, String friendNick, String friendId);
    List<AddFriend> findAllByUserId(String userId);
    void deleteByUserIdAndFriendId(String userId, String friendId);
}
