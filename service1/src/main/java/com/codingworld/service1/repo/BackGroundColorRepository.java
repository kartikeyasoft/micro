package com.codingworld.service1.repo;


import com.codingworld.service1.model.BackGroundColor;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface BackGroundColorRepository extends JpaRepository<BackGroundColor, Long> {
    Optional<BackGroundColor> findByColor(String color);
}
