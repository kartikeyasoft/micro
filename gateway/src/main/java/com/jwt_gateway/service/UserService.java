package com.jwt_gateway.service;

import com.jwt_gateway.entity.UserData;
import com.jwt_gateway.repository.UserRepository;
import com.jwt_gateway.repository.UserReposs;
import com.jwt_gateway.util.JwtUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class UserService {

    @Autowired
    private  UserRepository userRepository;
    @Autowired
    private  JwtUtil jwtUtil;
    @Autowired
    private UserReposs userRep;
    @Autowired
    private  BCryptPasswordEncoder passwordEncoder;

    public UserService(UserReposs userRep, JwtUtil jwtUtil, BCryptPasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.jwtUtil = jwtUtil;
        this.passwordEncoder = passwordEncoder;
    }
//    public UserData findUserByUsername(String username) {
//        return userRepository.findByUsername(username);
//    }
    public String register(String username, String password) {

        UserData user1=userRepository.findByUsername(username);
        if (user1!=null) {
            throw new RuntimeException("User already exists");
        }

        UserData user = new UserData();
        user.setUsername(username);
        user.setPassword(passwordEncoder.encode(password)); // Encrypt password
        userRepository.save(user);
        return "User registered successfully";
    }

    public String login(String username, String password) {
        List<UserData> userOptional = userRep.findAll();
        UserData singleUser=null;
        for(UserData u:userOptional){
            if(u.getUsername().equals(username)){
                singleUser=u;
            }
        }

        System.out.println(userOptional+"::::::::::::::");
        if (singleUser == null) {
            throw new RuntimeException("User not found");
        }

        UserData user = singleUser;
        if (!passwordEncoder.matches(password, user.getPassword())) {
            throw new RuntimeException("Invalid credentials");
        }

        return jwtUtil.generateToken(username);
    }


    public Optional<UserData> getUser(String username) {

//return userServDataFIlters.findByUserName(username);
        return this.userRepository.findByUsernameWithRoles(username);
//        return this.userRepository.findByUsername(username);


    }


    public void deleteUser(Long userId) {
        this.userRepository.deleteById(userId);
    }

}
