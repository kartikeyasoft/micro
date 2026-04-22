package com.ksapp.rabbitmqdemo.controller;  // Changed package

import com.ksapp.rabbitmqdemo.service.MessageProducer;  // Changed import
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;

import java.util.List;

@RestController
@RequestMapping("/api/messages")
@CrossOrigin("*")
public class MessageController {

    @Value("${redis.service.url:http://localhost:1222/redis}")
    private String redisServiceUrl;

    @Autowired
    private MessageProducer producer;

    @Autowired
    private RabbitTemplate rabbitTemplate;

    @Autowired
    private RestTemplate template;

    @PostMapping("/send")
    public ResponseEntity<String> sendMessage(@RequestBody String message) {
        rabbitTemplate.convertAndSend("my-exchange", "my-routing-key", message);
        return ResponseEntity.ok("Message sent to RabbitMQ");
    }

    @GetMapping("/history")
    public ResponseEntity<?> getNotificationHistory() {
        List<Object> history = template.getForObject(redisServiceUrl + "/history", List.class);
        return ResponseEntity.ok(history);
    }
}
