package com.ssafy.pizza.model.dao;

import org.apache.ibatis.annotations.Param;

import com.ssafy.pizza.model.dto.User;

public interface UserDao {
    int insert(User user);

    User selectByCredentials(@Param("id") String id, @Param("pw") String pw);

    User selectByUserId(@Param("userId") Integer userId);
}

