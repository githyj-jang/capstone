package capstone.planto.service;

import capstone.planto.domain.Schedule;
import capstone.planto.repository.ScheduleRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class ScheduleService {

    @Autowired
    private final ScheduleRepository scheduleRepository;

    public ScheduleService(ScheduleRepository scheduleRepository) {
        this.scheduleRepository = scheduleRepository;
    }

    public Schedule addSchedule(Schedule schedule) {
        if (schedule.getStartTime().isAfter(schedule.getEndTime())) {
            throw new IllegalArgumentException("시작 시간이 종료 시간보다 늦을 수 없습니다.");
        }
        if(schedule.getExplanation() == null) {
            schedule.setExplanation(schedule.getTitle())    ;
        }
        return scheduleRepository.save(schedule);
    }

    public List<Schedule> getSchedulesByUserID(String userID) {
        return scheduleRepository.findByUserID(userID);
    }

    public List<Schedule> getSchedulesByUserIDAndPlanFlag(String userID, Boolean planFlag) {
        return scheduleRepository.findByUserIDAndPlanFlag(userID, planFlag);
    }

    public List<Schedule> getSchedulesByUserIDAndPeriod(String userID, LocalDateTime startTime, LocalDateTime endTime) {
        return scheduleRepository.findByUserIDAndPeriod(userID, startTime, endTime);
    }

    public void deleteSchedule(Long scheduleID) {
        scheduleRepository.deleteById(scheduleID);
    }

    public Schedule updateSchedule(Schedule schedule) {
        return scheduleRepository.save(schedule);
    }

    public List<Schedule> getSchedulesBySearchTerm(String searchTerm) {
        return scheduleRepository.findByTitleContainingOrContentContaining(searchTerm);
    }
}
