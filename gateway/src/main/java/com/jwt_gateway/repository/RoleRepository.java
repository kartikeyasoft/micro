package com.jwt_gateway.repository;

import com.jwt_gateway.entity.Role;
import org.springframework.data.jpa.repository.JpaRepository;

public interface RoleRepository extends JpaRepository<Role,Long> {
}
