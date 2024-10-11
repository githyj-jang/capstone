package capstone.planto.controller;

import capstone.planto.domain.Itiinerary;
import capstone.planto.domain.Schedule;
import capstone.planto.service.ItiineraryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@CrossOrigin(origins = "*")
@RestController
@RequestMapping("/itinerary")
public class itiineraryController {

    @Autowired
    private ItiineraryService itiineraryService;

    @Autowired
    private ScheduleController scheduleController;

    @PostMapping("/add")
    public Itiinerary addItiinerary(@RequestBody Itiinerary itiinerary) {
        return itiineraryService.addItiinerary(itiinerary);
    }

    @GetMapping("/{id}")
    public Optional<Itiinerary> getItiineraryById(@PathVariable Long id) {
        return itiineraryService.getItiineraryById(id);
    }

    @GetMapping("/all/{userId}")
    public List<Itiinerary> getAllItiineraries(@PathVariable String userId) {
        List<Schedule> sechedules = scheduleController.getSchedulesByUserID(userId);
        List<Itiinerary> result = new ArrayList<>();
        for (Schedule schedule : sechedules) {
            result.addAll(itiineraryService.getItiinerariesByScheduleID(Long.valueOf(schedule.getId())));
        }
        return result;
    }

    @PutMapping("/update")
    public Itiinerary updateItiinerary(@RequestBody Itiinerary itiinerary) {
        return itiineraryService.updateItiinerary(itiinerary);
    }

    @DeleteMapping("/delete/{id}")
    public void deleteItiinerary(@PathVariable Long id) {
        itiineraryService.deleteItiinerary(id);
    }

    // 같은 scheduleID를 가진 Itiinerary들을 반환
    @GetMapping("/schedule")
    public List<Itiinerary> getItiinerariesByScheduleID(@RequestParam Long scheduleID) {
        return itiineraryService.getItiinerariesByScheduleID(scheduleID);
    }

    // 같은 scheduleID를 가진 Itiinerary들을 제거
    @DeleteMapping("/delete/schedule")
    public void deleteItiinerariesByScheduleID(@RequestParam Long scheduleID) {
        itiineraryService.deleteItiinerariesByScheduleID(scheduleID);
    }

}
