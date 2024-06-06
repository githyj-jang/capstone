package capstone.planto.repository;

import capstone.planto.domain.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.util.Optional;
import java.util.List;
public interface UserRepository extends JpaRepository<User, String> {
    Optional<User> findByNick(String nick);
    Optional<User> findByUserId(String userId);

    @Query("SELECT u FROM User u WHERE u.nick LIKE %:searchTerm% OR u.userId LIKE %:searchTerm%")
    List<User> findByNickContainingOrIdContaining(@Param("searchTerm") String searchTerm);
}
