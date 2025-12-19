package com.ssafy.pizza.model.service;

import java.util.List;

import com.ssafy.pizza.model.dto.Crust;
import com.ssafy.pizza.model.dto.Dough;
import com.ssafy.pizza.model.dto.Product;
import com.ssafy.pizza.model.dto.Topping;

public interface ProductService {
    List<Product> getProductList();

    List<Topping> getDefaultToppings(Integer productId);

    List<Topping> getAllToppings();

    List<Dough> getAllDough();

    List<Crust> getAllCrust();
}

