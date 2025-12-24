package com.ssafy.pizza.model.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.ssafy.pizza.model.dto.Comment;
import com.ssafy.pizza.model.dto.CommentInfo;

public interface CommentDao {
    int insert(Comment comment);

    List<CommentInfo> selectByProduct(Integer productId);

    int update(Comment comment);

    int deleteByIdAndUser(@Param("commentId") Integer commentId, @Param("userId") Integer userId);
}

