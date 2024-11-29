package capstone.planto.domain;
import java.time.LocalDateTime;
import jakarta.persistence.*;


@Entity
@Table(name = "itiinerary")
public class Itiinerary {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // 스케쥴 아이디
    private Long scheduleID;

    // 장소
    private String place;
    
    // 추가적인 장소 정보
    private String placeInfo;

    // 같은 스케쥴 내에서의 순서
    private Integer route;

    private String description;

    // 예상시간
    private LocalDateTime startTime;

    private LocalDateTime endTime;

    public String getPlaceInfo() {

        return placeInfo;
    }

    public void setPlaceInfo(String placeInfo) {
        this.placeInfo = placeInfo;
    }

    public Itiinerary(){

    }

    public Long getId() {
        return id;
    }

    public Long getScheduleID() {
        return scheduleID;
    }

    public String getPlace() {
        return place;
    }

    public Integer getRoute() {
        return route;
    }

    public LocalDateTime getStartTime() {
        return startTime;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public void setScheduleID(Long scheduleID) {
        this.scheduleID = scheduleID;
    }

    public void setPlace(String place) {
        this.place = place;
    }

    public void setRoute(Integer route) {
        this.route = route;
    }

    public void setStartTime(LocalDateTime startTime) {
        this.startTime = startTime;
    }

    public LocalDateTime getEndTime() {
        return endTime;
    }

    public void setEndTime(LocalDateTime endTime) {
        this.endTime = endTime;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}
