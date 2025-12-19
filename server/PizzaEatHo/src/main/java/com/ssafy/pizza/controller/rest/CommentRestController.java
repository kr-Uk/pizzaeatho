package com.ssafy.pizza.controller.rest;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
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
}

