package com.Redis.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.ListOperations;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/redis")
@CrossOrigin("*")
public class RedisController {

    @Autowired
    private RedisTemplate<String, Object> redisTemplate;



    @GetMapping("/history")
    public ResponseEntity<?> getNotificationHistory() {
        ListOperations<String, Object> listOps = redisTemplate.opsForList();
        List<Object> history = listOps.range("notificationHistory", 0, -1);


        return ResponseEntity.ok(history);
    }


    @PostMapping("/sendToredis")
    public ResponseEntity<?> saveInRedis(@RequestBody String message){
        try {
            ListOperations<String, Object> listOps = redisTemplate.opsForList();
            listOps.leftPush("notificationHistory", message);
        }
        catch (Exception exception){
            System.err.println("Exception:::::!!!!! " + exception);

        }
        return ResponseEntity.ok("Message Sent Successfull");
    }


}
