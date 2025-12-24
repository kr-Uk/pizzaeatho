package com.ssafy.pizza.model.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.ssafy.pizza.model.dto.Order;
import com.ssafy.pizza.model.dto.OrderDetailView;
import com.ssafy.pizza.model.dto.OrderListItem;
import com.ssafy.pizza.model.dto.OrderToppingInfo;

public interface OrderDao {
    int insertOrder(Order order);

    int updateStatus(@Param("orderId") Integer orderId, @Param("status") String status);

    List<OrderListItem> selectByUser(@Param("userId") Integer userId);

    List<OrderListItem> selectAll();

    List<OrderDetailView> selectOrderDetailView(@Param("orderId") Integer orderId);

    List<OrderToppingInfo> selectToppingsByOrderDetail(@Param("orderDetailId") Integer orderDetailId);

    List<OrderListItem> selectRecent6MonthsByUser(@Param("userId") Integer userId);

    List<OrderListItem> selectByUserNotDone(@Param("userId") Integer userId);

    String selectFcmTokenByOrderId(@Param("orderId") Integer orderId);
}

