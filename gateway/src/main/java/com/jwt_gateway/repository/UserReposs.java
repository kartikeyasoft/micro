package com.jwt_gateway.repository;

import com.jwt_gateway.entity.UserData;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserReposs extends JpaRepository<UserData, Long> {

    public UserData findByUsername(String username);
}

