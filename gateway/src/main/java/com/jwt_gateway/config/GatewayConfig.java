package com.jwt_gateway.config;

import com.jwt_gateway.filter.JwtAuthenticationFilter;
import org.springframework.cloud.gateway.route.RouteLocator;
import org.springframework.cloud.gateway.route.builder.RouteLocatorBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class GatewayConfig {

    private final JwtAuthenticationFilter filter;

    public GatewayConfig(JwtAuthenticationFilter filter) {
        this.filter = filter;
    }

    @Bean
    public RouteLocator routes(RouteLocatorBuilder builder) {
        return builder.routes()
                .route("service1-route", r -> r
                        .path("/api/service1/**")
                        .filters(f -> f
                                .filter(filter)
                                .stripPrefix(2))  // Removes /api/service1
                        .uri("lb://service1"))   // ← Uses Eureka service discovery!
                
                .route("service2-route", r -> r
                        .path("/api/service2/**")
                        .filters(f -> f
                                .filter(filter)
                                .stripPrefix(2))  // Removes /api/service2
                        .uri("lb://service2"))   // ← Uses Eureka service discovery!
                
                .build();
    }
}