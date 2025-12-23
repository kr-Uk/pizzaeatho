package com.ssafy.pizza.model.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ssafy.pizza.model.dao.OrderDao;
import com.ssafy.pizza.model.dao.OrderDetailDao;
import com.ssafy.pizza.model.dto.Order;
import com.ssafy.pizza.model.dto.OrderCreateRequest;
import com.ssafy.pizza.model.dto.OrderCreateResponse;
import com.ssafy.pizza.model.dto.OrderDetail;
import com.ssafy.pizza.model.dto.OrderDetailResponse;
import com.ssafy.pizza.model.dto.OrderDetailTopping;
import com.ssafy.pizza.model.dto.OrderDetailView;
import com.ssafy.pizza.model.dto.OrderListItem;
import com.ssafy.pizza.model.dto.OrderToppingInfo;
import com.ssafy.pizza.model.dto.OrderToppingRequest;

@Service
public class OrderServiceImpl implements OrderService {

    @Autowired
    private OrderDao oDao;

    @Autowired
    private OrderDetailDao dDao;

    @Override
    @Transactional
    public OrderCreateResponse createOrder(List<OrderCreateRequest> requests) {
        if (requests == null || requests.isEmpty()) {
            return null;
        }

        OrderCreateRequest first = requests.get(0);
        Order order = new Order();
        order.setUserId(first.getUserId());
        order.setOrderTable(first.getUserName());
        order.setStatus("RECEIVED");
        oDao.insertOrder(order);

        for (OrderCreateRequest request : requests) {
            OrderDetail detail = new OrderDetail();
            detail.setOrderId(order.getOrderId());
            detail.setProductId(request.getProductId());
            detail.setDoughId(request.getDoughId());
            detail.setCrustId(request.getCrustId());
            detail.setQuantity(1);
            detail.setUnitPrice(request.getUnitPrice());
            dDao.insertOrderDetail(detail);

            List<OrderToppingRequest> toppings = request.getToppings();
            if (toppings != null) {
                for (OrderToppingRequest topping : toppings) {
                    OrderDetailTopping detailTopping = new OrderDetailTopping();
                    detailTopping.setOrderDetailId(detail.getOrderDetailId());
                    detailTopping.setToppingId(topping.getToppingId());
                    detailTopping.setQuantity(topping.getQuantity());
                    dDao.insertOrderDetailTopping(detailTopping);
                }
            }
        }

        return new OrderCreateResponse(order.getOrderId(), order.getStatus());
    }

    @Override
    public List<OrderListItem> getOrdersByUser(Integer userId) {
        return oDao.selectByUser(userId);
    }

    @Override
    public List<OrderDetailResponse> getOrderDetail(Integer orderId) {
        List<OrderDetailView> views = oDao.selectOrderDetailView(orderId);
        List<OrderDetailResponse> responses = new ArrayList<>();
        if (views == null || views.isEmpty()) {
            return responses;
        }
        for (OrderDetailView view : views) {
            List<OrderToppingInfo> toppings = new ArrayList<>();
            if (view.getOrderDetailId() != null) {
                toppings = oDao.selectToppingsByOrderDetail(view.getOrderDetailId());
            }
            responses.add(new OrderDetailResponse(
                    view.getOrderId(),
                    view.getProduct(),
                    view.getDough(),
                    view.getCrust(),
                    toppings,
                    view.getUnitPrice(),
                    view.getStatus()
            ));
        }
        return responses;
    }

    @Override
    public OrderCreateResponse updateOrderStatus(Integer orderId, String status) {
        oDao.updateStatus(orderId, status);
        return new OrderCreateResponse(orderId, status);
    }

    @Override
    public List<OrderListItem> getRecent6MonthsOrders(Integer userId) {
        return oDao.selectRecent6MonthsByUser(userId);
    }

    @Override
    public List<OrderListItem> getActiveOrdersByUser(Integer userId) {
        return oDao.selectByUserNotDone(userId);
    }
}

