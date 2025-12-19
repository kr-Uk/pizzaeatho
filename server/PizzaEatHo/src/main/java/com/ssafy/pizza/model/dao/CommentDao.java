package com.ssafy.pizza.model.dao;

import java.util.List;

import com.ssafy.pizza.model.dto.Comment;
import com.ssafy.pizza.model.dto.CommentInfo;

public interface CommentDao {
    int insert(Comment comment);

    List<CommentInfo> selectByProduct(Integer productId);
}

