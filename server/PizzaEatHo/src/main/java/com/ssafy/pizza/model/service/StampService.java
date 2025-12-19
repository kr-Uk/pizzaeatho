package com.ssafy.pizza.model.service;

import java.util.List;
import com.ssafy.pizza.model.dto.Stamp;


public interface StampService {
    /**
     * id ?¬ìš©?ì˜ Stamp ?´ë ¥??ë°˜í™˜?œë‹¤.
     * @param id
     * @return
     */
    List<Stamp> selectByUser(String id);
}

