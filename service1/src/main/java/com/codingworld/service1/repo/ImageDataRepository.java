package com.codingworld.service1.repo;

import com.codingworld.service1.model.ImageData;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

import javax.transaction.Transactional;
import java.util.Optional;

public interface ImageDataRepository extends JpaRepository<ImageData, Long> {

    Optional<ImageData> findByIsBackgroundTrue();
//    @Modifying
//    @Transactional
//    @Query("UPDATE ImageData i SET i.isBackground = false WHERE i.isBackground = true")
//   public void clearBackgroundFlags();
}
