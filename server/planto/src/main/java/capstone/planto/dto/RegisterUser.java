package capstone.planto.dto;

public class RegisterUser {
    private String userId;
    private String pw;
    private String name;
    private String nick;

    public RegisterUser() {
    }

    public RegisterUser(String userId, String pw, String name, String nick) {
        this.userId = userId;
        this.pw = pw;
        this.name = name;
        this.nick = nick;
    }

    public String getUserId() {
        return userId;
    }

    public String getPw() {
        return pw;
    }

    public String getName() {
        return name;
    }

    public String getNick() {
        return nick;
    }
}
