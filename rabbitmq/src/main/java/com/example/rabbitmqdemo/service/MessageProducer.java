package com.ksapp.rabbitmqdemo.service;  // Changed package

import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class MessageProducer {
    @Autowired
    private RabbitTemplate rabbitTemplate;

    // Add send method if needed
    public void send(String message) {
        rabbitTemplate.convertAndSend("my-exchange", "my-routing-key", message);
    }
}
