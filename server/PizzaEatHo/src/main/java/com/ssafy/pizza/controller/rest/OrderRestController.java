package com.ssafy.pizza.controller.rest;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.ssafy.pizza.model.dto.OrderCreateRequest;
import com.ssafy.pizza.model.dto.OrderCreateResponse;
import com.ssafy.pizza.model.dto.OrderDetailResponse;
import com.ssafy.pizza.model.dto.OrderListItem;
import com.ssafy.pizza.model.dto.OrderStatusUpdateRequest;
import com.ssafy.pizza.model.service.OrderService;

@RestController
@RequestMapping("/pizza/order")
@CrossOrigin("*")
public class OrderRestController {

    @Autowired
    private OrderService oService;

    @PostMapping("")
    public OrderCreateResponse createOrder(@RequestBody OrderCreateRequest request) {
        return oService.createOrder(request);
    }

    @GetMapping("/user/{userId}")
    public List<OrderListItem> getOrdersByUser(@PathVariable Integer userId) {
        return oService.getOrdersByUser(userId);
    }

    @GetMapping("/{orderId}")
    public OrderDetailResponse getOrderDetail(@PathVariable Integer orderId) {
        return oService.getOrderDetail(orderId);
    }

    @PatchMapping("/{orderId}/status")
    public OrderCreateResponse updateStatus(
            @PathVariable Integer orderId,
            @RequestBody OrderStatusUpdateRequest request) {
        return oService.updateOrderStatus(orderId, request.getStatus());
    }

    @GetMapping({"/recent", "/recent-6months"})
    public List<OrderListItem> getRecent6MonthsOrders() {
        return oService.getRecent6MonthsOrders();
    }
}

