package capstone.planto.domain;

import jakarta.persistence.*;

@Entity
public class AddFriend {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String userId;

    private String friendName;

    private String friendNick;

    private String friendId;

    public AddFriend(){

    }


    public String getFriendId() {
        return friendId;
    }

    public void setFriendId(String friendId) {
        this.friendId = friendId;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getFriendName() {
        return friendName;
    }

    public void setFriendName(String friendName) {
        this.friendName = friendName;
    }

    public String getFriendNick() {
        return friendNick;
    }

    public void setFriendNick(String friendNick) {
        this.friendNick = friendNick;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }
}
