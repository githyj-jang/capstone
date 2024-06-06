package capstone.planto.service;

import capstone.planto.domain.Schedule;
import capstone.planto.repository.ScheduleRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ScheduleService {

    private final ScheduleRepository scheduleRepository;

    public ScheduleService(ScheduleRepository scheduleRepository) {
        this.scheduleRepository = scheduleRepository;
    }

    public Schedule addSchedule(Schedule schedule) {
        return scheduleRepository.save(schedule);
    }

    public List<Schedule> getSchedulesByUserID(String userID) {
        return scheduleRepository.findByUserID(userID);
    }

    public List<Schedule> getSchedulesByUserIDAndPlanFlag(String userID, Boolean planFlag) {
        return scheduleRepository.findByUserIDAndPlanFlag(userID, planFlag);
    }

    public List<Schedule> getSchedulesByUserIDAndDifferentPlaces(String userID) {
        return scheduleRepository.findByUserIDAndDifferentPlaces(userID);
    }
}
