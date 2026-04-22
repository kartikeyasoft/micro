package com.codingworld.service1.controller;

import com.codingworld.service1.model.ImageDTO;
import com.codingworld.service1.model.ImageData;
import com.codingworld.service1.services.ImageDataService;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/images")
public class ImageDataController {

    private final ImageDataService service;

    public ImageDataController(ImageDataService service) {
        this.service = service;
    }

    @PostMapping("/upload")
    public ResponseEntity<?> uploadImage(
            @RequestParam("image") MultipartFile file,
            @RequestParam("description") String description,
            @RequestParam(name="isBackground") boolean isBackground) {
        try {
            return ResponseEntity.ok(service.saveImage(file, description,isBackground));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Failed to upload: " + e.getMessage());
        }
    }
    @GetMapping("/{id}")
    public ResponseEntity<byte[]> getImage(@PathVariable Long id) {
        Optional<ImageData> imageDataOptional = service.getImageById(id);

        if (imageDataOptional.isEmpty()) {
            return ResponseEntity.notFound().build();
        }

        ImageData imageData = imageDataOptional.get();

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.IMAGE_JPEG); // or IMAGE_PNG based on content
        return new ResponseEntity<>(imageData.getImage(), headers, HttpStatus.OK);
    }
    @GetMapping
    public List<ImageDTO> listImages() {
        return service.getAllImages().stream()
                .map(image -> new ImageDTO(
                        image.getId(),
                        "http://localhost:9001/api/images/" + image.getId(),
                        image.getDescription()))
                .collect(Collectors.toList());
    }


    @GetMapping("/background")
    public ResponseEntity<byte[]> getBackgroundImage() {
        Optional<ImageData> bgOpt = service.getBackgroundImage();
        if (bgOpt.isEmpty()) return ResponseEntity.notFound().build();

        ImageData imageData = bgOpt.get();
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.IMAGE_JPEG);
        return new ResponseEntity<>(imageData.getImage(), headers, HttpStatus.OK);
    }



    @GetMapping("/file/{filename:.+}")
    public ResponseEntity<byte[]> getFile(@PathVariable String filename) {
        try {
            File file = new File("uploads/" + filename);
            if (!file.exists()) return ResponseEntity.notFound().build();

            byte[] imageBytes = java.nio.file.Files.readAllBytes(file.toPath());

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.IMAGE_JPEG); // Or detect by extension
            return new ResponseEntity<>(imageBytes, headers, HttpStatus.OK);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }





}
