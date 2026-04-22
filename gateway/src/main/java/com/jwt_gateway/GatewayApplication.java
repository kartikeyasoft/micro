package com.jwt_gateway;

import com.jwt_gateway.entity.Role;
import com.jwt_gateway.entity.UserData;
import com.jwt_gateway.entity.UserRole;
import com.jwt_gateway.service.UserDataServ;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import java.nio.file.attribute.UserPrincipalNotFoundException;
import java.util.HashSet;
import java.util.Set;

@SpringBootApplication
@EnableDiscoveryClient
public class GatewayApplication
//		implements CommandLineRunner
{
//	@Autowired
//	private BCryptPasswordEncoder bCryptPasswordEncoder;
//	@Autowired
//	private UserDataServ userService;
	public static void main(String[] args) {
		SpringApplication.run(GatewayApplication.class, args);
	}
//
//	@Override
//	public void run(String... args) throws Exception {
//		try {
//
//
//			System.out.println("starting code");
////
//			UserData user = new UserData();
//
//			user.setFirstName("Santhosh");
//			user.setLastName("Reddy");
//			user.setUsername("santhosh9201");
//			user.setPassword(this.bCryptPasswordEncoder.encode("Pro1234$"));
//			user.setEmail("santhoshreddy9201@gmail.com");
//			user.setProfile("default.png");
//
//			Role role1 = new Role();
//			role1.setRoleId(44L);
//			role1.setRoleName("ADMIN");
//
//			Set<UserRole> userRoleSet = new HashSet<>();
//			UserRole userRole = new UserRole();
//
//			userRole.setRole(role1);
//
//			userRole.setUser(user);
//
//			userRoleSet.add(userRole);
//
//			UserData user1 = this.userService.createUser(user, userRoleSet);
//			System.out.println(user1.getUsername());
//
//
//		} catch (UserPrincipalNotFoundException e) {
//			e.printStackTrace();
//
//
//		}
//	}

}
