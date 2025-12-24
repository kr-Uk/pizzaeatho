package com.ssafy.pizza.model.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ssafy.pizza.model.dao.UserDao;
import com.ssafy.pizza.model.dto.User;

@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private UserDao userDao;

    @Override
    public int join(User user) {
        return userDao.insert(user);
    }

    @Override
    public User login(String id, String pw) {
        return userDao.selectByCredentials(id, pw);
    }

    @Override
    public User getByUserId(Integer userId) {
        return userDao.selectByUserId(userId);
    }

    @Override
    public boolean isUserIdAvailable(String id) {
        return userDao.countById(id) == 0;
    }
}

