package com.jwt_gateway.config;

import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import org.springframework.web.filter.CorsFilter;

@Configuration
public class SecurityConfig {
//
//    @Bean
//
//    public FilterRegistrationBean<CorsFilter> corsFilter() {
//
//        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
//
//        CorsConfiguration config = new CorsConfiguration();
//
//        config.setAllowCredentials(true);
//
//        config.addAllowedOrigin("http://localhost:4200");
//
//        config.addAllowedHeader("*");
//
//        config.addAllowedMethod("*");
//
//        source.registerCorsConfiguration("/**", config);
//
//        FilterRegistrationBean<CorsFilter> bean = new FilterRegistrationBean<CorsFilter>(
//
//                new CorsFilter(source));
//
//        bean.setOrder(0);
//
//        return bean;
//
//    }
    @Bean
    public BCryptPasswordEncoder passwordEncoder(){
        return new BCryptPasswordEncoder();
    }
}
