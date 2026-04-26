package com.example.rabbitmqdemo.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cloud.client.ServiceInstance;
import org.springframework.cloud.client.discovery.DiscoveryClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

import java.util.List;

@RestController
public class MessageController {

    @Autowired
    private DiscoveryClient discoveryClient;
    
    @Autowired
    private RestTemplate restTemplate;
    
    @GetMapping("/history")
    public List<Object> getHistory() {
        String redisUrl = getRedisServiceUrl();
        String url = redisUrl + "/redis/history";
        List<Object> history = restTemplate.getForObject(url, List.class);
        return history;
    }
    
    private String getRedisServiceUrl() {
        ServiceInstance redisInstance = discoveryClient.getInstances("redis")
            .stream()
            .findFirst()
            .orElse(null);
        
        if (redisInstance != null) {
            return "http://" + redisInstance.getHost() + ":" + redisInstance.getPort();
        }
        return "http://localhost:1222";
    }
}