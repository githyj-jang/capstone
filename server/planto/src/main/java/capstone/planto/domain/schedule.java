package capstone.planto.domain;
import java.time.LocalDateTime;
import jakarta.persistence.*;


@Entity
@Table(name = "schedule")
public class Schedule {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String userID;
    private LocalDateTime startTime;

    private LocalDateTime  endTime;

    private String  explanation;

    private String startPlace;

    private String endPlace;

    private String startRoute;

    private String endRoute;

    private Boolean planFlag;



    public Schedule(){

    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }




    public String getStartPlace() {
        return startPlace;
    }

    public void setStartPlace(String startPlace) {
        this.startPlace = startPlace;
    }

    public String getEndPlace() {
        return endPlace;
    }

    public void setEndPlace(String endPlace) {
        this.endPlace = endPlace;
    }

    public String getStartRoute() {
        return startRoute;
    }

    public void setStartRoute(String startRoute) {
        this.startRoute = startRoute;
    }

    public String getEndRoute() {
        return endRoute;
    }

    public void setEndRoute(String endRoute) {
        this.endRoute = endRoute;
    }

    public Boolean getPlanFlag() {
        return planFlag;
    }

    public void setPlanFlag(Boolean planFlag) {
        this.planFlag = planFlag;
    }

    public String getUserID() {
        return userID;
    }

    public void setUserID(String userID) {
        this.userID = userID;
    }


    public LocalDateTime getEndTime() {
        return endTime;
    }

    public void setEndTime(LocalDateTime endTime) {
        this.endTime = endTime;
    }

    public LocalDateTime getStartTime() {
        return startTime;
    }

    public void setStartTime(LocalDateTime startTime) {
        this.startTime = startTime;
    }

    public String getExplanation() {
        return explanation;
    }

    public void setExplanation(String explanation) {
        this.explanation = explanation;
    }
}
