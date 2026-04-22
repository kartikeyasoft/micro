package com.example.rabbitmqdemo.controller;

import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.stereotype.Controller;

@Controller
public class WebSocketController {

    @MessageMapping("/send")
    @SendTo("/topic/messages")
    public String sendMessage(String message) {
        return message;
    }
}
