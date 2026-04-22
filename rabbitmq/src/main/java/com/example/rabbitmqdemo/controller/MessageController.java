package com.example.rabbitmqdemo.controller;

import com.example.rabbitmqdemo.service.MessageProducer;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.ListOperations;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;

import java.util.List;

@RestController
@RequestMapping("/api/messages")
@CrossOrigin("*")
public class MessageController {

    @Autowired
    private MessageProducer producer;
    @Autowired
    private SimpMessagingTemplate messagingTemplate;
//    @Autowired
//    private RedisTemplate<String, Object> redisTemplate;
@Autowired
private RabbitTemplate rabbitTemplate;


    @Autowired
    private RestTemplate  template;


//    @PostMapping("/send")
//    public ResponseEntity<String> sendMessage(@RequestBody String message) {
//        producer.send(message);
//        messagingTemplate.convertAndSend("/topic/messages", message);
//        return ResponseEntity.ok("Message sent to RabbitMQ and WebSocket");
//    }



        @PostMapping("/send")
        public ResponseEntity<String> sendMessage(@RequestBody String message) {
            rabbitTemplate.convertAndSend("my-exchange", "my-routing-key", message);
            return ResponseEntity.ok("Message sent to RabbitMQ");
        }

    @GetMapping("/history")
    public ResponseEntity<?> getNotificationHistory() {


        List<Object> history =    template.getForObject("http://192.168.29.67:1222/redis/history",List.class);

//        ListOperations<String, Object> listOps = redisTemplate.opsForList();
//        List<Object> history = listOps.range("notificationHistory", 0, -1);
//

        return ResponseEntity.ok(history);
    }
    }











