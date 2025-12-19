package com.ssafy.pizza.model.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ssafy.pizza.model.dao.CommentDao;
import com.ssafy.pizza.model.dto.Comment;
import com.ssafy.pizza.model.dto.CommentInfo;

@Service
public class CommentServiceImpl implements CommentService {

    @Autowired
    private CommentDao cDao;

    @Override
    public int addComment(Comment comment) {
        return cDao.insert(comment);
    }

    @Override
    public List<CommentInfo> getCommentsByProduct(Integer productId) {
        return cDao.selectByProduct(productId);
    }
}

