package com.jwt_gateway.util;

import com.jwt_gateway.entity.UserData;
import com.jwt_gateway.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UserServDataFIlters {

    @Autowired
    private UserRepository userRepository;



    public UserData findByUserName(String userName) {
        UserData matchedUser = null;
        List<UserData> allUsers = userRepository.findAll();
        for (UserData user : allUsers) {
            System.out.println(user.getUsername()+"::::::::::::username::::::::");
            if (user.getUsername().equals(userName)) {
                 matchedUser = user;
            } else if (user.getUsername()==userName) {
                matchedUser = user;
            } else {
                matchedUser= null;
            }
        }

        if(matchedUser!=null){
            return matchedUser;
        }else{
            return null;
        }

    }

    }



