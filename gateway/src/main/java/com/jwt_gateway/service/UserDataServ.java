package com.jwt_gateway.service;

import com.jwt_gateway.entity.UserData;
import com.jwt_gateway.entity.UserRole;

import java.util.Set;

public interface UserDataServ {
    //creating user
    public UserData createUser(UserData user, Set<UserRole> userRoles) throws Exception;

    //get user by username
    public UserData getUser(String username);

    //delete user by id
    public void deleteUser(Long userId);
}
