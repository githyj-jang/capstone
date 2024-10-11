package capstone.planto.domain;
import java.time.LocalDateTime;
import jakarta.persistence.*;


@Entity
@Table(name = "schedule")
public class Schedule {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    private String title;

    private String userID;
    private LocalDateTime startTime;

    private LocalDateTime  endTime;

    private String  explanation;

    private Boolean planFlag; // true면 계획, false면 일정

    public Schedule(){

    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getUserID() {
        return userID;
    }

    public void setUserID(String userID) {
        this.userID = userID;
    }

    public LocalDateTime getStartTime() {
        return startTime;
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

    public String getExplanation() {
        return explanation;
    }

    public void setExplanation(String explanation) {
        this.explanation = explanation;
    }

    public Boolean getPlanFlag() {
        return planFlag;
    }

    public void setPlanFlag(Boolean planFlag) {
        this.planFlag = planFlag;
    }
}
