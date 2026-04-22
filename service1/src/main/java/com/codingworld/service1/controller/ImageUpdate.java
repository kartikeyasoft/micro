package com.codingworld.service1.controller;

import com.codingworld.service1.model.BackGroundColor;
import com.codingworld.service1.services.ImageDataService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;


@RestController
@RequestMapping("/images")
public class ImageUpdate {
  
    @Autowired
    private  ImageDataService service;

    @PostMapping("/set-background/{id}")
    public ResponseEntity<String> setBackground(@PathVariable Long id) {
        service.setBackgroundImage(id);
        return ResponseEntity.ok("Background set");
    }


    @GetMapping
    public List<BackGroundColor> getAllColors() {
        return service.getAllColors();
    }

    @PostMapping
    public BackGroundColor addColor(@RequestBody BackGroundColor color) {
        return service.addColor(color);
    }

    @PutMapping("/activate/{id}")
    public String activateColor(@PathVariable String id) {
        return service.activateColor(id);
    }

    @GetMapping("/a")
    public BackGroundColor getActiveColor() {
        return service.getActiveColor();
    }

}


