package com.jwt_gateway.controller;

import com.jwt_gateway.entity.Role;
import com.jwt_gateway.entity.UserData;
import com.jwt_gateway.entity.UserRole;
import com.jwt_gateway.service.UserDataServ;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.util.HashSet;
import java.util.Set;

@RestController
//@RequestMapping("/user")
@CrossOrigin("*")
public class UserDataController {


    @Autowired
    private UserDataServ userService;

    @Autowired
    private BCryptPasswordEncoder bCryptPasswordEncoder;


    @GetMapping("/da")
    public String fdta(){
        return "data not authorized";
    }
    //creating user
    @PostMapping("/")
    public UserData createUser(@RequestBody UserData user) throws Exception {


        user.setProfile("default.png");
        //encoding password with bcryptpasswordencoder

        user.setPassword(this.bCryptPasswordEncoder.encode(user.getPassword()));

        Set<UserRole> roles = new HashSet<>();

        Role role = new Role();
        role.setRoleId(45L);
        role.setRoleName("NORMAL");

        UserRole userRole = new UserRole();
        userRole.setUser(user);
        userRole.setRole(role);

        roles.add(userRole);


        return this.userService.createUser(user, roles);

    }

    @GetMapping("/{username}")
    public ResponseEntity<?>  getUser(@PathVariable("username") String username) {
        System.out.println(userService.getUser(username) + "::::::::::::::::::::::::");
        if (this.userService.getUser(username)==null) {
return  ResponseEntity.status(HttpStatus.NOT_FOUND).body("User Is Not Found");
        } else {
            return  ResponseEntity.status(HttpStatus.OK).body(this.userService.getUser(username));


        }
    }
    //delete the user by id
    @DeleteMapping("/{userId}")
    public void deleteUser(@PathVariable("userId") Long userId) {
        this.userService.deleteUser(userId);
    }


    //update api


//    @ExceptionHandler(UserFoundException.class)
//    public ResponseEntity<?> exceptionHandler(UserFoundException ex) {
//        return ResponseEntity.ok(ex.getMessage());
//    }
//


}
