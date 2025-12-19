package com.ssafy.pizza.model.dao;

import com.ssafy.pizza.model.dto.OrderDetail;
import com.ssafy.pizza.model.dto.OrderDetailTopping;

public interface OrderDetailDao {
    int insertOrderDetail(OrderDetail detail);

    int insertOrderDetailTopping(OrderDetailTopping topping);
}

