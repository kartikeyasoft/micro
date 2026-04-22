package com.redis.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Set;
import java.util.concurrent.TimeUnit;

@RestController
@RequestMapping("/redis")
public class RedisController {

    @Autowired
    private RedisTemplate<String, String> redisTemplate;

    @PostMapping("/sendToredis")
    public String sendToRedis(@RequestBody String message) {
        String key = "message:" + System.currentTimeMillis();
        redisTemplate.opsForValue().set(key, message, 1, TimeUnit.HOURS);
        return "Message stored with key: " + key;
    }

    @GetMapping("/history")
    public List<String> getHistory() {
        Set<String> keys = redisTemplate.keys("message:*");
        if (keys == null || keys.isEmpty()) {
            return List.of();
        }
        return keys.stream()
                .map(key -> redisTemplate.opsForValue().get(key))
                .toList();
    }
}
