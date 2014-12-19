package cl.test.dto;

/**
 * Created by sjpuas on 19-12-14.
 */
public class ChatMessage {

    private String nickname;
    private String message;

    public ChatMessage(String nickname, String message) {
        this.nickname = nickname;
        this.message = message;
    }

    public String getNickname() {
        return nickname;
    }

    public void setNickname(String nickname) {
        this.nickname = nickname;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }
}
