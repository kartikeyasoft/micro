package com.jwt_gateway.filter;

import com.jwt_gateway.util.JwtUtil;
import org.springframework.cloud.gateway.filter.GatewayFilter;
import org.springframework.cloud.gateway.filter.GatewayFilterChain;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.http.server.reactive.ServerHttpRequest;
import org.springframework.http.server.reactive.ServerHttpResponse;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Mono;

import java.util.List;
import java.util.function.Predicate;

@Component
public class JwtAuthenticationFilter implements GatewayFilter {
    private final JwtUtil jwtUtil;

    public JwtAuthenticationFilter(JwtUtil jwtUtil) {
        this.jwtUtil = jwtUtil;
    }

    @Override
    public Mono<Void> filter(ServerWebExchange exchange, GatewayFilterChain chain) {
        ServerHttpRequest request = exchange.getRequest();

        System.out.println("Request URI: " + request.getURI());
        System.out.println("Request Method: " + request.getMethod());
        if (request.getMethod() == HttpMethod.OPTIONS) {
            ServerHttpResponse response = exchange.getResponse();
            response.setStatusCode(HttpStatus.OK);
            return response.setComplete();
        }

        // List of endpoints that do not require JWT authentication
        final List<String> apiEndpoints = List.of("/auth/register", "/auth/login", "/eureka");

        // Predicate to check if the request path is not in the unsecured endpoints
        Predicate<ServerHttpRequest> isApiSecured = r -> apiEndpoints.stream()
                .noneMatch(uri -> r.getURI().getPath().contains(uri));

        // If the request path is not in the unsecured endpoints, validate JWT token
        if (isApiSecured.test(request)) {
            if (!request.getHeaders().containsKey("Authorization")) {
                return onError(exchange, HttpStatus.UNAUTHORIZED);
            }

            String token = request.getHeaders().getFirst("Authorization");
            if (token != null && token.startsWith("Bearer ")) {
                token = token.substring(7);
            } else {
                return onError(exchange, HttpStatus.UNAUTHORIZED);
            }

            try {
                jwtUtil.validateToken(token);
            } catch (Exception e) {
                return onError(exchange, HttpStatus.UNAUTHORIZED);
            }
        }

        return chain.filter(exchange).doOnSuccess(aVoid -> {
            ServerHttpResponse response = exchange.getResponse();
            HttpStatus statusCode = (HttpStatus) response.getStatusCode();
            if (statusCode != null) {
                System.out.println("Response Status Code: " + statusCode.value());
            } else {
                System.out.println("Response Status Code is unknown");
            }
        });
    }

    // Method to handle errors and send an unauthorized response
    private Mono<Void> onError(ServerWebExchange exchange, HttpStatus status) {
        ServerHttpResponse response = exchange.getResponse();
        response.setStatusCode(status);

        // Log error and set response
        System.err.println("Unauthorized request: " + status + " at " + exchange.getRequest().getURI());
        return response.setComplete();
    }
}
