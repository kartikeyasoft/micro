package com.codingworld.service1.config;

import com.codingworld.service1.model.BackGroundColor;
import com.codingworld.service1.repo.BackGroundColorRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.util.Arrays;
import java.util.List;

@Configuration
public class SecurityConfig {
    @Bean
    public CommandLineRunner seedColors(BackGroundColorRepository repository) {
        return args -> {
            if (repository.count() == 0) {
                List<String> colors = Arrays.asList(
                        "primary", "accent", "warn", "red", "blue", "green", "purple",
                        "orange", "pink", "indigo", "cyan", "teal", "lime", "amber",
                        "brown", "gray", "black"
                );

                for (String color : colors) {
                    BackGroundColor bgColor = new BackGroundColor();
                    bgColor.setColor(color);
                    bgColor.setActive(false); // all inactive initially
                    repository.save(bgColor);
                }

                System.out.println("Default colors inserted into the database.");
            }
        };
    }
/*  @Bean
   public WebMvcConfigurer corsConfigurer() {
    return new WebMvcConfigurer() {
            @Override
            public void addCorsMappings(CorsRegistry registry) {
                registry.addMapping("/**")
                        .allowedOrigins("*")
                        .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS")
                        .allowedHeaders("*")
                        .allowCredentials(false);
            }
        };
    } */

}
