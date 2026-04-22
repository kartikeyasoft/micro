package com.jwt_gateway.config;

import com.jwt_gateway.entity.Role;
import com.jwt_gateway.entity.UserData;
import com.jwt_gateway.entity.UserRole;
import com.jwt_gateway.repository.RoleRepository;
import com.jwt_gateway.service.UserDataServ;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.event.EventListener;
import org.springframework.scheduling.concurrent.ThreadPoolTaskScheduler;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Component;

import java.nio.file.attribute.UserPrincipalNotFoundException;
import java.time.Instant;
import java.util.*;

@Component
public class DataIntalizeINDb {

    private final ThreadPoolTaskScheduler scheduler;

    @Autowired
    private BCryptPasswordEncoder bCryptPasswordEncoder;

    @Autowired
    private UserDataServ userService;

    @Autowired
    private RoleRepository roleRepository;

    public DataIntalizeINDb(ThreadPoolTaskScheduler scheduler) {
        this.scheduler = scheduler;
    }

    @EventListener(org.springframework.boot.context.event.ApplicationReadyEvent.class)
    public void scheduleTaskAfterDelay() {
        System.out.println("Application started, scheduling task...");
        scheduler.schedule(() -> {
            try {
                runTask();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }, Instant.now().plusSeconds(10)); // Delayed by 10 seconds
    }

    public void runTask() throws Exception {
        System.out.println("Executing task after 10 seconds delay!");
        run();
    }

    public void run() throws Exception {
        try {
            System.out.println("Starting user data initialization...");

            // Initialize roles in the database first
            List<Map<String, Object>> roleData = List.of(
                    new HashMap<>() {{
                        put("id", 44L);
                        put("name", "ADMIN");
                    }},
                    new HashMap<>() {{
                        put("id", 45L);
                        put("name", "NORMAL");
                    }}
            );

            // Save roles if they don't already exist
            roleData.forEach(roleMap -> {
                Role role = new Role();
                role.setRoleId((Long) roleMap.get("id"));
                role.setRoleName((String) roleMap.get("name"));

                if (!roleRepository.existsById(role.getRoleId())) {
                    roleRepository.save(role);
                }
            });

            // Verify roles are saved in the database before proceeding with users
            Role role1 = roleRepository.findById(44L).orElseThrow(() -> new RuntimeException("Role with ID 44 not found"));
            Role role2 = roleRepository.findById(45L).orElseThrow(() -> new RuntimeException("Role with ID 45 not found"));

            // User 1 with roleId 44 (ADMIN)
            UserData user1 = new UserData();
            user1.setFirstName("admin");
            user1.setLastName("admin");
            user1.setUsername("admin");
            user1.setPassword(this.bCryptPasswordEncoder.encode("admin"));
            user1.setEmail("admin@gmail.com");
            user1.setProfile("default.png");

            Set<UserRole> userRoleSet1 = new HashSet<>();
            UserRole userRole1 = new UserRole();
            userRole1.setRole(role1);
            userRole1.setUser(user1);
            userRoleSet1.add(userRole1);

            UserData savedUser1 = this.userService.createUser(user1, userRoleSet1);
            System.out.println("User created with username: " + savedUser1.getUsername());

            // User 2 with roleId 45 (USER)
            UserData user2 = new UserData();
            user2.setFirstName("client");
            user2.setLastName("client");
            user2.setUsername("client");
            user2.setPassword(this.bCryptPasswordEncoder.encode("12345"));
            user2.setEmail("client@gmail.com");
            user2.setProfile("default.png");

            Set<UserRole> userRoleSet2 = new HashSet<>();
            UserRole userRole2 = new UserRole();
            userRole2.setRole(role2);
            userRole2.setUser(user2);
            userRoleSet2.add(userRole2);

            UserData savedUser2 = this.userService.createUser(user2, userRoleSet2);
            System.out.println("User created with username: " + savedUser2.getUsername());

        } catch (UserPrincipalNotFoundException e) {
            e.printStackTrace();
        }
    }

}
