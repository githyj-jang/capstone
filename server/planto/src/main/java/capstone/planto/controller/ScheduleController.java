package capstone.planto.controller;

import capstone.planto.domain.Schedule;
import capstone.planto.service.ScheduleService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/schedules")
public class ScheduleController {

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

    @GetMapping("/user/different-places")
    public List<Schedule> getSchedulesByUserIDAndDifferentPlaces(@RequestParam String userID) {
        return scheduleService.getSchedulesByUserIDAndDifferentPlaces(userID);
    }
}
