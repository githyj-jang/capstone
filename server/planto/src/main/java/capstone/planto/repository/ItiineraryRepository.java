package capstone.planto.repository;

import capstone.planto.domain.Itiinerary;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ItiineraryRepository extends JpaRepository<Itiinerary, Long> {
    List<Itiinerary> findByScheduleID(Long scheduleID);
}