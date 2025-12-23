package com.ssafy.pizza.controller.rest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.ssafy.pizza.model.dto.User;
import com.ssafy.pizza.model.dto.UserLoginRequest;
import com.ssafy.pizza.model.dto.UserLoginResponse;
import com.ssafy.pizza.model.dto.UserRegisterRequest;
import com.ssafy.pizza.model.dto.UserResponse;
import com.ssafy.pizza.model.service.UserService;

@RestController
@RequestMapping("/pizza/user")
@CrossOrigin("*")
public class UserRestController {

    @Autowired
    private UserService uService;

    @PostMapping("")
    public boolean register(@RequestBody UserRegisterRequest request) {
        User user = new User();
        user.setId(request.getId());
        user.setPw(request.getPw());
        user.setName(request.getName());
        user.setStamp(0);

        int result = uService.join(user);
        return result > 0;
    }

    @PostMapping("/login")
    public UserLoginResponse login(@RequestBody UserLoginRequest request) {
        User user = uService.login(request.getId(), request.getPw());
        if (user == null) {
            return null;
        }
        return new UserLoginResponse(user.getUserId(), user.getName(), user.getStamp());
    }

    @GetMapping("/{userId}")
    public UserResponse getUser(@PathVariable Integer userId) {
        User user = uService.getByUserId(userId);
        if (user == null) {
            return null;
        }
        return new UserResponse(user.getUserId(), user.getId(), user.getName(), user.getStamp());
    }

    @GetMapping("/checkid/{userId}")
    public boolean checkUserId(@PathVariable String userId) {
        return uService.isUserIdAvailable(userId);
    }
}

