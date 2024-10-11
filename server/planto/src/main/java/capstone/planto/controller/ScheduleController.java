package capstone.planto.controller;

import capstone.planto.domain.Schedule;
import capstone.planto.service.ScheduleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;

@CrossOrigin(origins = "*")
@RestController
@RequestMapping("/schedules")
public class ScheduleController {

    @Autowired
    private final ScheduleService scheduleService;

    public ScheduleController(ScheduleService scheduleService) {
        this.scheduleService = scheduleService;
    }

    @PostMapping("/add")
    public Schedule addSchedule(@RequestBody Schedule schedule) {
        return scheduleService.addSchedule(schedule);
    }

    @GetMapping("/user")
    public List<Schedule> getSchedulesByUserID(@RequestParam String userID) {
        return scheduleService.getSchedulesByUserID(userID);
    }

    @GetMapping("/user/plan")
    public List<Schedule> getSchedulesByUserIDAndPlanFlag(@RequestParam String userID, @RequestParam Boolean planFlag) {
        return scheduleService.getSchedulesByUserIDAndPlanFlag(userID, planFlag);
    }

    // 주어진 기간안에 startTime부터 endTime까지가 포함되는 스케줄들을 반환
    @GetMapping("/user/schedule")
    public List<Schedule> getSchedulesByUserIDAndPeriod(
            @RequestParam String userID,
            @RequestParam LocalDateTime startTime,
            @RequestParam LocalDateTime endTime) {
        return scheduleService.getSchedulesByUserIDAndPeriod(userID, startTime, endTime);
    }


    // 스케줄 삭제
    @DeleteMapping("/delete")
    public void deleteSchedule(@RequestParam Long scheduleID) {
        scheduleService.deleteSchedule(scheduleID);
    }

    // 스케줄 수정
    @PutMapping("/update")
    public Schedule updateSchedule(@RequestBody Schedule schedule) {
        return scheduleService.addSchedule(schedule);
    }

    // 스케줄 조회
    @GetMapping("/search")
    public List<Schedule> searchSchedules(@RequestParam String searchTerm) {
        return scheduleService.getSchedulesBySearchTerm(searchTerm);
    }


    // 해당 시간임을 감시하면 특정 스케줄을 반환


}
