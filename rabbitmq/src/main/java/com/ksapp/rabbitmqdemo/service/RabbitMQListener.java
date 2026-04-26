package com.ksapp.rabbitmqdemo.service;

import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

@Component
public class RabbitMQListener {

    @Autowired
    private SimpMessagingTemplate messagingTemplate;

    @Autowired
    private RestTemplate restTemplate;  // This is @LoadBalanced

    @RabbitListener(queues = "my-queue")
    public void receiveMessage(String message) {
        try {
            System.out.println("Received from RabbitMQ: " + message);
            
            // Send to WebSocket clients
            messagingTemplate.convertAndSend("/topic/messages", message);

            // Use service discovery - "redis" service name from Eureka
            String redisUrl = "http://redis/redis/sendToredis";
            ResponseEntity<String> response = restTemplate.postForEntity(redisUrl, message, String.class);
            
            System.out.println("Send Message SUCCESS: " + response.getBody());
        } catch (Exception exception) {
            System.err.println("Exception: " + exception.getMessage());
        }
    }
}