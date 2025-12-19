package com.ssafy.pizza.model.dao;

import java.util.List;
import com.ssafy.pizza.model.dto.Stamp;

public interface StampDao {
    /**
     * stamp?•ë³´ë¥??…ë ¥?œë‹¤.(make order?ì„œ)
     * order detail?ëŠ” ì£¼ë¬¸???ì„¸ ?´ì—­???¤ì–´ê°€ê³? 
     * ???Œì´ë¸”ì—???´ë‹¹ ì£¼ë¬¸ë²ˆí˜¸ë¡?ì´?ëª‡ê±´??ì£¼ë¬¸?˜ì–´ ëª‡ê°œ??stampê°€ ?ë¦½?˜ì—ˆ?”ì? ê¸°ë¡?œë‹¤. 
     * 
     * @param stamp
     * @return
     */
    int insert(Stamp stamp);
    
    /**
     * id ?¬ìš©?ì˜ Stamp ?´ë ¥??ë°˜í™˜?œë‹¤.
     * @param userId
     * @return
     */
    List<Stamp> selectByUserId(String userId);
}

