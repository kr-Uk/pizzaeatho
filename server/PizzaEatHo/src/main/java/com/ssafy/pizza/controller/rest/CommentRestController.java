package com.ssafy.pizza.controller.rest;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.ssafy.pizza.model.dto.Comment;
import com.ssafy.pizza.model.dto.CommentInfo;
import com.ssafy.pizza.model.service.CommentService;

@RestController
@RequestMapping("/pizza/comment")
@CrossOrigin("*")
public class CommentRestController {

    @Autowired
    private CommentService cService;

    @PostMapping("")
    public boolean addComment(@RequestBody Comment comment) {
        return cService.addComment(comment) > 0;
    }

    @GetMapping("/product/{productId}")
    public List<CommentInfo> getCommentsByProduct(@PathVariable Integer productId) {
        return cService.getCommentsByProduct(productId);
    }

    @PutMapping("/{commentId}/user/{userId}")
    public boolean updateComment(
            @PathVariable Integer commentId,
            @PathVariable Integer userId,
            @RequestBody Comment comment) {
        comment.setCommentId(commentId);
        comment.setUserId(userId);
        return cService.updateComment(comment) > 0;
    }

    @DeleteMapping("/{commentId}/user/{userId}")
    public boolean deleteComment(@PathVariable Integer commentId, @PathVariable Integer userId) {
        return cService.deleteComment(commentId, userId) > 0;
    }
}

