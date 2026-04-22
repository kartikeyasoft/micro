package com.ksapp.rabbitmqdemo.service;  // Changed package

import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

@Component
public class RabbitMQListener {

    @Value("${redis.service.url:http://localhost:1222/redis}")
    private String redisServiceUrl;

    @Autowired
    private SimpMessagingTemplate messagingTemplate;

    @Autowired
    private RestTemplate template;

    @RabbitListener(queues = "my-queue")
    public void receiveMessage(String message) {
        try {
            System.out.println("Received from RabbitMQ: " + message);
            messagingTemplate.convertAndSend("/topic/messages", message);

            ResponseEntity<String> response = template.postForEntity(
                redisServiceUrl + "/sendToredis",
                message,
                String.class
            );
            System.out.println("Send Message SUCCESS: " + response.getBody());
        } catch (Exception exception) {
            System.err.println("Exception: " + exception.getMessage());
        }
    }
}
