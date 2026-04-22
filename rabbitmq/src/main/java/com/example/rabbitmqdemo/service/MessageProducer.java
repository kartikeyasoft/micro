package com.example.rabbitmqdemo.service;

import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class MessageProducer {
    @Autowired
    private RabbitTemplate rabbitTemplate;

//    public void send(String message) {
//        rabbitTemplate.convertAndSend("message-queue", message);
//    }
}