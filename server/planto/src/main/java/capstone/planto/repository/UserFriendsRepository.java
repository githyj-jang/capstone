package capstone.planto.repository;

import capstone.planto.domain.UserFriends;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;

@Repository
public interface UserFriendsRepository extends JpaRepository<UserFriends, Long> {
    List<UserFriends> findByUserId(String userId);
    Optional<UserFriends> findByUserIdAndFriendNick(String userId, String friendId);
}
