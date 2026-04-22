package com.jwt_gateway.config;

import com.jwt_gateway.filter.JwtAuthenticationFilter;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.cloud.gateway.route.RouteLocator;
import org.springframework.cloud.gateway.route.builder.RouteLocatorBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class GatewayConfig {

    private final JwtAuthenticationFilter filter;

    @Value("${service1.url:http://localhost:9001}")
    private String service1Url;

    @Value("${service2.url:http://localhost:9002}")
    private String service2Url;

    public GatewayConfig(JwtAuthenticationFilter filter) {
        this.filter = filter;
    }

    @Bean
    public RouteLocator routes(RouteLocatorBuilder builder) {
        return builder.routes()
                .route("service1-route", r -> r.path("/service1/**")
                        .filters(f -> f.filter(filter).rewritePath("/service1/(?<segment>.*)", "/${segment}"))
                        .uri(service1Url))
                .route("service2-route", r -> r.path("/service2/**")
                        .filters(f -> f.filter(filter).rewritePath("/service2/(?<segment>.*)", "/${segment}"))
                        .uri(service2Url))
                .build();
    }
}