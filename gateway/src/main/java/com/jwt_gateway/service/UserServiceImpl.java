package com.jwt_gateway.service;


import com.jwt_gateway.entity.Role;
import com.jwt_gateway.entity.UserData;
import com.jwt_gateway.entity.UserRole;
import com.jwt_gateway.repository.RoleRepository;
import com.jwt_gateway.repository.UserReposs;
import com.jwt_gateway.util.UserServDataFIlters;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Set;

@Service
public class UserServiceImpl implements UserDataServ{


    @Autowired
    private UserReposs userRepository;

    @Autowired
    private RoleRepository roleRepository;

//    @Autowired
//    private UserServDataFIlters userServDataFIlters;
    //creating user
@Override
public UserData createUser(UserData user, Set<UserRole> userRoles) throws Exception {

    UserData local = this.userRepository.findByUsername(user.getUsername());

    if (local != null) {
        System.err.println(":::::::::::::::User is already there !!::::::::::::::");
        throw new Exception("User is already there !!");
    } else {
        // Save all roles in the UserRole set to ensure they are managed
        for (UserRole ur : userRoles) {
            Role role = ur.getRole();
            if (!roleRepository.existsById(role.getRoleId())) {
                roleRepository.save(role); // Save the role if not already in the database
            }
        }

        // Associate the UserRoles with the UserData
        user.getUserRoles().addAll(userRoles);

        // Save the user and cascade the UserRoles
        local = this.userRepository.save(user);
    }

    return local;
}


    //getting user by username
    @Override
    public UserData getUser(String username) {

//return userServDataFIlters.findByUserName(username);
        return this.userRepository.findByUsername(username);


    }

    @Override
    public void deleteUser(Long userId) {
        this.userRepository.deleteById(userId);
    }


}
