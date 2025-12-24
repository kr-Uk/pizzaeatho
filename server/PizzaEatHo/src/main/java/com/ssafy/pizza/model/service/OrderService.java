package com.ssafy.pizza.model.service;

import java.util.List;

import com.ssafy.pizza.model.dto.OrderCreateRequest;
import com.ssafy.pizza.model.dto.OrderCreateResponse;
import com.ssafy.pizza.model.dto.OrderDetailResponse;
import com.ssafy.pizza.model.dto.OrderListItem;

public interface OrderService {
    OrderCreateResponse createOrder(List<OrderCreateRequest> requests);

    List<OrderListItem> getOrdersByUser(Integer userId);

    List<OrderDetailResponse> getOrderDetail(Integer orderId);

    OrderCreateResponse updateOrderStatus(Integer orderId, String status);

    List<OrderListItem> getRecent6MonthsOrders(Integer userId);

    List<OrderListItem> getActiveOrdersByUser(Integer userId);
}

