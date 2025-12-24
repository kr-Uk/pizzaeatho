package com.ssafy.pizza.model.service;

import java.util.List;

import com.ssafy.pizza.model.dto.Comment;
import com.ssafy.pizza.model.dto.CommentInfo;

public interface CommentService {
    int addComment(Comment comment);

    List<CommentInfo> getCommentsByProduct(Integer productId);

    int updateComment(Comment comment);

    int deleteComment(Integer commentId, Integer userId);
}

