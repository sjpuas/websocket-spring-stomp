package cl.test.controllers;

import cl.test.dto.ChatMessage;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessageHeaderAccessor;
import org.springframework.stereotype.Controller;

/**
 * Created by sjpuas on 19-12-14.
 */

@Controller
public class ChatController {

    @MessageMapping("/news")
    @SendTo("/topic/news")
    public ChatMessage news(SimpMessageHeaderAccessor headerAccessor, ChatMessage message) throws Exception {
        String sessionId = headerAccessor.getSessionId();
        return new ChatMessage(sessionId, "news " + message.getMessage());
    }

    @MessageMapping("/weather")
    @SendTo("/topic/weather")
    public ChatMessage weather(SimpMessageHeaderAccessor headerAccessor, ChatMessage message) throws Exception {
        String sessionId = headerAccessor.getSessionId();
        return new ChatMessage(sessionId, "weather " + message.getMessage());
    }

}
