package com.ssafy.pizza.model.service;

import com.ssafy.pizza.model.dto.User;

public interface UserService {
    int join(User user);

    User login(String id, String pw);

    User getByUserId(Integer userId);

    boolean isUserIdAvailable(String id);

    int addStamp(Integer userId, Integer count);
}

