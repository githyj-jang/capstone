package capstone.planto.repository;

import capstone.planto.domain.Schedule;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface ScheduleRepository extends JpaRepository<Schedule, Long> {
    List<Schedule> findByUserID(String userID);

    List<Schedule> findByUserIDAndPlanFlag(String userID, Boolean planFlag);

    @Query("SELECT s FROM Schedule s WHERE s.userID = :userID AND s.startPlace <> s.endPlace")
    List<Schedule> findByUserIDAndDifferentPlaces(@Param("userID") String userID);
}
