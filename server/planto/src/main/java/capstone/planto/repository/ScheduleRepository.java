package capstone.planto.repository;

import capstone.planto.domain.Schedule;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDateTime;
import java.util.List;

public interface ScheduleRepository extends JpaRepository<Schedule, Long> {
    List<Schedule> findByUserID(String userID);

    List<Schedule> findByUserIDAndPlanFlag(String userID, Boolean planFlag);

    @Query("SELECT s FROM Schedule s WHERE s.userID = :userID AND s.startTime >= :startTime AND s.endTime <= :endTime")
    List<Schedule> findByUserIDAndPeriod(@Param("userID") String userID, @Param("startTime") LocalDateTime startTime, @Param("endTime") LocalDateTime endTime);

    @Query("SELECT s FROM Schedule s WHERE s.title LIKE %:searchTerm% OR s.explanation LIKE %:searchTerm%")
    List<Schedule> findByTitleContainingOrContentContaining(@Param("searchTerm") String searchTerm);
}
